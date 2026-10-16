# E-Commerce Analytics Pipeline

## Goal
Build an end-to-end data analytics portfolio project using
Python, SQL Server, and Power BI.

## Architecture
Olist CSV files
    ↓
Python (pandas ETL)
    ↓
SQL Server Staging
    ↓
SQL Server Data Warehouse
    ↓
SQL Analytics / Power BI

## Current Progress
- [x] Data exploration
- [x] Python ETL
- [x] Staging tables
- [x] Dimension tables
- [x] Fact tables
- [x] DWH loading
- [ ] Data validation and reconciliation
- [ ] Analytical SQL queries
- [ ] Power BI dashboard

## Current Task
Implement data quality validation and reconciliation.

Checks:
- Row counts
- Primary key uniqueness
- Referential integrity
- Staging-to-DWH reconciliation

## Important Decisions
- Use dimensional modelling.
- Avoid fact duplication caused by joining multiple
  one-to-many relationships.
- Keep architecture simple and appropriate for portfolio scope.

## Next Milestone
Validated and reconciled Data Warehouse.