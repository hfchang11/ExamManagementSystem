package com.example.demo.service.impl;

import com.example.demo.dto.ExamPackageDto;
import com.example.demo.entity.ExamPackage;
import com.example.demo.entity.ExamPackage.PackageStatus;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.mapper.ExamPackageMapper;
import com.example.demo.repository.ExamPackageRepository;
import com.example.demo.service.ExamPackageService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class ExamPackageServiceImpl implements ExamPackageService {

    private final ExamPackageRepository examPackageRepository;

    public ExamPackageServiceImpl(ExamPackageRepository examPackageRepository) {
        this.examPackageRepository = examPackageRepository;
    }

    @Override
    public Page<ExamPackageDto> getActivePackages(Pageable pageable, String q, String sortBy, String direction) {
        String sortField = (sortBy == null || sortBy.isBlank()) ? "createdAt" : sortBy;
        Sort sort = Sort.by(Sort.Direction.DESC, sortField);
        if ("asc".equalsIgnoreCase(direction)) {
            sort = Sort.by(Sort.Direction.ASC, sortField);
        }
        Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);
        String keyword = (q == null || q.isBlank()) ? null : q;
        var pageEntities = examPackageRepository.searchByStatus(PackageStatus.ACTIVE, keyword, sortedPageable);

        // batch enrich numberOfExams & avgRating from real DB tables
        List<UUID> ids = pageEntities.getContent().stream().map(ExamPackage::getId).toList();
        Map<UUID, Integer> examCounts = new HashMap<>();
        Map<UUID, Double> avgRatings = new HashMap<>();
        if (!ids.isEmpty()) {
            for (Map<String, Object> row : examPackageRepository.countExamsByPackageIds(ids)) {
                Object rawId = row.get("packageId");
                UUID id = (rawId instanceof UUID) ? (UUID) rawId : UUID.fromString(String.valueOf(rawId));
                Number cnt = (Number) row.get("examCount");
                examCounts.put(id, cnt == null ? 0 : cnt.intValue());
            }
            for (Map<String, Object> row : examPackageRepository.avgRatingByPackageIds(ids)) {
                Object rawId = row.get("packageId");
                UUID id = (rawId instanceof UUID) ? (UUID) rawId : UUID.fromString(String.valueOf(rawId));
                Number avg = (Number) row.get("avgRating");
                avgRatings.put(id, avg == null ? null : avg.doubleValue());
            }
        }

        return pageEntities.map(e -> {
            ExamPackageDto dto = ExamPackageMapper.toDto(e);
            dto.setNumberOfExams(examCounts.getOrDefault(e.getId(), 0));
            dto.setAverageRating(avgRatings.get(e.getId()));
            return dto;
        });
    }

    @Override
    public ExamPackageDto getById(UUID id) {
        ExamPackage examPackage = examPackageRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Exam package not found with id " + id));
        return ExamPackageMapper.toDto(examPackage);
    }
}

