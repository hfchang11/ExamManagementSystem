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

    @Query(value = """
            select pp.package_id as packageId, count(distinct pp.student_id) as studentCount
            from package_purchases pp
            where pp.package_id in (:packageIds)
              and pp.status = 'COMPLETED'
            group by pp.package_id
            """, nativeQuery = true)
    java.util.List<java.util.Map<String, Object>> studentCountByPackageIds(@Param("packageIds") java.util.List<java.util.UUID> packageIds);

    boolean existsByStudentIdAndExamPackage_IdAndStatus(UUID studentId, UUID packageId, PurchaseStatus status);
}

