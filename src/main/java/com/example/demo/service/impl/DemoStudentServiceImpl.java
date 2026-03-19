package com.example.demo.service.impl;

import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.DemoStudentService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.UUID;
/*
 * Cu Thi Huyen Trang
 */

@Service
public class DemoStudentServiceImpl implements DemoStudentService {

    private final UserRepository userRepository;
    private final UUID configuredStudentId;
    private final String configuredStudentEmail;

    public DemoStudentServiceImpl(UserRepository userRepository,
                                  @Value("${demo.student-id}") UUID configuredStudentId,
                                  @Value("${demo.student-email}") String configuredStudentEmail) {
        this.userRepository = userRepository;
        this.configuredStudentId = configuredStudentId;
        this.configuredStudentEmail = configuredStudentEmail;
    }

    @Override
    public UUID resolveDemoStudentId() {
        if (configuredStudentId != null && userRepository.existsById(configuredStudentId)) {
            return configuredStudentId;
        }
        return userRepository.findByEmailIgnoreCase(configuredStudentEmail)
                .map(u -> u.getId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Demo student not found. Set demo.student-id to an existing users.user_id or demo.student-email to an existing users.email"
                ));
    }
}

