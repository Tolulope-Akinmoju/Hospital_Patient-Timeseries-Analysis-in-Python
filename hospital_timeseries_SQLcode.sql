USE hospital_timeseries;

-- How many values are there in the given dataset
SELECT COUNT(*)
FROM patients;


-- Count the number of appointments for each day in the given dataset:
SELECT 
    AppointmentDay, COUNT(*) AS Appointments
FROM patients
GROUP BY AppointmentDay; 

-- Calculate the average number of appointments(Set to nearest whole number) per day in the given dataset.
WITH CTE AS (SELECT 
    AppointmentDay, COUNT(*) AS counts
FROM patients
GROUP BY AppointmentDay)
SELECT ROUND(AVG(counts), 0) AS avg_counts
FROM CTE


-- Find the day with the highest number of appointments in the given dataset.
SELECT 
    AppointmentDay, COUNT(*) AS counts
FROM patients
GROUP BY AppointmentDay
ORDER BY counts DESC
LIMIT 1; 


-- Calculate the monthly average number of appointments in the given dataset.
WITH Monthly_count AS (SELECT 
   EXTRACT(MONTH FROM (AppointmentDay)) AS month,
   COUNT(*) AS counts
FROM patients
GROUP BY month)
SELECT month, ROUND(AVG(counts), 0) AS avg_counts
FROM Monthly_count
GROUP BY month



-- the month with the highest number of appointments in the given dataset.
SELECT 
   EXTRACT(MONTH FROM (AppointmentDay)) AS months, COUNT(*) AS counts
FROM patients
GROUP BY months
ORDER BY counts DESC
LIMIT 1;


-- Calculate the weekly average number of appointments in the given dataset.
WITH Weekly_count AS (SELECT 
   EXTRACT(WEEK FROM (AppointmentDay)) AS week,
   COUNT(*) AS counts
FROM patients
GROUP BY week)
SELECT week, ROUND(AVG(counts), 0) AS avg_counts
FROM Weekly_count
GROUP BY week;


-- Find the week with the highest number of appointments in the given dataset.
SELECT 
   EXTRACT(WEEK FROM (AppointmentDay)) AS weeks, COUNT(*) AS counts
FROM patients
GROUP BY weeks
ORDER BY counts DESC
LIMIT 1;


-- What is the distribution of appointments based on gender in the dataset?
SELECT 
    Gender, COUNT(*) AS counts
FROM patients
GROUP BY Gender;


-- Calculate the number of appointments per weekday in the given dataset.
SELECT 
   (WEEKDAY(AppointmentDay)) AS weekday, COUNT(*) AS counts
FROM patients
GROUP BY weekday
ORDER BY weekday;

-- OR
SELECT 
   (DAYNAME(AppointmentDay)) AS dayname, COUNT(*) AS counts
FROM patients
GROUP BY dayname
ORDER BY counts;

-- Calculate the average time between scheduling and the appointment day in the given dataset.
SELECT 
   ROUND(AVG(DATEDIFF(AppointmentDay, ScheduledDay)), 0) AS Avg_time 
FROM patients;


-- Appointment Date Distribution, most to least.   
SELECT AppointmentDay, Count(*) AS count
FROM patients
GROUP BY AppointmentDay
ORDER BY count DESC;
    

-- Did sending SMS have impact on patient attendance.
SELECT SMSReceived, Count(*) AS count
FROM patients
GROUP BY SMSReceived
ORDER BY count DESC;

    

-- Distribution of patient that Showed VS NoShow.    
SELECT NoShow, Count(*) AS count
FROM patients
GROUP BY NoShow;



    
-- Did more males show up for their appointments than the females?
SELECT Gender, NoShow, Count(*) AS count
FROM patients
GROUP BY Gender, NoShow
ORDER BY Gender;


-- what is the month over month appointment changes
WITH monthly_appointment AS(SELECT 
   EXTRACT(MONTH FROM (AppointmentDay)) AS month,
   COUNT(*) AS appointments
FROM patients
GROUP BY month)
SELECT month, appointments,
		LAG(appointments) OVER (ORDER BY month) AS previous_month_appointment,
        appointments- LAG(appointments) OVER (ORDER BY month) AS monthly_appointment_change
FROM monthly_appointment
GROUP BY month;



