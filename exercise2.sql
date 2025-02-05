DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS modules;
DROP TABLE IF EXISTS bootcamps;
DROP TABLE IF EXISTS bcamp_modules;
DROP TABLE IF EXISTS registrations;

-- Crear la tabla students
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phonenumber VARCHAR(20),
    nif VARCHAR(15)
);
-- Crear la tabla teachers
CREATE TABLE teachers (
    teacher_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phonenumber VARCHAR(20),
    nif VARCHAR(15)
);

-- Crear la tabla modules
CREATE TABLE modules (
    module_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    teacher_id INT NOT NULL,    
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- Crear la tabla bootcamps
CREATE TABLE bootcamps (
    bootcamp_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
);

-- Crear la tabla bcamp_modules
CREATE TABLE bcamp_modules (
    bcamp_module_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL,
    module_id INT NOT NULL,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamps(bootcamp_id),
    FOREIGN KEY (module_id) REFERENCES modules(module_id),
    UNIQUE (bootcamp_id, module_id)

-- Crear la tabla registrations
CREATE TABLE regitrations (
    registration_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    edition INT NOT NULL,
    registration_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES modules(student_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamps(bootcamp_id),
    UNIQUE (student_id, bootcamp_id)

INSERT INTO students (name, surname, email, phone, nif) VALUES
('Carmen', 'Pérez', 'carmen.perez@email.com', '924-252627','12345123F'),
('Antonio', 'García', 'antonio.garcia@email.com', '928-293031','22245123R'),
('Isabel', 'Fernández', 'isabel.fernandez@email.com', '932-333435','12333123Q'),
('Sergio', 'Martín', 'sergio.martin@email.com', '936-373839','54321123J'),
('Lucía', 'Díaz', 'lucia.diaz@email.com', '940-414243','16666123K'),
('Elena', 'Moreno', 'elena.moreno@email.com', '948-495051','10000123L'),
('José', 'Blanco', 'jose.blanco@email.com', '952-535455','18765123T');

INSERT INTO teachers (name, surname, email, phone, nif) VALUES
('Paula', 'Navarro', 'paula.navarro@email.com', '956-575859','16666123K'),
('Miguel', 'Romero', 'miguel.romero@email.com', '960-616263','12333123Q'),
('Sofía', 'Vidal', 'sofia.vidal@email.com', '972-737475','54321123J'),
('Alonso', 'López', 'alonso.lopez@email.com', '976-777879','12345123F');

INSERT INTO bootcamps (name, description, price) VALUES
('BigData, IA & Machine Learning', 'Lo que necesitas saber para ser analista de datos', 1000.50),
('Blockchain', 'Lo que su propio nombre indica', 5000.00);

INSERT INTO modules (name, description, teacher_id) VALUES
('Programación101', 'Todo sobre programación', 1),
('Matemáticas101', 'Del 0 al 100', 2),
('SQL Avanzado', 'Monta tu propia base de datos', 3),
('Visualización', 'Lo ves o no lo ves', 4);

INSERT INTO bcamp_modules (bootcamp_id, module_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);

INSERT INTO registrations (student_id, bootcamp_id, edition, registration_date) VALUES
(1, 2, 12, '2021-08-04'),
(2, 1, 5, '2022-11-12'),
(5, 2, 16, '2024-10-01'),
(6, 1, 8, '2024-04-07');
