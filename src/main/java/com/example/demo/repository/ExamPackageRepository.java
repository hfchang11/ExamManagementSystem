package com.example.demo.repository;

import com.example.demo.entity.ExamPackage;
import com.example.demo.entity.ExamPackage.PackageStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface ExamPackageRepository extends JpaRepository<ExamPackage, UUID> {

    @Query("""
            select p from ExamPackage p
            where p.status = :status
              and (:q is null or lower(p.name) like lower(concat('%', :q, '%')))
            """)
    Page<ExamPackage> searchByStatus(@Param("status") PackageStatus status,
                                    @Param("q") String q,
                                    Pageable pageable);

    @Query(value = """
            select pe.package_id as packageId, count(*) as examCount
            from package_exams pe
            where pe.package_id in (:packageIds)
            group by pe.package_id
            """, nativeQuery = true)
    List<Map<String, Object>> countExamsByPackageIds(@Param("packageIds") List<UUID> packageIds);

    @Query(value = """
            select pr.package_id as packageId, avg(cast(pr.rating as float)) as avgRating
            from package_reviews pr
            where pr.package_id in (:packageIds)
            group by pr.package_id
            """, nativeQuery = true)
    List<Map<String, Object>> avgRatingByPackageIds(@Param("packageIds") List<UUID> packageIds);

    @Query(
            value = """
                    select
                        ep.package_id,
                        ep.package_name,
                        ep.description,
                        ep.price,
                        ep.status,
                        ep.created_at
                    from exam_packages ep
                    join (
                        select pp.package_id as package_id, max(pp.purchase_date) as last_purchase_date
                        from package_purchases pp
                        where pp.student_id = :studentId
                          and pp.status = 'COMPLETED'
                        group by pp.package_id
                    ) x on x.package_id = ep.package_id
                    where (:q is null or lower(ep.package_name) like lower(concat('%', :q, '%')))
                    order by x.last_purchase_date desc
                    """,
            countQuery = """
                    select count(*)
                    from (
                        select pp.package_id
                        from package_purchases pp
                        join exam_packages ep on ep.package_id = pp.package_id
                        where pp.student_id = :studentId
                          and pp.status = 'COMPLETED'
                          and (:q is null or lower(ep.package_name) like lower(concat('%', :q, '%')))
                        group by pp.package_id
                    ) c
                    """,
            nativeQuery = true
    )
    Page<ExamPackage> findPurchasedPackages(@Param("studentId") UUID studentId,
                                           @Param("q") String q,
                                           Pageable pageable);
}

