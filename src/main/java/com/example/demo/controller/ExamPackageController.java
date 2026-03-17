package com.example.demo.controller;

import com.example.demo.dto.ExamPackageDto;
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

    public ExamPackageController(ExamPackageService examPackageService) {
        this.examPackageService = examPackageService;
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
        model.addAttribute("examPackage", examPackage);
        return "packages/detail";
    }
}

