
-- 1. USERS

INSERT INTO users
(first_name, last_name, email, password_hash, university, major, role)
VALUES
('Gulsen', 'Xelilova', 'gulsen@example.com', 'demo_hash_1', 'Karabakh University', 'Computer Engineering', 'student'),
('Sevinc', 'Abdullayeva', 'sevinc@example.com', 'demo_hash_2', 'Karabakh University', 'Computer Engineering', 'student'),
('Leyla', 'Residova', 'leyla@example.com', 'demo_hash_3', 'Karabakh University', 'Computer Engineering', 'student'),
('Murad', 'Hasanov', 'murad@example.com', 'demo_hash_4', 'Baku State University', 'Software Engineering', 'student'),
('Kamran', 'Aliyev', 'kamran@example.com', 'demo_hash_5', 'ADA University', 'Computer Science', 'student'),
('Admin', 'User', 'admin@example.com', 'demo_hash_6', 'Karabakh University', 'Administration', 'admin');

-- 2. SKILLS

INSERT INTO skills (skill_name, category)
VALUES
('Python', 'Programming'),
('C++', 'Programming'),
('Java', 'Programming'),
('SQL', 'Database'),
('Machine Learning', 'AI'),
('Computer Vision', 'AI'),
('Arduino', 'Hardware'),
('React', 'Web Development');


-- 3. USER_SKILLS
-- İstifadəçilərin sahib olduğu bacarıqlar

INSERT INTO user_skills (user_id, skill_id)
SELECT u.user_id, s.skill_id
FROM users u
CROSS JOIN skills s
WHERE
    (u.email = 'sevinc@example.com'
     AND s.skill_name IN ('Python', 'C++', 'Machine Learning', 'Computer Vision'))
 OR (u.email = 'gulsen@example.com'
     AND s.skill_name IN ('Python', 'SQL', 'React'))
 OR (u.email = 'leyla@example.com'
     AND s.skill_name IN ('Java', 'SQL'))
 OR (u.email = 'murad@example.com'
     AND s.skill_name IN ('C++', 'Arduino'))
 OR (u.email = 'kamran@example.com'
     AND s.skill_name IN ('Python', 'Java', 'React'));


-- 4. PROJECTS
-- Yeni layihələrin yaradılması

INSERT INTO projects
(captain_id, title, description, status)
VALUES
(
    (SELECT user_id FROM users WHERE email = 'sevinc@example.com'),
    'Azerbaijani Sign Language Recognition',
    'AI-based system for recognizing Azerbaijani Sign Language.',
    'in_progress'
),
(
    (SELECT user_id FROM users WHERE email = 'gulsen@example.com'),
    'Smart Campus',
    'A smart platform for university students.',
    'looking_for_team'
),
(
    (SELECT user_id FROM users WHERE email = 'murad@example.com'),
    'Arduino Rover',
    'A small autonomous robot based on Arduino.',
    'done'
);


-- 5. PROJECT_SKILLS
-- Layihələrin sahib olduğu və ehtiyac duyduğu bacarıqlar

INSERT INTO project_skills (project_id, skill_id, skill_type)
SELECT p.project_id, s.skill_id, data.skill_type
FROM (VALUES
    ('Azerbaijani Sign Language Recognition', 'Python', 'have'),
    ('Azerbaijani Sign Language Recognition', 'Machine Learning', 'need'),
    ('Azerbaijani Sign Language Recognition', 'Computer Vision', 'have'),
    ('Smart Campus', 'React', 'have'),
    ('Smart Campus', 'Java', 'need'),
    ('Smart Campus', 'SQL', 'need'),
    ('Arduino Rover', 'Arduino', 'have'),
    ('Arduino Rover', 'C++', 'have')
) AS data(project_title, skill_name, skill_type)
JOIN projects p ON p.title = data.project_title
JOIN skills s ON s.skill_name = data.skill_name;

