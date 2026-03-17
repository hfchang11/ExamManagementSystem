package com.example.demo.service;

import com.example.demo.dto.ExamPackageDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.UUID;

public interface ExamPackageService {

    Page<ExamPackageDto> getActivePackages(Pageable pageable, String q, String sortBy, String direction);

    Page<ExamPackageDto> getPurchasedPackages(UUID studentId, Pageable pageable, String q);

    ExamPackageDto getById(UUID id);
}

