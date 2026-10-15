# Employee Management & Payroll – SQL Stored Procedures

**JForce Solutions – SQL Developer Interview Task (Junior / R1)**

Stored procedures for an Employee Management and Payroll database, written for **MySQL 8.x / MariaDB 10.x** and tested on MariaDB 10.11.

## Project Structure

| File | Description |
|------|-------------|
| `database.sql` | Creates the `employee_payroll_db` database, the `employees` table and 12 sample employees |
| `procedures.sql` | All four stored procedures (3 required + bonus) |
| `test_procedures.sql` | `CALL` statements used for the demo / testing |
| `README.md` | This document |

## How to Run

```bash
mysql -u root -p < database.sql
mysql -u root -p < procedures.sql
mysql -u root -p --table < test_procedures.sql
```

(Or open each file in MySQL Workbench and execute in the order above.)

## Database Design

`employees` table: `employee_id` (INT, **PK**), `employee_name`, `department`, `designation`, `basic_salary` (DECIMAL(10,2)), `joining_date` (DATE), `status` (Active / Inactive).

- `CHECK` constraints: salary ≥ 0, status limited to `Active` / `Inactive`
- Index on `department` for faster department queries
- 12 employees across IT, HR, Finance, Sales and Marketing, with salaries from ₹25,000 to ₹85,000 and both Active and Inactive statuses

## Procedures

### 1. `GetEmployeeSalaryReport(p_department_name, p_minimum_salary)`
Returns Active employees in the given department with `basic_salary >= p_minimum_salary`.
Validates that the department is not empty and the salary is not negative.

```sql
CALL GetEmployeeSalaryReport('IT', 50000);
```
| Employee ID | Employee Name | Department | Designation | Basic Salary | Joining Date |
|---|---|---|---|---|---|
| 101 | Rahul Sharma | IT | Senior Developer | 75000.00 | 2019-03-15 |
| 102 | Priya Patil | IT | Software Developer | 55000.00 | 2021-07-01 |

(Sneha Kulkarni is excluded because she is Inactive.)

### 2. `CalculateEmployeeSalary(p_employee_id)`
HRA = 20%, DA = 10%, PF = 12% of basic. **Net = Basic + HRA + DA − PF** (effectively 118% of basic).
Raises an error if the employee ID does not exist.

```sql
CALL CalculateEmployeeSalary(101);
```
| Employee Name | Basic Salary | HRA | DA | PF | Net Salary |
|---|---|---|---|---|---|
| Rahul Sharma | 75000.00 | 15000.00 | 7500.00 | 9000.00 | 88500.00 |

### 3. `EmployeeSalaryGrade(p_employee_id)`
Uses a `CASE` expression:

| Basic Salary | Grade |
|---|---|
| Below ₹30,000 | C |
| ₹30,000 – ₹60,000 (inclusive) | B |
| Above ₹60,000 | A |

```sql
CALL EmployeeSalaryGrade(101);   -- A
```

### 4. Bonus – `GetDepartmentSummary(p_department_name)`
Returns total employees, average, highest, lowest salary and total salary expenditure using `COUNT`, `AVG`, `MAX`, `MIN`, `SUM`.
If the department does not exist it returns a friendly message.

```sql
CALL GetDepartmentSummary('IT');
CALL GetDepartmentSummary('Legal');   -- Department "Legal" does not exist.
```

## Error Handling

Validation uses `SIGNAL SQLSTATE '45000'` with clear messages, e.g.:

```
CALL CalculateEmployeeSalary(999);
ERROR 1644 (45000): Error: Employee ID does not exist.

CALL GetEmployeeSalaryReport('IT', -100);
ERROR 1644 (45000): Error: Minimum salary must be a non-negative value.
```

## Concepts Demonstrated
Stored procedures • IN parameters • local variables (`DECLARE`) • `IF` / `CASE` logic • aggregate functions • arithmetic calculations • validation with `SIGNAL` • constraints and indexes • commented, consistently formatted code.
