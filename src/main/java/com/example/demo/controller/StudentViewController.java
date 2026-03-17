package com.example.demo.controller;

import com.example.demo.service.DemoStudentService;
import com.example.demo.repository.ExamAttemptRepository;
import com.example.demo.repository.PackagePurchaseRepository;
import com.example.demo.repository.PaymentRepository;
import com.example.demo.entity.PackagePurchase.PurchaseStatus;
import com.example.demo.entity.Payment.PaymentStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

@Controller
public class StudentViewController {

    private final PackagePurchaseRepository packagePurchaseRepository;
    private final PaymentRepository paymentRepository;
    private final ExamAttemptRepository examAttemptRepository;
    private final DemoStudentService demoStudentService;

    public StudentViewController(PackagePurchaseRepository packagePurchaseRepository,
                                 PaymentRepository paymentRepository,
                                 ExamAttemptRepository examAttemptRepository,
                                 DemoStudentService demoStudentService) {
        this.packagePurchaseRepository = packagePurchaseRepository;
        this.paymentRepository = paymentRepository;
        this.examAttemptRepository = examAttemptRepository;
        this.demoStudentService = demoStudentService;
    }

    @GetMapping("/my-packages")
    public String myPackages(@RequestParam(required = false) String q,
                             @RequestParam(required = false) String status,
                             @RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "20") int size,
                             Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        PurchaseStatus st = null;
        if (status != null && !status.isBlank()) st = PurchaseStatus.valueOf(status);
        var pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "purchaseDate"));
        var purchases = packagePurchaseRepository.search(studentId, st, (q == null || q.isBlank()) ? null : q, pageable);
        model.addAttribute("purchases", purchases);
        model.addAttribute("q", q);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "student/my-packages";
    }

    @GetMapping("/payment-history")
    public String paymentHistory(@RequestParam(required = false) String q,
                                 @RequestParam(required = false) String status,
                                 @RequestParam(required = false) String from,
                                 @RequestParam(required = false) String to,
                                 @RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "20") int size,
                                 Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        PaymentStatus st = null;
        if (status != null && !status.isBlank()) st = PaymentStatus.valueOf(status);
        var pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "paymentDate"));
        var fromDt = (from == null || from.isBlank()) ? null : java.time.LocalDate.parse(from).atStartOfDay();
        var toDt = (to == null || to.isBlank()) ? null : java.time.LocalDate.parse(to).atTime(23, 59, 59);
        var payments = paymentRepository.search(studentId, st, (q == null || q.isBlank()) ? null : q, fromDt, toDt, pageable);
        model.addAttribute("transactions", payments);
        model.addAttribute("q", q);
        model.addAttribute("status", status);
        model.addAttribute("from", from);
        model.addAttribute("to", to);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "student/payment-history";
    }

    @GetMapping("/exam-history")
    public String examHistory(@RequestParam(required = false) String q,
                              @RequestParam(required = false) String from,
                              @RequestParam(required = false) String to,
                              @RequestParam(defaultValue = "0") int page,
                              @RequestParam(defaultValue = "20") int size,
                              Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        var pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "submittedAt"));
        var fromDt = (from == null || from.isBlank()) ? null : java.time.LocalDate.parse(from).atStartOfDay();
        var toDt = (to == null || to.isBlank()) ? null : java.time.LocalDate.parse(to).atTime(23, 59, 59);
        var results = examAttemptRepository.search(studentId, (q == null || q.isBlank()) ? null : q, fromDt, toDt, pageable);
        model.addAttribute("results", results);
        model.addAttribute("q", q);
        model.addAttribute("from", from);
        model.addAttribute("to", to);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "student/exam-history";
    }

    @GetMapping("/exam-history/{id}")
    public String examHistoryDetail(@PathVariable java.util.UUID id, Model model) {
        model.addAttribute("result", examAttemptRepository.findById(id)
                .orElseThrow(() -> new com.example.demo.exception.ResourceNotFoundException("Attempt not found " + id)));
        return "student/exam-detail";
    }
}

