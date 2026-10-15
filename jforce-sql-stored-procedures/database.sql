-- =====================================================================
-- database.sql
-- JForce Solutions - Employee Management & Payroll
-- Database: MySQL 8.x / MariaDB 10.x
-- Purpose : Create database, employees table and sample data
-- =====================================================================

DROP DATABASE IF EXISTS employee_payroll_db;
CREATE DATABASE employee_payroll_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE employee_payroll_db;

-- ---------------------------------------------------------------------
-- Table: employees
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    employee_id    INT            NOT NULL,
    employee_name  VARCHAR(100)   NOT NULL,
    department     VARCHAR(50)    NOT NULL,
    designation    VARCHAR(100)   NOT NULL,
    basic_salary   DECIMAL(10,2)  NOT NULL,
    joining_date   DATE           NOT NULL,
    status         VARCHAR(10)    NOT NULL DEFAULT 'Active',
    PRIMARY KEY (employee_id),
    -- Data integrity rules
    CONSTRAINT chk_basic_salary CHECK (basic_salary >= 0),
    CONSTRAINT chk_status       CHECK (status IN ('Active', 'Inactive'))
) ENGINE = InnoDB;

-- Index to speed up department based reports
CREATE INDEX idx_employees_department ON employees (department);

-- ---------------------------------------------------------------------
-- Sample data: 12 employees, 5 departments, varied salary ranges
-- ---------------------------------------------------------------------
INSERT INTO employees
    (employee_id, employee_name, department, designation, basic_salary, joining_date, status)
VALUES
    (101, 'Rahul Sharma',   'IT',        'Senior Developer',   75000.00, '2019-03-15', 'Active'),
    (102, 'Priya Patil',    'IT',        'Software Developer', 55000.00, '2021-07-01', 'Active'),
    (103, 'Amit Deshmukh',  'IT',        'Junior Developer',   28000.00, '2023-01-10', 'Active'),
    (104, 'Sneha Kulkarni', 'IT',        'QA Engineer',        45000.00, '2020-11-20', 'Inactive'),
    (105, 'Vikram Singh',   'HR',        'HR Manager',         65000.00, '2018-06-05', 'Active'),
    (106, 'Neha Joshi',     'HR',        'HR Executive',       32000.00, '2022-02-14', 'Active'),
    (107, 'Rohan Mehta',    'Finance',   'Finance Manager',    85000.00, '2017-09-25', 'Active'),
    (108, 'Anjali Nair',    'Finance',   'Accountant',         42000.00, '2021-04-12', 'Active'),
    (109, 'Suresh Iyer',    'Sales',     'Sales Executive',    25000.00, '2023-05-30', 'Active'),
    (110, 'Kavita Rao',     'Sales',     'Sales Manager',      60000.00, '2019-12-01', 'Active'),
    (111, 'Manoj Gupta',    'Marketing', 'Marketing Analyst',  30000.00, '2022-08-18', 'Active'),
    (112, 'Divya Reddy',    'Marketing', 'Marketing Lead',     62000.00, '2020-01-27', 'Inactive');

-- Quick check
SELECT * FROM employees ORDER BY employee_id;
