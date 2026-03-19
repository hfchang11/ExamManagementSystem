package com.example.demo.repository;

import com.example.demo.entity.Payment;
import com.example.demo.entity.Payment.PaymentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
public interface PaymentRepository extends JpaRepository<Payment, UUID> {

    Optional<Payment> findByTransactionId(String transactionId);

    @Query("""
            select p from Payment p
            join p.purchase pu
            join pu.examPackage ep
            where pu.studentId = :studentId
              and (:status is null or p.paymentStatus = :status)
              and (:q is null or lower(ep.name) like lower(concat('%', :q, '%')))
              and (:from is null or p.paymentDate >= :from)
              and (:to is null or p.paymentDate <= :to)
            """)
    Page<Payment> search(@Param("studentId") UUID studentId,
                         @Param("status") PaymentStatus status,
                         @Param("q") String q,
                         @Param("from") LocalDateTime from,
                         @Param("to") LocalDateTime to,
                         Pageable pageable);

    @Query("""
            select count(p) from Payment p
            join p.purchase pu
            where pu.studentId = :studentId
            """)
    long countAllByStudent(@Param("studentId") UUID studentId);

    @Query("""
            select count(p) from Payment p
            join p.purchase pu
            where pu.studentId = :studentId
              and p.paymentStatus = :status
            """)
    long countByStudentAndStatus(@Param("studentId") UUID studentId, @Param("status") PaymentStatus status);

    @Query("""
            select coalesce(sum(p.amount), 0) from Payment p
            join p.purchase pu
            where pu.studentId = :studentId
              and p.paymentStatus = :status
            """)
    BigDecimal sumAmountByStudentAndStatus(@Param("studentId") UUID studentId, @Param("status") PaymentStatus status);
}

