
create database exam_management_system;
go

use exam_management_system;
go

-- users
CREATE TABLE users (
                       user_id       UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                       username      VARCHAR(50)  NOT NULL,
                       email         VARCHAR(100) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role          VARCHAR(30)  NOT NULL,
                       created_at    DATETIME     DEFAULT GETDATE()
);

-- subjects
CREATE TABLE subjects (
                          subject_id   UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                          subject_name VARCHAR(100) NOT NULL,
                          description  TEXT
);

-- exams
CREATE TABLE exams (
                       exam_id         UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                       subject_id      UNIQUEIDENTIFIER NOT NULL,
                       teacher_id      UNIQUEIDENTIFIER NOT NULL,
                       exam_title      VARCHAR(200) NOT NULL,
                       total_questions INT          NOT NULL,
                       created_at      DATETIME     DEFAULT GETDATE(),

                       CONSTRAINT fk_exam_subject
                           FOREIGN KEY (subject_id) REFERENCES subjects (subject_id),

                       CONSTRAINT fk_exam_teacher
                           FOREIGN KEY (teacher_id) REFERENCES users (user_id)
);

-- exam_attempts
CREATE TABLE exam_attempts (
                               attempt_id      UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                               exam_id         UNIQUEIDENTIFIER NOT NULL,
                               student_id      UNIQUEIDENTIFIER NOT NULL,
                               score           DECIMAL(5, 2),
                               correct_answers INT,
                               wrong_answers   INT,
                               started_at      DATETIME,
                               submitted_at    DATETIME,

                               CONSTRAINT fk_attempt_exam
                                   FOREIGN KEY (exam_id) REFERENCES exams (exam_id),

                               CONSTRAINT fk_attempt_student
                                   FOREIGN KEY (student_id) REFERENCES users (user_id)
);

-- exam_packages (THÊM cột status cho đúng entity)
CREATE TABLE exam_packages (
                               package_id   UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                               package_name VARCHAR(200) NOT NULL,
                               description  TEXT,
                               price        DECIMAL(10, 2) NOT NULL,
                               created_by   UNIQUEIDENTIFIER,
                               created_at   DATETIME       DEFAULT GETDATE(),
                               status       VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',

                               CONSTRAINT fk_package_creator
                                   FOREIGN KEY (created_by) REFERENCES users (user_id)
);

-- package_exams
CREATE TABLE package_exams (
                               id         UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                               package_id UNIQUEIDENTIFIER NOT NULL,
                               exam_id    UNIQUEIDENTIFIER NOT NULL,

                               CONSTRAINT fk_package_exam_package
                                   FOREIGN KEY (package_id) REFERENCES exam_packages (package_id),

                               CONSTRAINT fk_package_exam_exam
                                   FOREIGN KEY (exam_id) REFERENCES exams (exam_id)
);

-- package_reviews
CREATE TABLE package_reviews (
                                 review_id  UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                 package_id UNIQUEIDENTIFIER NOT NULL,
                                 student_id UNIQUEIDENTIFIER NOT NULL,
                                 rating     INT CHECK (rating BETWEEN 1 AND 5),
                                 comment    TEXT,
                                 created_at DATETIME DEFAULT GETDATE(),

                                 CONSTRAINT fk_review_package
                                     FOREIGN KEY (package_id) REFERENCES exam_packages (package_id),

                                 CONSTRAINT fk_review_student
                                     FOREIGN KEY (student_id) REFERENCES users (user_id)
);

-- package_purchases (đã có status, khớp entity PackagePurchase.Status -> VARCHAR)
CREATE TABLE package_purchases (
                                   purchase_id   UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                   student_id    UNIQUEIDENTIFIER NOT NULL,
                                   package_id    UNIQUEIDENTIFIER NOT NULL,
                                   purchase_date DATETIME     DEFAULT GETDATE(),
                                   status        VARCHAR(30),   -- PENDING / COMPLETED / CANCELLED

                                   CONSTRAINT fk_purchase_student
                                       FOREIGN KEY (student_id) REFERENCES users (user_id),

                                   CONSTRAINT fk_purchase_package
                                       FOREIGN KEY (package_id) REFERENCES exam_packages (package_id)
);

-- payments
CREATE TABLE payments (
                          payment_id     UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                          purchase_id    UNIQUEIDENTIFIER NOT NULL,
                          amount         DECIMAL(10, 2) NOT NULL,
                          payment_method VARCHAR(50),
                          transaction_id VARCHAR(100),
                          payment_status VARCHAR(30),
                          payment_date   DATETIME DEFAULT GETDATE(),

                          CONSTRAINT fk_payment_purchase
                              FOREIGN KEY (purchase_id) REFERENCES package_purchases (purchase_id)
);

USE exam_system;
GO

/* =========================
   INSERT USERS
========================= */

INSERT INTO users(username,email,password_hash,role)
VALUES
('teacherA','teacherA@mail.com','123','teacher'),
('teacherB','teacherB@mail.com','123','teacher'),
('studentA','studentA@mail.com','123','student'),
('studentB','studentB@mail.com','123','student'),
('studentC','studentC@mail.com','123','student'),
('admin','admin@mail.com','123','admin'),
('manager','manager@mail.com','123','academic_manager');



/* =========================
   INSERT SUBJECTS
========================= */

