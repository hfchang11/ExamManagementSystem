    package com.example.demo.controller;

    import com.example.demo.entity.Payment;
    import com.example.demo.service.CheckoutService;
    import com.example.demo.service.DemoStudentService;
    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestParam;

    import java.util.UUID;

    @Controller
    public class PurchaseController {

        private final CheckoutService checkoutService;
        private final DemoStudentService demoStudentService;

        public PurchaseController(CheckoutService checkoutService,
                                  DemoStudentService demoStudentService) {
            this.checkoutService = checkoutService;
            this.demoStudentService = demoStudentService;
        }

        @GetMapping("/purchase/{packageId}")
        public String purchaseCheckout(@PathVariable UUID packageId, Model model) {
            UUID studentId = demoStudentService.resolveDemoStudentId();
            Payment payment = checkoutService.createCheckout(studentId, packageId);

            model.addAttribute("examPackage", payment.getPurchase().getExamPackage());
            model.addAttribute("payment", payment);

            // dữ liệu tạo VietQR: stk 855688886666 Techcombank, amount, content = "PAY-" + tx.id
            String accountNo = "855688886666";
            String amount = payment.getAmount().toPlainString();
            String addInfo = payment.getTransactionId();

            // sử dụng API public VietQR (ví dụ dạng link image tạm, trong thực tế cần call REST)
            String qrUrl = "https://img.vietqr.io/image/techcombank-" + accountNo +
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

