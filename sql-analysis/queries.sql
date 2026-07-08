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
-- JOIN example
CREATE TABLE sponsor_info (
    sponsor VARCHAR(100) PRIMARY KEY,
    sponsor_type VARCHAR(50)
);

INSERT INTO sponsor_info (sponsor, sponsor_type) VALUES
('Pfizer','Industry'),
('GSK','Industry'),
('Novartis','Industry'),
('BioNTech','Industry'),
('Moderna','Industry');

SELECT t.trial_id, t.sponsor, t.phase, s.sponsor_type
FROM trials t
INNER JOIN sponsor_info s ON t.sponsor = s.sponsor
LIMIT 10;

-- HAVING example
SELECT therapy_area, COUNT(*) AS total
FROM trials
GROUP BY therapy_area
HAVING COUNT(*) > 50;


-- LEFT JOIN example
SELECT t.trial_id, t.sponsor, s.sponsor_type
FROM trials t
LEFT JOIN sponsor_info s ON t.sponsor = s.sponsor
LIMIT 20;

-- CTE (Common Table Expression) example
WITH avg_enrollment AS (
    SELECT AVG(enrollment_n) AS avg_val
    FROM trials
)
SELECT trial_id, sponsor, enrollment_n
FROM trials, avg_enrollment
WHERE enrollment_n > avg_val;

-- Window Functions: LAG and LEAD
SELECT trial_id, sponsor, enrollment_n,
    LAG(enrollment_n) OVER (ORDER BY trial_id) AS previous_enrollment
FROM trials
LIMIT 10;

SELECT trial_id, sponsor, enrollment_n,
    LEAD(enrollment_n) OVER (ORDER BY trial_id) AS next_enrollment
FROM trials
LIMIT 10;

-- Stored Procedure example
DELIMITER //

CREATE PROCEDURE GetSponsorSummary(IN sponsor_name VARCHAR(100))
BEGIN
    SELECT sponsor, COUNT(*) AS total_trials, 
           AVG(enrollment_n) AS avg_enrollment,
           SUM(is_success) AS successful_trials
    FROM trials
    WHERE sponsor = sponsor_name
    GROUP BY sponsor;
END //

DELIMITER ;

-- Call the procedure
-- CALL GetSponsorSummary('Pfizer');

-- View example
CREATE VIEW sponsor_summary AS
SELECT sponsor, 
       COUNT(*) AS total_trials,
       AVG(enrollment_n) AS avg_enrollment,
       SUM(is_success) AS successful_trials
FROM trials
GROUP BY sponsor;

-- Query the view
SELECT * FROM sponsor_summary;
SELECT * FROM sponsor_summary WHERE total_trials > 20;

-- Index example (improves query performance on large datasets)
CREATE INDEX idx_sponsor ON trials(sponsor);

-- Trigger example (auto-logs new trial insertions)
CREATE TABLE trial_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    trial_id VARCHAR(20),
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_trial_insert
AFTER INSERT ON trials
FOR EACH ROW
BEGIN
    INSERT INTO trial_log (trial_id, action)
    VALUES (NEW.trial_id, 'New trial added');
END //
DELIMITER ;
