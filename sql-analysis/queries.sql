-- WHERE examples
SELECT * FROM trials WHERE phase = 'Phase 3';
SELECT * FROM trials WHERE enrollment_n > 1000;
SELECT * FROM trials WHERE therapy_area = 'oncology' AND is_success = 1;

-- GROUP BY examples
SELECT therapy_area, COUNT(*) AS total_trials
FROM trials
GROUP BY therapy_area;

SELECT sponsor, AVG(enrollment_n) AS avg_enrollment
FROM trials
GROUP BY sponsor;

-- GROUP BY + ORDER BY
SELECT outcome, COUNT(*) AS total
FROM trials
GROUP BY outcome
ORDER BY total DESC;

-- CASE statement
SELECT trial_id, enrollment_n,
    CASE
        WHEN enrollment_n < 200 THEN 'Small'
        WHEN enrollment_n BETWEEN 200 AND 1000 THEN 'Medium'
        ELSE 'Large'
    END AS trial_size
FROM trials;

-- Subquery
SELECT * FROM trials
WHERE enrollment_n > (SELECT AVG(enrollment_n) FROM trials);

-- Window function (RANK)
SELECT sponsor, enrollment_n,
    RANK() OVER (ORDER BY enrollment_n DESC) AS enrollment_rank
FROM trials
LIMIT 10;