INSERT INTO subjects(subject_name,description)
VALUES
    ('Toan hoc','Danh gia tu duy toan hoc cho ky thi HSA'),
    ('Tieng Viet','Doc hieu va ngon ngu tieng Viet'),
    ('Tieng Anh','Danh gia nang luc tieng Anh'),
    ('Tu duy Logic','Phan tich va giai quyet van de');



/* =========================
   INSERT EXAMS
========================= */

INSERT INTO exams(subject_id,teacher_id,exam_title,total_questions)
VALUES
    (
        (SELECT subject_id FROM subjects WHERE subject_name='Toan hoc'),
        (SELECT user_id FROM users WHERE email='teacherA@mail.com'),
        'De thi HSA Toan 01',
        50
    ),
    (
        (SELECT subject_id FROM subjects WHERE subject_name='Toan hoc'),
        (SELECT user_id FROM users WHERE email='teacherA@mail.com'),
        'De thi HSA Toan 02',
        50
    ),
    (
        (SELECT subject_id FROM subjects WHERE subject_name='Tieng Viet'),
        (SELECT user_id FROM users WHERE email='teacherB@mail.com'),
        'De thi Doc hieu Tieng Viet 01',
        40
    ),
    (
        (SELECT subject_id FROM subjects WHERE subject_name='Tieng Anh'),
        (SELECT user_id FROM users WHERE email='teacherB@mail.com'),
        'De thi Tieng Anh 01',
        40
    ),
    (
        (SELECT subject_id FROM subjects WHERE subject_name='Tu duy Logic'),
        (SELECT user_id FROM users WHERE email='teacherA@mail.com'),
        'De thi Tu duy Logic 01',
        30
    );



/* =========================
   INSERT EXAM PACKAGES
========================= */

INSERT INTO exam_packages(package_name,description,price,created_by,status)
VALUES
    (
        'Goi luyen HSA co ban',
        'Luyen de co ban cho ky thi danh gia nang luc',
        199000,
        (SELECT user_id FROM users WHERE email='manager@mail.com'),
        'ACTIVE'
    ),
    (
        'Goi luyen HSA nang cao',
        'Bo de nang cao chuan bi thi DHQG',
        399000,
        (SELECT user_id FROM users WHERE email='manager@mail.com'),
        'ACTIVE'
    ),
    (
        'Goi luyen HSA VIP',
        'Tat ca de thi + phan tich chi tiet',
        599000,
        (SELECT user_id FROM users WHERE email='manager@mail.com'),
        'INACTIVE'
    );



/* =========================
   INSERT PACKAGE EXAMS
========================= */

INSERT INTO package_exams(package_id,exam_id)
VALUES
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA co ban'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA co ban'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi Doc hieu Tieng Viet 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA nang cao'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA nang cao'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 02')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA nang cao'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi Tieng Anh 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA VIP'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA VIP'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 02')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA VIP'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi Doc hieu Tieng Viet 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA VIP'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi Tieng Anh 01')
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA VIP'),
        (SELECT exam_id FROM exams WHERE exam_title='De thi Tu duy Logic 01')
    );



/* =========================
   INSERT EXAM ATTEMPTS
========================= */

INSERT INTO exam_attempts(exam_id,student_id,score,correct_answers,wrong_answers,started_at,submitted_at)
VALUES
    (
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 01'),
        (SELECT user_id FROM users WHERE email='studentA@mail.com'),
        7.5,
        38,
        12,
        GETDATE(),
        GETDATE()
    ),
    (
        (SELECT exam_id FROM exams WHERE exam_title='De thi HSA Toan 01'),
        (SELECT user_id FROM users WHERE email='studentB@mail.com'),
        8.2,
        41,
        9,
        GETDATE(),
        GETDATE()
    ),
    (
        (SELECT exam_id FROM exams WHERE exam_title='De thi Tieng Anh 01'),
        (SELECT user_id FROM users WHERE email='studentC@mail.com'),
        6.8,
        27,
        13,
        GETDATE(),
        GETDATE()
    );



/* =========================
   INSERT PACKAGE PURCHASES
========================= */

INSERT INTO package_purchases(student_id,package_id,status)
VALUES
    (
        (SELECT user_id FROM users WHERE email='studentA@mail.com'),
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA co ban'),
        'COMPLETED'
    ),
    (
        (SELECT user_id FROM users WHERE email='studentB@mail.com'),
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA nang cao'),
        'COMPLETED'
    );



/* =========================
   INSERT PAYMENTS
========================= */

INSERT INTO payments(purchase_id,amount,payment_method,transaction_id,payment_status)
VALUES
    (
        (SELECT purchase_id FROM package_purchases
         WHERE student_id=(SELECT user_id FROM users WHERE email='studentA@mail.com')),
        199000,
        'VNPay',
        'TXN001',
        'SUCCESS'
    ),
    (
        (SELECT purchase_id FROM package_purchases
         WHERE student_id=(SELECT user_id FROM users WHERE email='studentB@mail.com')),
        399000,
        'MoMo',
        'TXN002',
        'SUCCESS'
    );



/* =========================
   INSERT REVIEWS
========================= */

INSERT INTO package_reviews(package_id,student_id,rating,comment)
VALUES
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA co ban'),
        (SELECT user_id FROM users WHERE email='studentA@mail.com'),
        4,
        'Bo de kha sat de thi that'
    ),
    (
        (SELECT package_id FROM exam_packages WHERE package_name='Goi luyen HSA nang cao'),
        (SELECT user_id FROM users WHERE email='studentB@mail.com'),
        5,
        'De nang cao rat chat luong'
    );
