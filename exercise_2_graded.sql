CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(50) NOT NULL,
    age INT NOT NULL CHECK (age > 0) 
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL 
);

CREATE TABLE nurses (
    nurse_id INT PRIMARY KEY,
    nurse_name VARCHAR(50) NOT NULL,
    shift VARCHAR(20) NOT NULL 
);


CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    nurse_id INT NOT NULL,
    treatment_type VARCHAR(50) NOT NULL, 
    treatment_date DATE NOT NULL,

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (nurse_id) REFERENCES nurses(nurse_id) ON DELETE CASCADE
);

CREATE TABLE medication_stock (
    medication_id INT PRIMARY KEY,
    medication_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0) 
);

INSERT INTO patients (patient_id, patient_name, age) VALUES
(1, 'John Smith', 78),
(2, 'Mary Johnson', 85),
(3, 'Robert Williams', 72),
(4, 'Patricia Brown', 90),
(5, 'Michael Davis', 68),
(6, 'Emily Wilson', 82),
(7, 'David Martinez', 75),
(8, 'Linda Anderson', 65);


INSERT INTO doctors (doctor_id, doctor_name, specialization) VALUES
(1, 'Dr. Sarah Lee', 'Cardiology'),
(2, 'Dr. James Taylor', 'Neurology'),
(3, 'Dr. Lisa Garcia', 'Cardiology'),
(4, 'Dr. Robert Martinez', 'Geriatrics'),
(5, 'Dr. Jennifer White', 'Orthopedics');


INSERT INTO nurses (nurse_id, nurse_name, shift) VALUES
(1, 'Nurse Amy Clark', 'morning'),
(2, 'Nurse Brian Lewis', 'afternoon'),
(3, 'Nurse Jennifer Hall', 'morning'),
(4, 'Nurse David Allen', 'night');


INSERT INTO treatments (treatment_id, patient_id, doctor_id, nurse_id, treatment_type, treatment_date) VALUES
(1, 1, 1, 1, 'Medication Administration', '2024-01-10'),
(2, 2, 3, 3, 'Physical Therapy', '2024-01-12'),
(3, 3, 2, 2, 'Neurological Check', '2024-01-15'),
(4, 4, 4, 1, 'Medication Administration', '2024-01-18'),
(5, 5, 5, 4, 'Orthopedic Therapy', '2024-01-20'),
(6, 6, 1, 3, 'Cardiac Monitoring', '2024-01-22'),
(7, 1, 1, 1, 'Follow-up Consultation', '2024-01-25'),
(8, 7, 4, 2, 'Geriatric Assessment', '2024-01-28'),
(9, 8, 5, 4, 'Pain Management', '2024-02-01'),
(10, 2, 3, 3, 'Medication Adjustment', '2024-02-05'),
(11, 4, 4, 1, 'Nutritional Counseling', '2024-02-08'),
(12, 6, 1, 3, 'Cardiac Rehab', '2024-02-10');


INSERT INTO medication_stock (medication_id, medication_name, quantity) VALUES
(1, 'Aspirin', 150),
(2, 'Lisinopril', 80),
(3, 'Metformin', 120),
(4, 'Atorvastatin', 90),
(5, 'Ibuprofen', 200),
(6, 'Warfarin', 60),
(7, 'Omeprazole', 110);

SELECT patient_name, age 
FROM patients;


SELECT doctor_name 
FROM doctors 
WHERE specialization = 'Cardiology';


SELECT patient_name, age 
FROM patients 
WHERE age > 80;

SELECT patient_name, age 
FROM patients 
ORDER BY age ASC;


SELECT specialization, COUNT(doctor_id) AS doctor_count 
FROM doctors 
GROUP BY specialization;


SELECT DISTINCT p.patient_name, d.doctor_name 
FROM patients p
JOIN treatments t ON p.patient_id = t.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

SELECT 
    t.treatment_id,
    t.treatment_type,
    t.treatment_date,
    p.patient_name,
    d.doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

SELECT 
    d.doctor_name,
    COUNT(DISTINCT t.patient_id) AS supervised_patients_count
FROM doctors d
LEFT JOIN treatments t ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name;


SELECT AVG(age) AS average_age 
FROM patients;


SELECT treatment_type AS most_common_treatment
FROM treatments
GROUP BY treatment_type
ORDER BY COUNT(*) DESC
LIMIT 1;


SELECT patient_name, age 
FROM patients 
WHERE age > (SELECT AVG(age) FROM patients);


SELECT 
    d.doctor_name,
    COUNT(DISTINCT t.patient_id) AS patient_count
FROM doctors d
JOIN treatments t ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(DISTINCT t.patient_id) > 5;


SELECT 
    p.patient_name,
    t.treatment_type,
    t.treatment_date,
    n.nurse_name
FROM treatments t
JOIN nurses n ON t.nurse_id = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'morning';


WITH patient_latest_treatment AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY treatment_date DESC) AS rn
    FROM treatments
)
SELECT 
    p.patient_name,
    plt.treatment_type,
    plt.treatment_date
FROM patient_latest_treatment plt
JOIN patients p ON plt.patient_id = p.patient_id
WHERE plt.rn = 1;


SELECT 
    d.doctor_name,
    ROUND(AVG(p.age), 1) AS average_patient_age
FROM doctors d
LEFT JOIN treatments t ON d.doctor_id = t.doctor_id
LEFT JOIN patients p ON t.patient_id = p.patient_id
GROUP BY d.doctor_id, d.doctor_name;

SELECT d.doctor_name
FROM doctors d
JOIN treatments t ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(DISTINCT t.patient_id) > 3;


SELECT patient_name 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);


SELECT medication_name, quantity 
FROM medication_stock 
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);


SELECT 
    d.doctor_name,
    p.patient_name,
    p.age,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age ASC) AS patient_age_rank
FROM doctors d
JOIN treatments t ON d.doctor_id = t.doctor_id
JOIN patients p ON t.patient_id = p.patient_id;


WITH specialist_patient_age AS (
    SELECT 
        d.specialization,
        d.doctor_name,
        p.patient_name,
        p.age AS patient_age,
        ROW_NUMBER() OVER (PARTITION BY d.specialization ORDER BY p.age DESC) AS rn
    FROM doctors d
    JOIN treatments t ON d.doctor_id = t.doctor_id
    JOIN patients p ON t.patient_id = p.patient_id
)
SELECT 
    specialization,
    doctor_name,
    patient_name AS oldest_patient_name,
    patient_age
FROM specialist_patient_age
WHERE rn = 1;






