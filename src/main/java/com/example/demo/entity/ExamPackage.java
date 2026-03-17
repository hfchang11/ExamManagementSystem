package com.example.demo.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "exam_packages")
public class ExamPackage {

    public enum PackageStatus {
        ACTIVE,
        INACTIVE,
        DRAFT
    }

    @Id
    @Column(name = "package_id")
    private UUID id;

    @Column(name = "package_name")
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Transient
    private Integer numberOfExams;

    private BigDecimal price;

    @Transient
    private Double averageRating;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private PackageStatus status = PackageStatus.ACTIVE;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

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

    public PackageStatus getStatus() {
        return status;
    }

    public void setStatus(PackageStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

