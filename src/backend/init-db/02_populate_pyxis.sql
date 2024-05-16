-- Set the default schema for the session
SET search_path TO pyxis;

-- Create tables within the 'hospital' schema
CREATE TABLE IF NOT EXISTS pyxis.dispenser (
    id SERIAL PRIMARY KEY,
    code VARCHAR(5) UNIQUE NOT NULL,
    floor INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS pyxis.medicine (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    dosage VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS pyxis.material (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS pyxis.dispenser_medicine (
    dispenser_id INTEGER NOT NULL,
    medicine_id INTEGER NOT NULL,
    PRIMARY KEY (dispenser_id, medicine_id),
    FOREIGN KEY (dispenser_id) REFERENCES dispenser(id),
    FOREIGN KEY (medicine_id) REFERENCES medicine(id)
);

-- Insert data into 'dispenser'
INSERT INTO dispenser (code, floor) VALUES
('A1B2C', 5),
('D3E4F', 11),
('G5H6I', 19),
('J7K8L', 1),
('M9N0O', 8);

-- Insert data into 'medicine'
INSERT INTO medicine (name, dosage) VALUES
('Paracetamol', '500 mg'),
('Ibuprofeno', '200 mg'),
('Amoxicilina', '500 mg'),
('Dipirona', '500 mg'),
('Captopril', '25 mg');

-- Insert data into 'material'
INSERT INTO material (name) VALUES
('Luvas de procedimento'),
('Seringas de 5ml'),
('Máscaras cirúrgicas'),
('Cateter IV'),
('Ataduras');

-- Associating medicines with dispensers
INSERT INTO dispenser_medicine (dispenser_id, medicine_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1);

-- Commit all changes (necessary if you are using transactional SQL or certain SQL environments)
COMMIT;