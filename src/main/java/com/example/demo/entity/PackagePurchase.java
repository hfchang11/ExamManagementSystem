package com.example.demo.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDateTime;
import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
@Entity
@Table(name = "package_purchases")
public class PackagePurchase {

    public enum PurchaseStatus {
        PENDING,
        COMPLETED,
        CANCELLED
    }

    @Id
    @GeneratedValue
    @UuidGenerator
    @Column(name = "purchase_id")
    private UUID id;

    @Column(name = "student_id", nullable = false)
    private UUID studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "package_id", nullable = false)
    private ExamPackage examPackage;

    @Column(name = "purchase_date")
    private LocalDateTime purchaseDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private PurchaseStatus status;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getStudentId() {
        return studentId;
    }

    public void setStudentId(UUID studentId) {
        this.studentId = studentId;
    }

    public ExamPackage getExamPackage() {
        return examPackage;
    }

    public void setExamPackage(ExamPackage examPackage) {
        this.examPackage = examPackage;
    }

    public LocalDateTime getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(LocalDateTime purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public PurchaseStatus getStatus() {
        return status;
    }

    public void setStatus(PurchaseStatus status) {
        this.status = status;
    }
}

