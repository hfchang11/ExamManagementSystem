package com.example.demo.repository;

import com.example.demo.entity.Exam;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface ExamRepository extends JpaRepository<Exam, UUID> {

    @Query(
            value = """
                    select e.*
                    from exams e
                    join package_exams pe on pe.exam_id = e.exam_id
                    where pe.package_id = :packageId
                    order by e.created_at
                    """,
            nativeQuery = true
    )
    List<Exam> findByPackageId(@Param("packageId") UUID packageId);
}

