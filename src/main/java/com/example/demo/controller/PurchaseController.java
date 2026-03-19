package com.example.demo.controller;

import com.example.demo.entity.PackagePurchase;
import com.example.demo.entity.Payment;
import com.example.demo.repository.PackagePurchaseRepository;
import com.example.demo.service.CheckoutService;
import com.example.demo.service.DemoStudentService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
@Controller
public class PurchaseController {

    private final CheckoutService checkoutService;
    private final DemoStudentService demoStudentService;
    private final PackagePurchaseRepository packagePurchaseRepository;
    private final String bankCode;
    private final String accountNo;

    public PurchaseController(CheckoutService checkoutService,
                              DemoStudentService demoStudentService,
                              PackagePurchaseRepository packagePurchaseRepository,
                              @Value("${payment.bank-code}") String bankCode,
                              @Value("${payment.account-no}") String accountNo) {
        this.checkoutService = checkoutService;
        this.demoStudentService = demoStudentService;
        this.packagePurchaseRepository = packagePurchaseRepository;
        this.bankCode = bankCode;
        this.accountNo = accountNo;
    }

    @GetMapping("/purchase/{packageId}")
    public String purchaseCheckout(@PathVariable UUID packageId,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        UUID studentId = demoStudentService.resolveDemoStudentId();
        boolean alreadyOwned = packagePurchaseRepository.existsByStudentIdAndExamPackage_IdAndStatus(
                studentId, packageId, PackagePurchase.PurchaseStatus.COMPLETED);
        if (alreadyOwned) {
            redirectAttributes.addFlashAttribute("alertType", "warning");
            redirectAttributes.addFlashAttribute("alertMessage", "Bạn đã mua gói này rồi. Hãy tiếp tục học trong \"Gói đề thi của tôi\".");
            return "redirect:/my-packages/" + packageId;
        }

        Payment payment = checkoutService.createCheckout(studentId, packageId);

            model.addAttribute("examPackage", payment.getPurchase().getExamPackage());
            model.addAttribute("payment", payment);

            String amount = payment.getAmount().toPlainString();
            String addInfo = payment.getTransactionId();

            String qrUrl = "https://img.vietqr.io/image/" + bankCode + "-" + accountNo +
                    "-compact.png?amount=" + amount + "&addInfo=" + addInfo;

            model.addAttribute("vietQrUrl", qrUrl);
            model.addAttribute("accountNo", accountNo);
            model.addAttribute("amount", amount);
            model.addAttribute("addInfo", addInfo);
        return "purchase/checkout";
    }

    @GetMapping("/payment/callback")
    public String paymentCallback(@RequestParam UUID paymentId,
                                  @RequestParam(defaultValue = "true") boolean success,
                                  Model model) {
        Payment payment = checkoutService.completePayment(paymentId, success);
        model.addAttribute("payment", payment);
        return "purchase/result";
    }
}

