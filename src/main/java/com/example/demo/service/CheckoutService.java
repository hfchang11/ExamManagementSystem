package com.example.demo.service;

import com.example.demo.entity.Payment;

import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */
public interface CheckoutService {

    Payment createCheckout(UUID studentId, UUID packageId);

    Payment completePayment(UUID paymentId, boolean success);
}

