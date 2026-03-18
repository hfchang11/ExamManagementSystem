package com.example.demo.repository;

import com.example.demo.entity.PackageReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PackageReviewRepository extends JpaRepository<PackageReview, UUID> {

    List<PackageReview> findByExamPackage_IdOrderByCreatedAtDesc(UUID packageId);
}

