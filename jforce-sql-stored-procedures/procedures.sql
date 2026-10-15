-- =====================================================================
-- procedures.sql
-- JForce Solutions - Employee Management & Payroll
-- Database: MySQL 8.x / MariaDB 10.x
-- Run database.sql FIRST, then this file.
-- =====================================================================

USE employee_payroll_db;

DROP PROCEDURE IF EXISTS GetEmployeeSalaryReport;
DROP PROCEDURE IF EXISTS CalculateEmployeeSalary;
DROP PROCEDURE IF EXISTS EmployeeSalaryGrade;
DROP PROCEDURE IF EXISTS GetDepartmentSummary;

DELIMITER $$

-- =====================================================================
-- TASK 1: GetEmployeeSalaryReport
-- Returns ACTIVE employees of a department whose basic salary is
-- greater than or equal to the given minimum salary.
-- Usage : CALL GetEmployeeSalaryReport('IT', 50000);
-- =====================================================================
CREATE PROCEDURE GetEmployeeSalaryReport (
    IN p_department_name VARCHAR(50),
    IN p_minimum_salary  DECIMAL(10,2)
)
BEGIN
    -- Validation: department must be supplied
    IF p_department_name IS NULL OR TRIM(p_department_name) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Department name cannot be empty.';
    END IF;

    -- Validation: minimum salary must be a non-negative number
    IF p_minimum_salary IS NULL OR p_minimum_salary < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Minimum salary must be a non-negative value.';
    END IF;

    -- Main report query
    SELECT  employee_id    AS 'Employee ID',
            employee_name  AS 'Employee Name',
            department     AS 'Department',
            designation    AS 'Designation',
            basic_salary   AS 'Basic Salary',
            joining_date   AS 'Joining Date'
    FROM    employees
    WHERE   department   = TRIM(p_department_name)
      AND   basic_salary >= p_minimum_salary
      AND   status       = 'Active'
    ORDER BY basic_salary DESC;
END$$


-- =====================================================================
-- TASK 2: CalculateEmployeeSalary
-- HRA = 20% | DA = 10% | PF = 12% of Basic Salary
-- Net Salary = Basic + HRA + DA - PF
-- Usage : CALL CalculateEmployeeSalary(101);
-- =====================================================================
CREATE PROCEDURE CalculateEmployeeSalary (
    IN p_employee_id INT
)
BEGIN
    DECLARE v_employee_name VARCHAR(100);
    DECLARE v_basic_salary  DECIMAL(10,2);
    DECLARE v_hra           DECIMAL(10,2);
    DECLARE v_da            DECIMAL(10,2);
    DECLARE v_pf            DECIMAL(10,2);
    DECLARE v_net_salary    DECIMAL(10,2);
    DECLARE v_found         INT DEFAULT 0;

    -- Validation: employee must exist
    SELECT COUNT(*) INTO v_found
    FROM   employees
    WHERE  employee_id = p_employee_id;

    IF v_found = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee ID does not exist.';
    END IF;

    -- Fetch employee details
    SELECT employee_name, basic_salary
    INTO   v_employee_name, v_basic_salary
    FROM   employees
    WHERE  employee_id = p_employee_id;

    -- Salary component calculations
    SET v_hra        = v_basic_salary * 0.20;
    SET v_da         = v_basic_salary * 0.10;
    SET v_pf         = v_basic_salary * 0.12;
    SET v_net_salary = v_basic_salary + v_hra + v_da - v_pf;

    SELECT  v_employee_name AS 'Employee Name',
            v_basic_salary  AS 'Basic Salary',
            v_hra           AS 'HRA',
            v_da            AS 'DA',
            v_pf            AS 'PF',
            v_net_salary    AS 'Net Salary';
END$$


-- =====================================================================
-- TASK 3: EmployeeSalaryGrade
-- Below 30,000          -> C
-- 30,000 to 60,000      -> B
-- Above 60,000          -> A
-- Usage : CALL EmployeeSalaryGrade(101);
-- =====================================================================
CREATE PROCEDURE EmployeeSalaryGrade (
    IN p_employee_id INT
)
BEGIN
    DECLARE v_employee_name VARCHAR(100);
    DECLARE v_basic_salary  DECIMAL(10,2);
    DECLARE v_grade         CHAR(1);
    DECLARE v_found         INT DEFAULT 0;

    -- Validation: employee must exist
    SELECT COUNT(*) INTO v_found
    FROM   employees
    WHERE  employee_id = p_employee_id;

    IF v_found = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Employee ID does not exist.';
    END IF;

    SELECT employee_name, basic_salary
    INTO   v_employee_name, v_basic_salary
    FROM   employees
    WHERE  employee_id = p_employee_id;

    -- Grade assignment using CASE
    SET v_grade = CASE
                      WHEN v_basic_salary < 30000  THEN 'C'
                      WHEN v_basic_salary <= 60000 THEN 'B'
                      ELSE 'A'
                  END;

    SELECT  v_employee_name AS 'Employee Name',
            v_basic_salary  AS 'Basic Salary',
            v_grade         AS 'Salary Grade';
END$$


-- =====================================================================
-- BONUS: GetDepartmentSummary
-- Returns headcount, average / highest / lowest salary and total
-- salary expenditure for a department. Shows a friendly message if
-- the department does not exist.
-- Usage : CALL GetDepartmentSummary('IT');
-- =====================================================================
CREATE PROCEDURE GetDepartmentSummary (
    IN p_department_name VARCHAR(50)
)
BEGIN
    DECLARE v_dept_count INT DEFAULT 0;

    -- Validation: department name must be supplied
    IF p_department_name IS NULL OR TRIM(p_department_name) = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Department name cannot be empty.';
    END IF;

    -- Check that the department exists
    SELECT COUNT(*) INTO v_dept_count
    FROM   employees
    WHERE  department = TRIM(p_department_name);

    IF v_dept_count = 0 THEN
        -- Department not found: display a message instead of empty/NULL values
        SELECT CONCAT('Department "', TRIM(p_department_name),
                      '" does not exist.') AS 'Message';
    ELSE
        -- Aggregate summary
        SELECT  department                    AS 'Department',
                COUNT(*)                      AS 'Total Employees',
                ROUND(AVG(basic_salary), 2)   AS 'Average Salary',
                MAX(basic_salary)             AS 'Highest Salary',
                MIN(basic_salary)             AS 'Lowest Salary',
                SUM(basic_salary)             AS 'Total Salary Expenditure'
        FROM    employees
        WHERE   department = TRIM(p_department_name)
        GROUP BY department;
    END IF;
END$$

DELIMITER ;
