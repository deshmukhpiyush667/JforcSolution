# Employee Management and Payroll System

**JForce Solutions – SQL Developer Interview Task**

## Project Overview

This project is a simple Employee Management and Payroll System built using MySQL. It stores employee information and uses stored procedures to generate salary reports, calculate salary components, assign salary grades, and summarize department salaries.

The project was developed and tested using MariaDB 10.11 and is compatible with MySQL 8.x / MariaDB 10.x, subject to version-specific SQL behavior.

## Project Structure

| File | Description |
|---|---|
| `database.sql` | Creates the database and employees table, and inserts 12 sample employee records. |
| `procedures.sql` | Contains the four stored procedures. |
| `test_procedures.sql` | Contains the SQL commands used to test the procedures. |
| `README.md` | Provides project details and setup instructions. |

## Database Design

The project uses a database named `employee_payroll_db` and an `employees` table.

The table contains the following columns:

- `employee_id` – Unique ID for each employee and the primary key.
- `employee_name` – Employee's name.
- `department` – Department in which the employee works.
- `designation` – Employee's job role.
- `basic_salary` – Employee's basic salary.
- `joining_date` – Date the employee joined the company.
- `status` – Employment status (`Active` or `Inactive`).

The database includes 12 sample employees from IT, HR, Finance, Sales, and Marketing.

I also included constraints to prevent negative salaries and invalid employment statuses, along with an index on `department` to support department-based queries.

## Stored Procedures

### 1. GetEmployeeSalaryReport

This procedure takes a department name and a minimum salary as input. It returns active employees in the selected department whose basic salary is greater than or equal to the specified amount.

It also checks for an empty department name and a negative or invalid minimum salary.

**Example:**

```sql
CALL GetEmployeeSalaryReport('IT', 50000);
```

This displays matching IT employees earning at least ₹50,000, sorted according to the procedure's defined ordering.

### 2. CalculateEmployeeSalary

This procedure accepts an employee ID and calculates the employee's salary components using the basic salary.

The calculation uses the following percentages:

- HRA: 20% of basic salary
- DA: 10% of basic salary
- PF: 12% of basic salary
- Net salary: Basic salary + HRA + DA − PF

**Example:**

```sql
CALL CalculateEmployeeSalary(101);
```

For employee 101, whose basic salary is ₹75,000, the calculated values are:

| Component | Amount |
|---|---:|
| Basic Salary | ₹75,000 |
| HRA | ₹15,000 |
| DA | ₹7,500 |
| PF | ₹9,000 |
| Net Salary | ₹88,500 |

The procedure also reports an error if the employee ID does not exist.

### 3. EmployeeSalaryGrade

This procedure accepts an employee ID and assigns a grade based on the employee's basic salary.

| Basic Salary | Grade |
|---|---|
| Below ₹30,000 | C |
| ₹30,000 to ₹60,000, inclusive | B |
| Above ₹60,000 | A |

**Example:**

```sql
CALL EmployeeSalaryGrade(101);
```

Employee 101 earns ₹75,000, so the assigned grade is A.

### 4. GetDepartmentSummary (Bonus)

This procedure generates a salary summary for a selected department. It uses aggregate functions to calculate:

- Total number of employees
- Average basic salary
- Highest basic salary
- Lowest basic salary
- Total basic salary expenditure

**Examples:**

```sql
CALL GetDepartmentSummary('IT');

CALL GetDepartmentSummary('Legal');
```

If the requested department does not exist, the procedure returns a message indicating that the department was not found.

## Error Handling

I added input validation to handle invalid values and missing employee records. The procedures use `SIGNAL SQLSTATE '45000'` to return meaningful error messages when an input does not meet the required conditions.

For example, the procedures handle negative salary inputs, empty department names, and employee IDs that do not exist.

## How to Run the Project

### Requirements

- MySQL 8.x or a compatible MariaDB version
- MySQL Workbench or a MySQL command-line client

### Option 1: Using the MySQL command line

Run the files in the following order:

```bash
mysql -u root -p < database.sql
mysql -u root -p < procedures.sql
mysql -u root -p --table < test_procedures.sql
```

Enter your MySQL password when prompted.

### Option 2: Using MySQL Workbench

1. Open MySQL Workbench and connect to your database server.
2. Open `database.sql` and execute it.
3. Open `procedures.sql` and execute it.
4. Open `test_procedures.sql` and execute the test queries.
5. Check the result grids and Action Output panel to verify the results.

## Concepts Used

- Database and table creation
- Primary keys and data constraints
- SQL data types
- Stored procedures and `IN` parameters
- Local variables and conditional logic
- `IF` and `CASE` expressions
- Aggregate functions: `COUNT`, `AVG`, `MAX`, `MIN`, and `SUM`
- Salary calculations
- Input validation and error handling
- Indexes and query execution

## Conclusion

This project helped me practise writing reusable SQL stored procedures, working with employee data, performing salary calculations, and generating department-level reports. It also gave me practical experience with input validation and testing different scenarios in MySQL.