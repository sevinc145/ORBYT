-- ORBYT - DATABASE VALIDATION
-- Milestone 3

-- 1. DATABASE AND SCHEMA CHECK
SELECT
    current_database() AS database_name,
    current_schema() AS schema_name;

-- 2. TABLE COUNT
SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'orbyt'
  AND table_type = 'BASE TABLE';

-- 3. RECORD COUNT IN ALL TABLES
SELECT 'users' AS table_name, COUNT(*) AS total_records FROM users
UNION ALL
SELECT 'skills', COUNT(*) FROM skills
UNION ALL
SELECT 'user_skills', COUNT(*) FROM user_skills
UNION ALL
SELECT 'projects', COUNT(*) FROM projects
UNION ALL
SELECT 'project_skills', COUNT(*) FROM project_skills
UNION ALL
SELECT 'project_members', COUNT(*) FROM project_members
UNION ALL
SELECT 'connections', COUNT(*) FROM connections
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL
SELECT 'project_reviews', COUNT(*) FROM project_reviews
UNION ALL
SELECT 'notifications', COUNT(*) FROM notifications
ORDER BY table_name;

-- 4. TRIGGER VALIDATION
SELECT
    event_object_table AS table_name,
    trigger_name
FROM information_schema.triggers
WHERE trigger_schema = 'orbyt'
ORDER BY event_object_table, trigger_name;

-- 5. VIEW VALIDATION
SELECT table_name AS view_name
FROM information_schema.views
WHERE table_schema = 'orbyt'
ORDER BY table_name;

-- 6. PROJECT AND TEAM VALIDATION
SELECT
    p.title,
    COUNT(pm.user_id) AS team_members
FROM projects p
LEFT JOIN project_members pm
    ON p.project_id = pm.project_id
GROUP BY p.project_id, p.title
ORDER BY p.project_id;

-- 7. CONNECTION STATUS VALIDATION
SELECT status, COUNT(*) AS total
FROM connections
GROUP BY status
ORDER BY status;


-- 8. RATINGS VALIDATION
SELECT
    rated_user_id,
    ROUND(AVG(overall_stars), 2) AS average_rating,
    COUNT(*) AS total_ratings
FROM ratings
GROUP BY rated_user_id;


-- 9. SHOWCASE VIEW VALIDATION
SELECT * FROM v_showcase;


-- 10. PLATFORM STATISTICS VALIDATION
SELECT * FROM v_platform_stats;
