package com.example.demo.mapper;

import com.example.demo.dto.ExamPackageDto;
import com.example.demo.entity.ExamPackage;

public class ExamPackageMapper {

    private ExamPackageMapper() {
    }

    public static ExamPackageDto toDto(ExamPackage entity) {
        ExamPackageDto dto = new ExamPackageDto();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setNumberOfExams(entity.getNumberOfExams());
        dto.setPrice(entity.getPrice());
        dto.setAverageRating(entity.getAverageRating());
        return dto;
    }
}

