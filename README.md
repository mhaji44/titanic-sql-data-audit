# Titanic Passenger SQL Analysis \& Data Audit

## 

## Project Overview

This repository contains a comprehensive, end-to-end exploratory data analysis (EDA) and data auditing project conducted on the Titanic passenger database (`patients` table) using **SQLite**.



The project traces an entire analytical workflow: from initial data exploration and data quality auditing, through schema refactoring and conditional logic, up to advanced relational querying techniques like Subqueries, Common Table Expressions (CTEs), Window Functions, and Self-JOINs.

\---

## 

## Complete SQL Query Log \& Technical Progression

Below is the complete sequence of SQL queries developed during this audit, organized by technical category.

### 1\. Initial Data Exploration \& Inspection

```sql
-- Full dataset preview
SELECT \* FROM patients;

-- Initial survival filtering
SELECT \* FROM patients WHERE survived = '1';

-- Class-specific inspection
SELECT \* FROM patients WHERE class = '3';
SELECT \* FROM patients WHERE class = '2';

-- Port of Embarkation inspection
SELECT \* FROM patients WHERE embarked = 'S';

-- Inspecting missing demographic values
SELECT \* FROM patients WHERE age IS NULL;
SELECT \* FROM patients WHERE age IS NOT NULL;
```

\---

### 2\. Demographic Categorisation \& Conditional Logic (`CASE WHEN`)

```sql
-- Gender breakdown of survivors
SELECT gender, COUNT(\*) 
FROM patients 
WHERE survived = '1' 
GROUP BY gender;

-- Basic survival fare average
SELECT survived, AVG(fare) 
FROM patients 
GROUP BY survived;

-- Port of embarkation distribution
SELECT embarked, COUNT(\*) 
FROM patients 
GROUP BY embarked;

-- Age group categorisation (Adult vs Child)
SELECT age,
	CASE
		WHEN age >= 18 THEN 'Adult'
		WHEN age < 18 THEN 'Child'
		ELSE 'unknown'
	END AS Age\_Group,
	COUNT(\*)
FROM patients
GROUP BY Age\_Group;

-- Clean column aliasing \& age filtering
SELECT
	passenger\_id AS passenger\_id,
	survived AS survived\_status,
	class AS passenger\_class,
	name AS passenger\_name,
	gender AS passenger\_gender,
	age AS passenger\_age
FROM patients
WHERE age IS NOT NULL
LIMIT 10;

-- Multi-dimensional grouping: Gender \& Age Group
SELECT
	gender AS gender,
	CASE
		WHEN age >= 18 THEN 'Adult'
		WHEN age < 18 THEN 'Child'
		ELSE 'Unknown'
	END AS age\_group,
	COUNT (\*) AS total\_count
FROM patients
WHERE gender != 'Sex'
GROUP BY gender, age\_group;

-- Survival count for young adults (Ages 20-30)
SELECT	
	survived AS survived\_status,
	COUNT (\*) as passenger\_count
FROM patients
WHERE age BETWEEN 20 AND 30
GROUP BY survived\_status;
```

\---

### 3\. Schema Standardisation \& Data Cleansing

```sql
-- Column renaming and schema stabilisation
ALTER TABLE patients RENAME COLUMN passenger\_id TO passenger\_id;
ALTER TABLE patients RENAME COLUMN survived TO survived;
ALTER TABLE patients RENAME COLUMN class TO class;
ALTER TABLE patients RENAME COLUMN name TO name;
ALTER TABLE patients RENAME COLUMN gender TO gender;
ALTER TABLE patients RENAME COLUMN age TO age;
ALTER TABLE patients RENAME COLUMN sibsp TO sibsp;
ALTER TABLE patients RENAME COLUMN parch TO parch;
ALTER TABLE patients RENAME COLUMN ticket\_number TO ticket\_number;
ALTER TABLE patients RENAME COLUMN fare TO fare;
ALTER TABLE patients RENAME COLUMN cabin TO cabin;
ALTER TABLE patients RENAME COLUMN embarked TO embarked;

-- String manipulation testing
SELECT UPPER(name), LOWER(gender) FROM patients;
SELECT SUBSTR(gender,1,1) FROM patients;

-- Distinct value verification
SELECT DISTINCT embarked FROM patients WHERE embarked != 'Embarked';
SELECT DISTINCT class FROM patients WHERE class != 'Pclass';
```

\---

### 4\. Survival \& Price Tier Analytics

