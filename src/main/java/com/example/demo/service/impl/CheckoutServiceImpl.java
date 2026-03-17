package com.example.demo.service.impl;

import com.example.demo.entity.ExamPackage;
import com.example.demo.entity.PackagePurchase;
import com.example.demo.entity.Payment;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.ExamPackageRepository;
import com.example.demo.repository.PackagePurchaseRepository;
import com.example.demo.repository.PaymentRepository;
import com.example.demo.service.CheckoutService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class CheckoutServiceImpl implements CheckoutService {

    private final ExamPackageRepository examPackageRepository;
    private final PackagePurchaseRepository packagePurchaseRepository;
    private final PaymentRepository paymentRepository;

    public CheckoutServiceImpl(ExamPackageRepository examPackageRepository,
                               PackagePurchaseRepository packagePurchaseRepository,
                               PaymentRepository paymentRepository) {
        this.examPackageRepository = examPackageRepository;
        this.packagePurchaseRepository = packagePurchaseRepository;
        this.paymentRepository = paymentRepository;
    }

    @Override
    @Transactional
    public Payment createCheckout(UUID studentId, UUID packageId) {
        ExamPackage examPackage = examPackageRepository.findById(packageId)
                .orElseThrow(() -> new ResourceNotFoundException("Exam package not found " + packageId));

        PackagePurchase purchase = new PackagePurchase();
        purchase.setStudentId(studentId);
        purchase.setExamPackage(examPackage);
        purchase.setPurchaseDate(LocalDateTime.now());
        purchase.setStatus(PackagePurchase.PurchaseStatus.PENDING);
        purchase = packagePurchaseRepository.save(purchase);

        Payment payment = new Payment();
        payment.setPurchase(purchase);
        payment.setAmount(examPackage.getPrice());
        payment.setPaymentMethod("VietQR");
        payment.setPaymentStatus(Payment.PaymentStatus.PENDING);
        payment.setPaymentDate(LocalDateTime.now());
        payment = paymentRepository.save(payment);

        payment.setTransactionId("PAY-" + payment.getId());
        return paymentRepository.save(payment);
    }

    @Override
    @Transactional
    public Payment completePayment(UUID paymentId, boolean success) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found " + paymentId));

        if (payment.getPaymentStatus() != Payment.PaymentStatus.PENDING) {
            return payment;
        }

        PackagePurchase purchase = payment.getPurchase();
        if (success) {
            payment.setPaymentStatus(Payment.PaymentStatus.SUCCESS);
            purchase.setStatus(PackagePurchase.PurchaseStatus.COMPLETED);
        } else {
            payment.setPaymentStatus(Payment.PaymentStatus.FAILED);
            purchase.setStatus(PackagePurchase.PurchaseStatus.CANCELLED);
        }
        payment.setPaymentDate(LocalDateTime.now());
        packagePurchaseRepository.save(purchase);
        return paymentRepository.save(payment);
    }
}

