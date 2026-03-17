package com.example.demo.repository;

import com.example.demo.entity.PackagePurchase;
import com.example.demo.entity.PackagePurchase.PurchaseStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

public interface PackagePurchaseRepository extends JpaRepository<PackagePurchase, UUID> {

    @Query("""
            select p from PackagePurchase p
            join p.examPackage ep
            where p.studentId = :studentId
              and (:status is null or p.status = :status)
              and (:q is null or lower(ep.name) like lower(concat('%', :q, '%')))
            """)
    Page<PackagePurchase> search(@Param("studentId") UUID studentId,
                                @Param("status") PurchaseStatus status,
                                @Param("q") String q,
                                Pageable pageable);
}

