package com.example.demo.controller;

import com.example.demo.dto.SepayWebhookDto;
import com.example.demo.entity.PackagePurchase;
import com.example.demo.entity.Payment;
import com.example.demo.repository.PackagePurchaseRepository;
import com.example.demo.repository.PaymentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/*
 * Cu Thi Huyen Trang
 */
@RestController
@RequestMapping("/webhook/sepay")
public class SepayWebhookController {

    private static final Logger log = LoggerFactory.getLogger(SepayWebhookController.class);
    // SePay/bank may strip '-' from transfer content, so support:
    // - PAY-<uuid> (36 chars)
    // - PAY<uuid-without-dashes> (32 hex)
    private static final Pattern PAY_TOKEN = Pattern.compile("PAY-?[0-9a-fA-F]{32}|PAY-[0-9a-fA-F\\-]{10,}");

    private final String apiKey;
    private final PaymentRepository paymentRepository;
    private final PackagePurchaseRepository packagePurchaseRepository;

    public SepayWebhookController(@Value("${sepay.api-key}") String apiKey,
                                  PaymentRepository paymentRepository,
                                  PackagePurchaseRepository packagePurchaseRepository) {
        this.apiKey = apiKey;
        this.paymentRepository = paymentRepository;
        this.packagePurchaseRepository = packagePurchaseRepository;
    }

    @PostMapping
    @Transactional
    public ResponseEntity<?> handle(@RequestHeader(value = "Authorization", required = false) String authorization,
                                    @RequestBody SepayWebhookDto body) {
        // Verify API key: "Authorization: Apikey <key>"
        String expected = "Apikey " + apiKey;
        if (authorization == null || !authorization.equals(expected)) {
            log.warn("SePay webhook unauthorized. Authorization='{}' expected='{}'", authorization, expected);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("ok", false, "message", "Unauthorized"));
        }

        // We match by transactionId we generated: "PAY-<paymentId>"
        // SePay usually includes it in content/description if user transferred with that message.
        String haystack = ((body.getContent() == null ? "" : body.getContent()) + " " +
                (body.getDescription() == null ? "" : body.getDescription())).trim();

        // Quick extract: find token starting with "PAY"
        String txId = extractPayToken(haystack);
        log.info("SePay webhook received: gateway={} amount={} transferType={} referenceCode={} extractedTxId={} content='{}'",
                body.getGateway(), body.getTransferAmount(), body.getTransferType(), body.getReferenceCode(), txId, haystack);
        if (txId == null) {
            return ResponseEntity.ok(Map.of(
                    "ok", true,
                    "message", "No PAY-* token found; ignore"
            ));
        }

        // Normalize token to match DB format "PAY-<uuid>"
        String normalizedTxId = normalizeTxId(txId);
        Payment payment = paymentRepository.findByTransactionId(normalizedTxId).orElse(null);
        if (payment == null) {
            log.warn("SePay webhook: payment not found for transactionId={}", txId);
            return ResponseEntity.ok(Map.of(
                    "ok", true,
                    "message", "Payment not found for transactionId",
                    "transactionId", normalizedTxId
            ));
        }

        // Only confirm incoming transfers
        if (body.getTransferType() != null && !"in".equalsIgnoreCase(body.getTransferType())) {
            return ResponseEntity.ok(Map.of("ok", true, "message", "Not an incoming transfer"));
        }

        // Idempotent update
        if (payment.getPaymentStatus() != Payment.PaymentStatus.SUCCESS) {
            payment.setPaymentStatus(Payment.PaymentStatus.SUCCESS);
            payment.setPaymentDate(LocalDateTime.now());
            paymentRepository.save(payment);

            PackagePurchase purchase = payment.getPurchase();
            if (purchase.getStatus() != PackagePurchase.PurchaseStatus.COMPLETED) {
                purchase.setStatus(PackagePurchase.PurchaseStatus.COMPLETED);
                packagePurchaseRepository.save(purchase);
            }
        }

        return ResponseEntity.ok(Map.of("ok", true, "transactionId", normalizedTxId));
    }

    private static String extractPayToken(String text) {
        if (text == null) return null;
        Matcher m = PAY_TOKEN.matcher(text);
        if (!m.find()) return null;
        return m.group();
    }

    private static String normalizeTxId(String txId) {
        if (txId == null) return null;
        // already "PAY-..."
        if (txId.startsWith("PAY-")) return txId;
        // "PAY" + 32 hex -> convert to UUID and prefix PAY-
        if (txId.startsWith("PAY") && txId.length() == 3 + 32) {
            String hex = txId.substring(3);
            String uuid = hex.substring(0, 8) + "-" +
                    hex.substring(8, 12) + "-" +
                    hex.substring(12, 16) + "-" +
                    hex.substring(16, 20) + "-" +
                    hex.substring(20);
            return "PAY-" + uuid;
        }
        // fallback: try to just prefix PAY-
        if (txId.startsWith("PAY")) return "PAY-" + txId.substring(3);
        return txId;
    }
}

