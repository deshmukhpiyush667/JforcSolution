-- =====================================================================
-- test_procedures.sql  (use this script for the demo video)
-- =====================================================================
USE employee_payroll_db;

-- Task 1
CALL GetEmployeeSalaryReport('IT', 50000);
CALL GetEmployeeSalaryReport('HR', 30000);

-- Task 2
CALL CalculateEmployeeSalary(101);
CALL CalculateEmployeeSalary(109);

-- Task 3
CALL EmployeeSalaryGrade(101);   -- A
CALL EmployeeSalaryGrade(111);   -- B (exactly 30,000)
CALL EmployeeSalaryGrade(109);   -- C

-- Bonus
CALL GetDepartmentSummary('IT');
CALL GetDepartmentSummary('Finance');
CALL GetDepartmentSummary('Legal');   -- department does not exist

-- Error handling (each raises an error)
-- CALL CalculateEmployeeSalary(999);
-- CALL EmployeeSalaryGrade(999);
-- CALL GetEmployeeSalaryReport('IT', -100);
