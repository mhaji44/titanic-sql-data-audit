SELECT * FROM patients;
SELECT * FROM patients WHERE survived = '1';
SELECT * FROM patients WHERE class = '3';
SELECT gender, count(*) FROM patients WHERE survived = '1' GROUP BY gender;
SELECT survived, avg(fare) FROM patients GROUP BY survived;
SELECT * FROM patients WHERE age IS NULL;
SELECT * FROM patients WHERE age IS NOT NULL;
SELECT * FROM patients WHERE class = '2';
SELECT * FROM patients WHERE embarked = 'S';
SELECT embarked, COUNT(*) FROM patients GROUP BY embarked;
SELECT age,
	CASE
		WHEN age >= 18 THEN 'Adult'
		WHEN age <18 THEN 'Child'
		ELSE 'unknown'
	END AS Age_Group,
	COUNT(*)
FROM patients
GROUP BY Age_Group;

SELECT
	passenger_id AS passenger_id,
	survived AS survived_status,
	class AS passenger_class,
	name AS passenger_name,
	gender AS passenger_gender,
	age AS passenger_age
FROM patients
WHERE age IS NOT NULL
LIMIT 10;

SELECT
	gender AS gender,
	CASE
		WHEN age >= 18 THEN 'Adult'
		WHEN age < 18 THEN 'Child'
		ELSE 'Unknown'
	END AS age_group,
	COUNT (*) AS total_count
FROM patients
WHERE gender != 'Sex'
GROUP BY gender, age_group;

SELECT	
	survived AS survived_status,
	COUNT (*) as passenger_count
FROM patients
WHERE age BETWEEN 20 AND 30
GROUP BY survived_status;

ALTER TABLE patients RENAME COLUMN passenger_id TO passenger_id;
ALTER TABLE patients RENAME COLUMN survived TO survived;
ALTER TABLE patients RENAME COLUMN class TO class;
ALTER TABLE patients RENAME COLUMN name TO name;
ALTER TABLE patients RENAME COLUMN gender TO gender;
ALTER TABLE patients RENAME COLUMN age TO age;
ALTER TABLE patients RENAME COLUMN sibsp TO sibsp;
ALTER TABLE patients RENAME COLUMN parch TO parch;
ALTER TABLE patients RENAME COLUMN ticket_number TO ticket_number;
ALTER TABLE patients RENAME COLUMN fare TO fare;
ALTER TABLE patients RENAME COLUMN cabin TO cabin;
ALTER TABLE patients RENAME COLUMN embarked TO embarked;

SELECT
	gender,
	survived,
	COUNT(*) AS passenger_count
FROM patients
WHERE gender != 'Sex'
GROUP BY gender, survived;

SELECT	
	gender,
	CASE	
		WHEN survived = '1' THEN 'Survived'
		WHEN survived = '0' THEN 'Perished'
		ELSE 'Unknown'
	END AS survival_status,
	COUNT(*) AS passenger_count
FROM patients 
WHERE gender != 'Sex'
GROUP BY gender, survival_status;

SELECT 
	class,
	COUNT(*) AS total_passengers,
	AVG(fare) AS average_fare
FROM patients
WHERE class != 'Pclass'
GROUP BY class
ORDER BY class ASC;

SELECT
	name,
	age,
	fare
FROM patients
WHERE age < 18 
	AND age IS NOT NULL
	AND gender = 'Female'
ORDER BY age ASC;

SELECT 
	class,
	COUNT(*) AS survivng_elite
FROM patients
WHERE survived = '1'
	AND class = '1'
GROUP BY class;
 
 SELECT
	CASE 
		WHEN fare <10 THEN 'Cheap'
		WHEN fare BETWEEN 10 AND 50 THEN 'Moderate'
		WHEN fare >50 THEN 'Expensive'
	END AS price_category,
	COUNT(*) passenger_count
FROM patients
WHERE fare != 'Fare'
GROUP BY 
	CASE
		WHEN fare <10 THEN 'Cheap'
		WHEN fare BETWEEN 10 AND 50 THEN 'Moderate'
		WHEN fare >50 THEN 'Expensive'
	END;
	
SELECT 
	embarked,
	COUNT(*) AS surviving_adults
FROM patients
WHERE survived = '1' 
	AND age >= 18
	AND embarked != 'Embarked'
	AND embarked IS NOT NULL
GROUP BY embarked
ORDER BY surviving_adults DESC;

SELECT
	survived,
	AVG(fare) AS average_fare_paid,
	MAX(fare) AS highest_fare_paid
FROM patients
WHERE fare != 'Fare'
	AND survived IS NOT NULL
GROUP BY survived
ORDER BY average_fare_paid DESC;

SELECT
	class,
	gender,
		COUNT(*) AS total_survivors
FROM patients
WHERE survived = '1'
	AND survived IS NOT NULL
	AND class !='Pclass'
	AND gender != 'Sex'
GROUP BY class, gender
ORDER BY class ASC, total_survivors DESC;

SELECT
	age,
	class,
		COUNT(*) AS total_perished