```sql
-- Gender breakdown by survival status
SELECT
	gender,
	survived,
	COUNT(\*) AS passenger\_count
FROM patients
WHERE gender != 'Sex'
GROUP BY gender, survived;

-- Human-readable survival labeling
SELECT	
	gender,
	CASE	
		WHEN survived = '1' THEN 'Survived'
		WHEN survived = '0' THEN 'Perished'
		ELSE 'Unknown'
	END AS survival\_status,
	COUNT(\*) AS passenger\_count
FROM patients 
WHERE gender != 'Sex'
GROUP BY gender, survival\_status;

-- Class-based passenger count and fare averages
SELECT 
	class,
	COUNT(\*) AS total\_passengers,
	AVG(fare) AS average\_fare
FROM patients
WHERE class != 'Pclass'
GROUP BY class
ORDER BY class ASC;

-- Female child passenger listing
SELECT
	name,
	age,
	fare
FROM patients
WHERE age < 18 
	AND age IS NOT NULL
	AND gender = 'Female'
ORDER BY age ASC;

-- 1st Class Survivor Count
SELECT 
	class,
	COUNT(\*) AS survivng\_elite
FROM patients
WHERE survived = '1'
	AND class = '1'
GROUP BY class;

-- Pricing Category Bucketing (Cheap, Moderate, Expensive)
SELECT 
	CASE 
		WHEN fare < 10 THEN 'Cheap'
		WHEN fare BETWEEN 10 AND 50 THEN 'Moderate'
		WHEN fare > 50 THEN 'Expensive'
	END AS price\_category,
	COUNT(\*) AS passenger\_count
FROM patients
WHERE fare != 'Fare'
GROUP BY 
	CASE
		WHEN fare < 10 THEN 'Cheap'
		WHEN fare BETWEEN 10 AND 50 THEN 'Moderate'
		WHEN fare > 50 THEN 'Expensive'
	END;

-- Adult survivors grouped by embarkation port
SELECT 
	embarked,
	COUNT(\*) AS surviving\_adults
FROM patients
WHERE survived = '1' 
	AND age >= 18
	AND embarked != 'Embarked'
	AND embarked IS NOT NULL
GROUP BY embarked
ORDER BY surviving\_adults DESC;

-- Average vs Maximum Fare Paid by Survival Status
SELECT
	survived,
	AVG(fare) AS average\_fare\_paid,
	MAX(fare) AS highest\_fare\_paid
FROM patients
WHERE fare != 'Fare'
	AND survived IS NOT NULL
GROUP BY survived
ORDER BY average\_fare\_paid DESC;

-- Survivor breakdown by Class and Gender
SELECT
	class,
	gender,
	COUNT(\*) AS total\_survivors
FROM patients
WHERE survived = '1'
	AND survived IS NOT NULL
	AND class != 'Pclass'
	AND gender != 'Sex'
GROUP BY class, gender
ORDER BY class ASC, total\_survivors DESC;

-- Mortality breakdown by Class and Age
SELECT
	age,
	class,
	COUNT(\*) AS total\_perished
FROM patients
WHERE survived = '0'
	AND age IS NOT NULL
	AND class IS NOT NULL
	AND class != 'Pclass'
	AND age != 'Age'
GROUP BY class, age
ORDER BY total\_perished DESC;
```

\---

### 5\. Advanced Aggregations \& Post-Filter Business Logic (`HAVING`)

```sql
-- Rounded global average fare calculation
SELECT ROUND(AVG(fare), 2) FROM patients WHERE fare != 'Fare';

-- Math projections: Future age in 1920 \& Fare with tax
SELECT
	name,
	age,
	age + 8 AS age\_in\_1920,
	ROUND(fare \* 1.1, 2) AS fare\_with\_tax
FROM patients
WHERE fare != 'Fare';

-- Total passengers per class
SELECT 
	class,
	COUNT(\*) AS total\_passengers
FROM patients
WHERE class != 'Pclass'
GROUP BY class;

-- Total passengers per port
SELECT
	embarked,
	COUNT(\*) AS total\_embarked
FROM patients
WHERE embarked != 'Embarked'
GROUP BY embarked;

-- Top 5 highest ticket prices
SELECT	
	name,
	fare
FROM patients
WHERE fare != 'Fare'
ORDER BY fare DESC
LIMIT 5;

-- High-value passenger classes (Average Fare > $30)
SELECT
	class,
	ROUND(AVG(fare), 2) AS average\_fare
FROM patients
WHERE class != 'Pclass'
	AND fare != 'Fare'
GROUP BY class
HAVING average\_fare > 30
ORDER BY average\_fare DESC
LIMIT 3;

-- Specific class and port thresholding (Port 'S', Non-1st Class, Avg Fare > $10)
SELECT	
	class,
	UPPER(gender) AS clean\_gender,
	embarked,
	ROUND(AVG(fare), 2) AS average\_fare
FROM patients 
WHERE class != 'Pclass'
	AND gender != 'Gender'
	AND embarked = 'S'
	AND class != '1'
GROUP BY gender, class
HAVING average\_fare > 10
ORDER BY average\_fare DESC
LIMIT 2;

-- Average fare ranges for survivors across embarkation ports
SELECT
	embarked AS embarkation\_port,
	survived,
	class,
	ROUND(AVG(fare), 2) AS average\_fare
FROM patients
WHERE survived = '1'
	AND fare != 'Fare'
	AND class != 'Pclass'
GROUP BY embarked, class
HAVING average\_fare BETWEEN 10 AND 30
ORDER BY average\_fare DESC;

-- Family passenger fares (Parents/Children aboard > 0)
SELECT
	class,
	ROUND(AVG(fare), 2) AS average\_fare,
	embarked AS embarkation\_port
FROM patients
WHERE class != 'Pclass' 
	AND class != '1'
	AND fare != 'Fare'
	AND parch > 0
GROUP BY class, embarkation\_port, parch
ORDER BY average\_fare DESC;

-- High fare female passengers outside Port S
SELECT
	class,
	ROUND(AVG(fare), 2) AS average\_fare,
	COUNT(\*) AS passenger\_count
FROM patients
WHERE class != 'Pclass'
	AND fare != 'Fare'
	AND gender = 'female'
	AND fare >= 20
	AND embarked != 'S'
GROUP BY class
HAVING average\_fare > 30
ORDER BY average\_fare DESC
LIMIT 2;

-- High fare male survivors (Excluding Port Q, Survivors >= 5)
SELECT 
	embarked AS embarkation\_port,
	class,
	COUNT(\*) AS survivors,
	ROUND(MAX(fare), 2) AS highest\_fare
FROM patients
WHERE gender = 'male'
	AND survived = '1'
	AND embarked != 'Q'
GROUP BY embarkation\_port, class
HAVING survivors >= 5
ORDER BY highest\_fare DESC;
```

