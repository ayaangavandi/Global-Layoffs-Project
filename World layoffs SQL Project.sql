-- Data Cleaning

Select * from layoffs;
-- Selecting Table data

CREATE TABLE layoffs_stagging
LIKE layoffs;
-- Creating duplicate stagging table for editing

INSERT layoffs_stagging
SELECT * FROM layoffs;
-- Inserting duplicate data in stagging table

SELECT * FROM layoffs_stagging;


with duplicate_cte as
(
SELECT *,
row_number()
over( partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) as row_num
from layoffs_stagging
)
select *
from duplicate_cte
where row_num > 1;
-- Finding out duplicate rows in stagging table using CTE(), row_num(), Over(), Partition by

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Creating another table stagging2 to remove duplicates and inserting row_num column in it

SELECT * FROM layoffs_stagging2;

Insert into layoffs_stagging2
SELECT *,
row_number()
over( partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) as row_num
from layoffs_stagging;
-- Inserting data into stagging2 table

SELECT * FROM layoffs_stagging2
where row_num >1;
-- row_num() greater than 2 mean duplicate value 

Delete FROM layoffs_stagging2
where row_num >1;
-- deleting duplicate values

update layoffs_stagging2
set company = trim(company);
-- trimming data of company column

select distinct(industry)
from layoffs_stagging2
order by 1;
-- distinct() gives unique single value for many values

update layoffs_stagging2
set industry =  "Crypto"
where industry like "Crypto%";
-- updating table to one single name value 

select * from layoffs_stagging2;


select distinct(country)
from layoffs_stagging2
where country like "United States%";


update layoffs_stagging2
set country =  "United States"
where country like "United States%";


UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- changing date format to ISO date format

select `date`
from layoffs_stagging2;


alter table layoffs_stagging2
modify column `date` date;
-- chainging date datatype from text to date

select * 
from layoffs_stagging2
where industry is Null
or industry = "";


select *
from layoffs_stagging2
where company = "Bally's Interactive";


select *
from layoffs_stagging2 t1
	join layoffs_stagging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
where (t1.industry is null or t1.industry = "")
and t2.industry is not null;
-- Joining same tables to eachother to find null and blank values from table1 which are not present in table2

update layoffs_stagging2
set industry = Null
where industry ="";
-- updating blank values to null for easy transformation

update layoffs_stagging2 t1 
join layoffs_stagging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;
-- updating null values that are present in table1 from the values of table2
-- basically filling null values in t1 with the similar data from table2

select *
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;
-- checking same null values in two columns totallaidoff and percentagelaidoff

delete
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;
-- deleting all same null values from two columns totallaidoff and percentagelaidoff

select * 
from layoffs_stagging2;


alter table layoffs_stagging2
drop column row_num;
-- dropping column row_num