package com.example.demo.controller;

import com.example.demo.dto.ExamPackageDto;
import com.example.demo.repository.ExamRepository;
import com.example.demo.repository.PackageReviewRepository;
import com.example.demo.service.ExamPackageService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.UUID;

@Controller
public class ExamPackageController {

    private final ExamPackageService examPackageService;
    private final ExamRepository examRepository;
    private final PackageReviewRepository packageReviewRepository;

    public ExamPackageController(ExamPackageService examPackageService,
                                 ExamRepository examRepository,
                                 PackageReviewRepository packageReviewRepository) {
        this.examPackageService = examPackageService;
        this.examRepository = examRepository;
        this.packageReviewRepository = packageReviewRepository;
    }

    @GetMapping("/packages")
    public String listPackages(@RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "20") int size,
                               @RequestParam(required = false) String q,
                               @RequestParam(required = false) String sortBy,
                               @RequestParam(required = false) String direction,
                               Model model) {
        Pageable pageable = PageRequest.of(page, size);
        Page<ExamPackageDto> packages = examPackageService.getActivePackages(pageable, q, sortBy, direction);

        model.addAttribute("packages", packages);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("q", q);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("direction", direction);
        return "packages/list";
    }

    @GetMapping("/packages/{id}")
    public String packageDetail(@PathVariable UUID id, Model model) {
        ExamPackageDto examPackage = examPackageService.getById(id);
        var exams = examRepository.findByPackageId(id);
        var reviews = packageReviewRepository.findByExamPackage_IdOrderByCreatedAtDesc(id);

        model.addAttribute("examPackage", examPackage);
        model.addAttribute("exams", exams);
        model.addAttribute("examCount", exams.size());
        model.addAttribute("reviews", reviews);
        return "packages/detail";
    }
}

