package com.example.demo.dto;

import java.math.BigDecimal;
import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
public class ExamPackageDto {

    private UUID id;
    private String name;
    private String description;
    private Integer numberOfExams;
    private BigDecimal price;
    private Double averageRating;
    private Integer reviewCount;
    private Integer studentCount;

    // getters and setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getNumberOfExams() {
        return numberOfExams;
    }

    public void setNumberOfExams(Integer numberOfExams) {
        this.numberOfExams = numberOfExams;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

    public Integer getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
    }

    public Integer getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(Integer studentCount) {
        this.studentCount = studentCount;
    }
}

