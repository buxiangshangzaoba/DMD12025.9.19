CREATE DATABASE smart_old_age_home;

\c smart_old_age_home;

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INTEGER NOT NULL,
    admission_date DATE NOT NULL
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL
);

CREATE TABLE patient_doctors (
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    PRIMARY KEY (patient_id, doctor_id)
);

CREATE TABLE nurses (
    nurse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    shift VARCHAR(50) NOT NULL, -- 'morning', 'afternoon', 'night'
    hire_date DATE NOT NULL
);

CREATE TABLE treatments (
    treatment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    nurse_id INTEGER REFERENCES nurses(nurse_id),
    treatment_type VARCHAR(100) NOT NULL,
    treatment_date DATE NOT NULL,
    notes TEXT
);

CREATE TABLE medication_stock (
    medication_id INTEGER PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL
);

INSERT INTO patients (name, age, admission_date) VALUES
('John Smith', 78, '2022-01-15'),
('Mary Johnson', 85, '2021-09-20'),
('Robert Brown', 75, '2022-03-10'),
('Patricia Davis', 90, '2021-07-05'),
('Michael Wilson', 82, '2022-02-28'),
('Jennifer Taylor', 76, '2021-11-12'),
('William Anderson', 88, '2022-04-01'),
('Elizabeth Thomas', 79, '2021-12-03'),
('David Jackson', 83, '2022-01-20'),
('Barbara White', 87, '2021-10-18'),
('Richard Harris', 65, '2022-03-15'), 
('Susan Martin', 81, '2021-08-22'),
('Joseph Thompson', 84, '2022-02-10'),
('Jessica Garcia', 77, '2021-09-30'),
('Thomas Robinson', 86, '2022-01-05');

INSERT INTO doctors (name, specialization, hire_date) VALUES
('Dr. James Miller', 'Cardiology', '2019-05-15'),
('Dr. Sarah Davis', 'Neurology', '2020-03-20'),
('Dr. Robert Wilson', 'Cardiology', '2018-11-10'),
('Dr. Linda Taylor', 'Geriatrics', '2021-01-05'),
('Dr. John Anderson', 'Orthopedics', '2019-08-28'),
('Dr. Emily Thomas', 'Cardiology', '2020-07-12'),
('Dr. Michael Jackson', 'Neurology', '2018-04-01'),
('Dr. Patricia White', 'Geriatrics', '2021-03-03');

INSERT INTO patient_doctors (patient_id, doctor_id) VALUES
(1, 1), (1, 3),
(2, 2), (2, 7),
(3, 5),
(4, 4), (4, 8),
(5, 1), (5, 6),
(6, 3),
(7, 4), (7, 8),
(8, 2),
(9, 1), (9, 6),
(10, 4),
(11, 5), (11, 3),
(12, 6),
(13, 1),
(14, 7),
(15, 2), (15, 4);

INSERT INTO nurses (name, shift, hire_date) VALUES
('Nurse Amy Clark', 'morning', '2020-06-15'),
('Nurse Brian Lewis', 'afternoon', '2019-08-20'),
('Nurse Catherine Walker', 'morning', '2021-01-10'),
('Nurse Daniel Hall', 'night', '2018-07-05'),
('Nurse Eve Allen', 'morning', '2022-02-28'),
('Nurse Frank Young', 'afternoon', '2021-11-12');

INSERT INTO treatments (patient_id, doctor_id, nurse_id, treatment_type, treatment_date, notes) VALUES
(1, 1, 1, 'Consultation', '2022-05-01', 'Regular checkup'),
(1, 3, 3, 'Medication', '2022-05-03', 'Blood pressure meds'),
(2, 2, 1, 'Consultation', '2022-05-02', 'Neurological assessment'),
(3, 5, 2, 'Physical Therapy', '2022-05-01', 'Joint mobility exercises'),
(4, 4, 5, 'Consultation', '2022-05-04', 'Geriatric assessment'),
(5, 1, 1, 'Medication', '2022-05-02', 'Heart medication adjustment'),
(6, 3, 3, 'Consultation', '2022-05-03', 'Follow-up visit'),
(7, 4, 5, 'Medication', '2022-05-01', 'Pain management'),
(8, 2, 1, 'Consultation', '2022-05-04', 'Neurological follow-up'),
(9, 1, 3, 'EKG', '2022-05-02', 'Cardiac function test'),
(10, 4, 5, 'Consultation', '2022-05-03', 'Regular checkup'),
(11, 5, 2, 'Physical Therapy', '2022-05-01', 'Strength training'),
(12, 6, 3, 'Medication', '2022-05-04', 'Cholesterol management'),
(13, 1, 1, 'Consultation', '2022-05-02', 'Follow-up visit'),
(14, 7, 1, 'Consultation', '2022-05-03', 'Neurological assessment'),
(15, 2, 3, 'Medication', '2022-05-01', 'Neurological meds'),
(1, 1, 1, 'Consultation', '2022-06-01', 'Monthly checkup'),
(5, 6, 3, 'EKG', '2022-06-02', 'Follow-up test'),
(9, 6, 5, 'Consultation', '2022-06-03', 'Follow-up visit');

