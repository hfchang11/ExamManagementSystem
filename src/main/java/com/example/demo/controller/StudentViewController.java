package com.example.demo.controller;

import com.example.demo.service.DemoStudentService;
import com.example.demo.service.ExamPackageService;
import com.example.demo.repository.ExamAttemptRepository;
import com.example.demo.repository.ExamRepository;
import com.example.demo.repository.PackagePurchaseRepository;
import com.example.demo.repository.PaymentRepository;
import com.example.demo.entity.Payment.PaymentStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

import java.util.UUID;

@Controller
public class StudentViewController {

    private final PackagePurchaseRepository packagePurchaseRepository;
    private final PaymentRepository paymentRepository;
    private final ExamAttemptRepository examAttemptRepository;
    private final ExamPackageService examPackageService;
    private final DemoStudentService demoStudentService;
    private final ExamRepository examRepository;

    public StudentViewController(PackagePurchaseRepository packagePurchaseRepository,
                                 PaymentRepository paymentRepository,
                                 ExamAttemptRepository examAttemptRepository,
                                 ExamPackageService examPackageService,
                                 DemoStudentService demoStudentService,
                                 ExamRepository examRepository) {
        this.packagePurchaseRepository = packagePurchaseRepository;
        this.paymentRepository = paymentRepository;
        this.examAttemptRepository = examAttemptRepository;
        this.examPackageService = examPackageService;
        this.demoStudentService = demoStudentService;
        this.examRepository = examRepository;
    }

    @GetMapping("/my-packages")
    public String myPackages(@RequestParam(required = false) String q,
                             @RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size,
                             Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        // NOTE: sorting is done inside repository query by PackagePurchase.purchaseDate
        // (we cannot sort by purchaseDate via Pageable since the query selects ExamPackage).
        var pageable = PageRequest.of(page, size);
        var packages = examPackageService.getPurchasedPackages(studentId, pageable, q);

        // KPI cards like template
        model.addAttribute("kpiTotalPackages", packages.getTotalElements());
        model.addAttribute("kpiTotalAttempts", examAttemptRepository.countAllByStudent(studentId));
        model.addAttribute("kpiAvgScore", examAttemptRepository.avgScoreByStudent(studentId));

        model.addAttribute("packages", packages);
        model.addAttribute("q", q);
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
                                 @RequestParam(defaultValue = "10") int size,
                                 Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        PaymentStatus st = null;
        if (status != null && !status.isBlank()) st = PaymentStatus.valueOf(status);
        var pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "paymentDate"));
        var fromDt = (from == null || from.isBlank()) ? null : java.time.LocalDate.parse(from).atStartOfDay();
        var toDt = (to == null || to.isBlank()) ? null : java.time.LocalDate.parse(to).atTime(23, 59, 59);
        var payments = paymentRepository.search(studentId, st, (q == null || q.isBlank()) ? null : q, fromDt, toDt, pageable);

        // KPI cards (match UI)
        model.addAttribute("kpiTotalTx", paymentRepository.countAllByStudent(studentId));
        model.addAttribute("kpiSuccessTx", paymentRepository.countByStudentAndStatus(studentId, PaymentStatus.SUCCESS));
        model.addAttribute("kpiFailedTx", paymentRepository.countByStudentAndStatus(studentId, PaymentStatus.FAILED));
        model.addAttribute("kpiTotalSpend", paymentRepository.sumAmountByStudentAndStatus(studentId, PaymentStatus.SUCCESS));

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
                              @RequestParam(defaultValue = "10") int size,
                              Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        var pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "submittedAt"));
        var fromDt = (from == null || from.isBlank()) ? null : java.time.LocalDate.parse(from).atStartOfDay();
        var toDt = (to == null || to.isBlank()) ? null : java.time.LocalDate.parse(to).atTime(23, 59, 59);
        var results = examAttemptRepository.search(studentId, (q == null || q.isBlank()) ? null : q, fromDt, toDt, pageable);

        // KPI cards (match UI)
        model.addAttribute("kpiTotalAttempts", examAttemptRepository.countAllByStudent(studentId));
        model.addAttribute("kpiAvgScore", examAttemptRepository.avgScoreByStudent(studentId));
        model.addAttribute("kpiBestScore", examAttemptRepository.maxScoreByStudent(studentId));
        model.addAttribute("kpiTotalCorrect", examAttemptRepository.sumCorrectByStudent(studentId));

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

    @GetMapping("/my-packages/{id}")
    public String myPackageDetail(@PathVariable UUID id, Model model) {
        var studentId = demoStudentService.resolveDemoStudentId();
        var pkg = examPackageService.getById(id);
        var exams = examRepository.findByPackageId(id);

        int doneCount = 0;
        for (var exam : exams) {
            long cnt = examAttemptRepository.countByStudentIdAndExam_Id(studentId, exam.getId());
            if (cnt > 0) doneCount++;
        }

        model.addAttribute("examPackage", pkg);
        model.addAttribute("exams", exams);
        model.addAttribute("examCount", exams.size());
        model.addAttribute("examDoneCount", doneCount);
        return "student/my-package-detail";
    }
}

