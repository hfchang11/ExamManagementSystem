package com.example.demo.controller;

import com.example.demo.entity.Payment;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.PaymentRepository;
import com.example.demo.service.CheckoutService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/payments")
public class PaymentStatusController {

    private final PaymentRepository paymentRepository;
    private final CheckoutService checkoutService;

    public PaymentStatusController(PaymentRepository paymentRepository, CheckoutService checkoutService) {
        this.paymentRepository = paymentRepository;
        this.checkoutService = checkoutService;
    }

    @GetMapping("/{paymentId}/status")
    public Map<String, Object> status(@PathVariable UUID paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found " + paymentId));
        return Map.of(
                "paymentId", payment.getId().toString(),
                "status", payment.getPaymentStatus().name()
        );
    }

    // Demo helper: simulate payment success/failure without real gateway/webhook
    @PostMapping("/{paymentId}/simulate")
    public Map<String, Object> simulate(@PathVariable UUID paymentId,
                                        @RequestParam(defaultValue = "true") boolean success) {
        Payment payment = checkoutService.completePayment(paymentId, success);
        return Map.of(
                "paymentId", payment.getId().toString(),
                "status", payment.getPaymentStatus().name()
        );
    }
}