FROM patients
WHERE survived = '0'
	AND age IS NOT NULL
	AND class IS NOT NULL
	AND class != 'Pclass'
	AND age != 'Age'
GROUP BY class, age
ORDER BY total_perished DESC;
	
SELECT
	UPPER(name),
	LOWER(gender)
FROM patients;

SELECT	
	SUBSTR(gender,1,1)
FROM patients;

SELECT 
	ROUND(AVG(fare),2)
FROM patients
WHERE fare != 'Fare';

SELECT
	name,
	age,
	age + 8 AS age_in_1920,
	ROUND(fare*1.1,2) AS fare_with_tax
FROM patients
WHERE fare != 'Fare';

SELECT DISTINCT embarked
FROM patients
WHERE embarked != 'Embarked';

SELECT DISTINCT
	class
FROM patients 
WHERE class != 'Pclass';

SELECT 
	class,
COUNT (*) AS total_passengers
FROM patients
WHERE class != 'Pclass'
GROUP BY class;

SELECT
	embarked,
	COUNT(*) AS total_embarked
FROM patients
WHERE embarked != 'Embarked'
GROUP BY embarked;

SELECT	
	name,
	fare
FROM patients
WHERE fare != 'Fare'
ORDER BY fare DESC
LIMIT 5;

SELECT
	class,
	ROUND(AVG(fare), 2) AS average_fare
FROM patients
WHERE class != 'Pclass'
	AND fare != 'Fare'
GROUP BY class
HAVING average_fare >30
ORDER BY average_fare DESC
LIMIT 3;

SELECT	
	class,
	UPPER(gender) AS clean_gender,
	embarked,
	ROUND(AVG(fare), 2) AS average_fare
FROM patients 
WHERE class != 'Pclass'
	AND gender != 'Gender'
	AND embarked = 'S'
	AND class != '1'
GROUP BY gender,
	class
HAVING average_fare >10
ORDER BY average_fare DESC
LIMIT 2;

SELECT
	embarked AS embarkation_port,
	survived,
	class,
	ROUND(AVG(fare), 2) AS average_fare
FROM patients
WHERE survived = '1'
	AND fare != 'Fare'
	AND class != 'Pclass'
GROUP by embarked, class
HAVING average_fare BETWEEN 10 AND 30
ORDER BY average_fare DESC;

SELECT
	class,
	ROUND(AVG(fare), 2) AS average_fare,
	embarked AS embarkation_port
FROM patients
WHERE class != 'Pclass' 
	AND class != '1'
	AND fare != 'Fare'
	AND parch >0
GROUP BY class, embarkation_port, parch
ORDER BY average_fare DESC;

SELECT
	class,
	ROUND(AVG(fare) ,2) AS average_fare,
	COUNT(*) AS passenger_count
FROM patients
WHERE class != 'Pclass'
	AND fare != 'Fare'
	AND gender = 'female'
	AND fare >=20
	AND embarked != 'S'
GROUP BY class
HAVING average_fare >30
ORDER BY average_fare DESC
LIMIT 2;

SELECT 
	embarked AS embarkation_port,
	class,
		COUNT(*) AS survivors,
	ROUND(MAX(fare) ,2) AS highest_fare
FROM patients
WHERE gender = 'male'
	AND survived = '1'
	AND embarked != 'Q'
GROUP BY embarkation_port, class
HAVING survivors >= 5
ORDER BY highest_fare DESC;

SELECT
	ROUND(AVG(fare),2) AS group_average_fare,
	class,
	COUNT(*) AS above_average_survivors
FROM patients 
WHERE fare > (SELECT AVG(fare) FROM patients WHERE fare != 'Fare')
	AND class != 'Pclass'
	AND fare != 'Fare'
	AND survived = '1'
GROUP BY class
ORDER BY group_average_fare DESC;

WITH average_fare_table AS (
	SELECT AVG(CAST(fare AS NUMERIC)) AS overall_avg
	FROM patients 
	WHERE fare != 'Fare'
)
SELECT	
	p.class,
	COUNT (*) AS total_passengers
FROM patients p, average_fare_table avg_tbl
WHERE CAST (p.fare AS NUMERIC) > avg_tbl.overall_avg
GROUP BY p.class;

SELECT
	name,
	class,
	CAST(fare AS NUMERIC) AS fare_num,
	DENSE_RANK() OVER (
	PARTITION BY class
	ORDER BY CAST (fare AS NUMERIC) DESC
	) AS fare_rank_in_class
FROM patients 
WHERE fare != 'Fare' AND class != 'Pclass'
LIMIT 15;

SELECT
	p1.name AS passenger_1,
	p2.name AS passenger_2,
	p1.class,
	CAST(p1.fare AS NUMERIC) AS shared_fare
FROM patients p1
JOIN patients p2
	ON p1.fare = p2.fare
WHERE p1.name != p2.name
	AND p1.fare != 'Fare'
	AND CAST(p1.fare AS NUMERIC) >0
ORDER BY shared_fare DESC
LIMIT 15;