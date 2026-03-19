package com.example.demo.repository;

import com.example.demo.entity.ExamAttempt;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
public interface ExamAttemptRepository extends JpaRepository<ExamAttempt, UUID> {

    @Query("""
            select a from ExamAttempt a
            join a.exam e
            where a.studentId = :studentId
              and (:q is null or lower(e.title) like lower(concat('%', :q, '%')))
              and (:from is null or a.submittedAt >= :from)
              and (:to is null or a.submittedAt <= :to)
            """)
    Page<ExamAttempt> search(@Param("studentId") UUID studentId,
                             @Param("q") String q,
                             @Param("from") LocalDateTime from,
                             @Param("to") LocalDateTime to,
                             Pageable pageable);

    @Query("""
            select count(a) from ExamAttempt a
            where a.studentId = :studentId
            """)
    long countAllByStudent(@Param("studentId") UUID studentId);

    @Query("""
            select coalesce(avg(a.score), 0) from ExamAttempt a
            where a.studentId = :studentId
            """)
    Double avgScoreByStudent(@Param("studentId") UUID studentId);

    @Query("""
            select coalesce(max(a.score), 0) from ExamAttempt a
            where a.studentId = :studentId
            """)
    BigDecimal maxScoreByStudent(@Param("studentId") UUID studentId);

    @Query("""
            select coalesce(sum(a.correctAnswers), 0) from ExamAttempt a
            where a.studentId = :studentId
            """)
    long sumCorrectByStudent(@Param("studentId") UUID studentId);

    long countByStudentIdAndExam_Id(UUID studentId, UUID examId);
}

