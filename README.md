# 🌍 Global Layoff Data Cleaning & Analysis using SQL  

## 🧠 Project Overview  
This project focuses on cleaning and preparing a **global layoffs dataset** for analysis using **SQL**.  
The goal was to **eliminate duplicates, standardize data, fix inconsistencies, and ensure the dataset is analysis ready** for future visualization and insights.  
**Excel** was used only for **data viewing and understanding** during the initial exploration phase.  

---

## 🎯 Objectives  
- Identify and remove duplicate and inconsistent records.  
- Standardize text fields such as company, country, and industry names.  
- Handle missing and null values systematically.  
- Convert date formats for accurate time based analysis.  
- Prepare the dataset for visualization or further analytical modeling.  

---

## ⚙️ Tools & Technologies  
- **MySQL** → Data cleaning, transformation, and query execution  
- **Microsoft Excel** → Data exploration and viewing only  

---

## 🧩 Process & Approach  

### 1️⃣ Data Exploration  
- Reviewed raw layoff data in Excel to understand structure, data types, and inconsistencies.  
- Identified key data quality issues such as **duplicates, nulls, and inconsistent naming**.  

### 2️⃣ Data Cleaning in SQL  
- **Created staging tables** (`layoffs_stagging` & `layoffs_stagging2`) for safe transformations.  
- **Removed duplicates** using `CTE` with `ROW_NUMBER()` and `PARTITION BY`.  
- **Trimmed whitespace** from company names using the `TRIM()` function.  
- **Standardized text fields** for countries and industries (e.g., “United States of America” → “United States”).  
- **Handled missing values** by joining the same table and updating nulls with valid corresponding data.  
- **Converted date formats** to proper SQL `DATE` type using `STR_TO_DATE()`.  
- **Deleted irrelevant or incomplete rows** (where both `total_laid_off` and `percentage_laid_off` were null).  

---

## 📊 Example Queries  

```sql
-- 1. Identify duplicate records
WITH duplicate_cte AS (
  SELECT *,
  ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
  FROM layoffs_stagging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- 2. Remove duplicates
DELETE FROM layoffs_stagging2 WHERE row_num > 1;

-- 3. Standardize country names
UPDATE layoffs_stagging2
SET country = 'United States'
WHERE country LIKE 'United States%';