\---

### 6\. Subqueries, Common Table Expressions (CTEs), \& Data Type Casting

```sql
-- Subquery: Comparing passenger fares against overall ship average
SELECT 
	ROUND(AVG(fare), 2) AS group\_average\_fare,
	class,
	COUNT(\*) AS above\_average\_survivors
FROM patients 
WHERE fare > (SELECT AVG(fare) FROM patients WHERE fare != 'Fare')
	AND class != 'Pclass'
	AND fare != 'Fare'
	AND survived = '1'
GROUP BY class
ORDER BY group\_average\_fare DESC;

-- CTE (Common Table Expression): Total passengers above overall average fare by class
WITH average\_fare\_table AS (
	SELECT AVG(CAST(fare AS NUMERIC)) AS overall\_avg
	FROM patients 
	WHERE fare != 'Fare'
)
SELECT	
	p.class,
	COUNT(\*) AS total\_passengers
FROM patients p, average\_fare\_table avg\_tbl
WHERE CAST(p.fare AS NUMERIC) > avg\_tbl.overall\_avg
GROUP BY p.class;
```

\---

### 7\. Window Functions \& Self-JOINs

```sql
-- Window Function: Dense ranking of fares partitioned by passenger class
SELECT
	name,
	class,
	CAST(fare AS NUMERIC) AS fare\_num,
	DENSE\_RANK() OVER (
		PARTITION BY class
		ORDER BY CAST(fare AS NUMERIC) DESC
	) AS fare\_rank\_in\_class
FROM patients 
WHERE fare != 'Fare' AND class != 'Pclass'
LIMIT 15;

-- Self-JOIN: Discovering passenger pairs sharing identical ticket fares (Group Bookings)
SELECT
	p1.name AS passenger\_1,
	p2.name AS passenger\_2,
	p1.class,
	CAST(p1.fare AS NUMERIC) AS shared\_fare
FROM patients p1
JOIN patients p2
	ON p1.fare = p2.fare
WHERE p1.name != p2.name
	AND p1.fare != 'Fare'
	AND CAST(p1.fare AS NUMERIC) > 0
ORDER BY shared\_fare DESC
LIMIT 15;
```

\---

## Key Analytical Insights Uncovered

1. **Demographic Survival Rates:**

   * Female passengers showed a dramatically higher survival rate across all passenger classes compared to male passengers.
   * First Class passengers represented the highest percentage of survivors relative to overall class size.
2. **Fleet Fare Dynamic Benchmarking:**

   * Using explicit `CAST(fare AS NUMERIC)` casting within a CTE, the global average ticket price was dynamically calculated.
   * **Class 1:** 159 passengers paid above the fleet average fare.
   * **Class 2:** 22 passengers paid above the fleet average fare.
   * **Class 3:** 30 passengers paid above the fleet average fare. Data auditing revealed these 3 Third-Class entries represented large extended families purchasing combined group tickets.
3. **Intra-Class Fare Rankings:**

   * Utilising `DENSE\_RANK() OVER (PARTITION BY class ORDER BY ...)`, the top ticket price across the entire ship was **$512.33**, held by 1st-Class passengers Miss Anna Ward, Mr. Thomas Drake Martinez Cardeza, and Mr. Gustave J. Lesurer.
4. **Shared Booking Identification via Self-JOIN:**

   * By executing a relational `Self-JOIN` on `p1.fare = p2.fare`, passenger pairings were mapped to identify travel companions and family units sharing group tickets.

\---

## How to Execute This Project

1. Clone this repository to your local machine.
2. Open **DB Browser for SQLite** (or any preferred SQLite database engine).
3. Create or load the `patients` database table from the raw CSV data.
4. Open the SQL editor and execute queries directly from `queries.sql`.