-- 6. PROJECT MEMBERS
-- Layihələrə əlavə üzvlərin qoşulması

INSERT INTO project_members (project_id, user_id, member_role)
SELECT p.project_id, u.user_id, 'member'
FROM (VALUES
    ('Azerbaijani Sign Language Recognition', 'Gulsen'),
    ('Azerbaijani Sign Language Recognition', 'Leyla'),
    ('Smart Campus', 'Sevinc'),
    ('Smart Campus', 'Kamran'),
    ('Arduino Rover', 'Leyla'),
    ('Arduino Rover', 'Kamran')
) AS data(project_title, first_name)
JOIN projects p ON p.title = data.project_title
JOIN users u ON u.first_name = data.first_name;


-- 7. CONNECTIONS
-- İstifadəçilər arasında connection sorğuları

INSERT INTO connections
(sender_id, receiver_id, project_id, message, status)
VALUES
(
    (SELECT user_id FROM users WHERE email = 'sevinc@example.com'),
    (SELECT user_id FROM users WHERE email = 'gulsen@example.com'),
    NULL,
    'Hello! Let us connect.',
    'pending'
),
(
    (SELECT user_id FROM users WHERE email = 'leyla@example.com'),
    (SELECT user_id FROM users WHERE email = 'kamran@example.com'),
    NULL,
    'I would like to connect with you.',
    'pending'
),
(
    (SELECT user_id FROM users WHERE email = 'murad@example.com'),
    (SELECT user_id FROM users WHERE email = 'sevinc@example.com'),
    NULL,
    'Let us collaborate!',
    'pending'
);

-- Sevincin Gulsenə göndərdiyi sorğunu qəbul edirik
UPDATE connections
SET status = 'accepted'
WHERE sender_id = (
    SELECT user_id FROM users
    WHERE email = 'sevinc@example.com'
)
AND receiver_id = (
    SELECT user_id FROM users
    WHERE email = 'gulsen@example.com'
);

-- Leylanın Kamrana göndərdiyi sorğunu qəbul edirik
UPDATE connections
SET status = 'accepted'
WHERE sender_id = (
    SELECT user_id FROM users
    WHERE email = 'leyla@example.com'
)
AND receiver_id = (
    SELECT user_id FROM users
    WHERE email = 'kamran@example.com'
);


-- 8. RATINGS
-- İstifadəçilərin bir-birinə verdiyi reytinqlər

INSERT INTO ratings
(rater_id, rated_user_id, project_id,
 overall_stars, communication, punctuality,
 technical_skill, teamwork, comment)
VALUES
(
    (SELECT user_id FROM users WHERE email = 'sevinc@example.com'),
    (SELECT user_id FROM users WHERE email = 'gulsen@example.com'),
    (SELECT project_id FROM projects WHERE title = 'Azerbaijani Sign Language Recognition'),
    5, 5, 5, 5, 5,
    'Excellent teamwork and communication.'
),
(
    (SELECT user_id FROM users WHERE email = 'leyla@example.com'),
    (SELECT user_id FROM users WHERE email = 'kamran@example.com'),
    (SELECT project_id FROM projects WHERE title = 'Smart Campus'),
    4, 5, 4, 4, 5,
    'Very good collaboration.'
);


-- 9. PROJECT_REVIEWS
-- Tamamlanmış layihələrə verilən rəylər

INSERT INTO project_reviews
(project_id, reviewer_id, stars, comment)
VALUES
(
    (SELECT project_id FROM projects
     WHERE title = 'Arduino Rover'),
    (SELECT user_id FROM users
     WHERE email = 'leyla@example.com'),
    5,
    'Great project with an interesting robotics solution.'
),
(
    (SELECT project_id FROM projects
     WHERE title = 'Arduino Rover'),
    (SELECT user_id FROM users
     WHERE email = 'kamran@example.com'),
    4,
    'Good implementation and creative idea.'
);