INSERT INTO medication_stock (medication_id, medication_name, quantity) VALUES
(1, 'Lisinopril', 150), -- 降压药
(2, 'Metformin', 200), -- 降糖药
(3, 'Atorvastatin', 180), -- 降脂药
(4, 'Aspirin', 300), -- 阿司匹林
(5, 'Paracetamol', 250), -- 扑热息痛
(6, 'Omeprazole', 120), -- 奥美拉唑
(7, 'Levothyroxine', 90), -- 左甲状腺素
(8, 'Albuterol', 75), -- 沙丁胺醇
(9, 'Gabapentin', 60), -- 加巴喷丁
(10, 'Simvastatin', 45); -- 辛伐他汀

SELECT name, age FROM patients;

SELECT name FROM doctors WHERE specialization = 'Cardiology';

SELECT * FROM patients WHERE age > 80;

SELECT * FROM patients ORDER BY age ASC;

SELECT specialization, COUNT(*) AS doctor_count 
FROM doctors 
GROUP BY specialization;

SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN patient_doctors pd ON p.patient_id = pd.patient_id
JOIN doctors d ON pd.doctor_id = d.doctor_id
ORDER BY p.name, d.name;

SELECT t.treatment_id, t.treatment_type, t.treatment_date,
       p.name AS patient_name, d.name AS doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id
ORDER BY t.treatment_date;

SELECT d.doctor_id, d.name, COUNT(pd.patient_id) AS patient_count
FROM doctors d
JOIN patient_doctors pd ON d.doctor_id = pd.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY patient_count DESC;

SELECT AVG(age) AS average_age FROM patients;

WITH treatment_counts AS (
    SELECT treatment_type, COUNT(*) AS count
    FROM treatments
    GROUP BY treatment_type
)
SELECT treatment_type AS most_common_treatment
FROM treatment_counts
WHERE count = (SELECT MAX(count) FROM treatment_counts);

SELECT * FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

SELECT d.doctor_id, d.name, COUNT(pd.patient_id) AS patient_count
FROM doctors d
JOIN patient_doctors pd ON d.doctor_id = pd.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(pd.patient_id) > 5;

SELECT t.treatment_id, t.treatment_type, t.treatment_date,
       p.name AS patient_name, n.name AS nurse_name
FROM treatments t
JOIN nurses n ON t.nurse_id = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'morning'
ORDER BY t.treatment_date;

WITH ranked_treatments AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY treatment_date DESC) AS rn
    FROM treatments
)
SELECT rt.patient_id, p.name AS patient_name,
       rt.treatment_id, rt.treatment_type, rt.treatment_date
FROM ranked_treatments rt
JOIN patients p ON rt.patient_id = p.patient_id
WHERE rn = 1
ORDER BY p.name;

SELECT d.doctor_id, d.name AS doctor_name, 
       AVG(p.age) AS average_patient_age
FROM doctors d
JOIN patient_doctors pd ON d.doctor_id = pd.doctor_id
JOIN patients p ON pd.patient_id = p.patient_id
GROUP BY d.doctor_id, d.name
ORDER BY average_patient_age DESC;

SELECT d.name AS doctor_name, COUNT(pd.patient_id) AS patient_count
FROM doctors d
JOIN patient_doctors pd ON d.doctor_id = pd.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(pd.patient_id) > 3
ORDER BY patient_count DESC;

SELECT * FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);

SELECT * FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

SELECT d.name AS doctor_name, p.name AS patient_name, p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age) AS age_rank
FROM doctors d
JOIN patient_doctors pd ON d.doctor_id = pd.doctor_id
JOIN patients p ON pd.patient_id = p.patient_id
ORDER BY d.name, age_rank;

WITH patient_max_age AS (
    SELECT pd.doctor_id, p.age,
           ROW_NUMBER() OVER (PARTITION BY pd.doctor_id ORDER BY p.age DESC) AS age_rank
    FROM patient_doctors pd
    JOIN patients p ON pd.patient_id = p.patient_id
),
doctor_max_age AS (
    SELECT doctor_id, age AS max_patient_age
    FROM patient_max_age
    WHERE age_rank = 1
)
SELECT d.specialization, d.name AS doctor_name, dma.max_patient_age
FROM doctors d
JOIN doctor_max_age dma ON d.doctor_id = dma.doctor_id
JOIN (
    SELECT specialization, MAX(max_patient_age) AS highest_age
    FROM doctors
    JOIN doctor_max_age ON doctors.doctor_id = doctor_max_age.doctor_id
    GROUP BY specialization
) s ON d.specialization = s.specialization AND dma.max_patient_age = s.highest_age
ORDER BY d.specialization;
