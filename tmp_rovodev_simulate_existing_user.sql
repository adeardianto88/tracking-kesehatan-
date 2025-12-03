-- Script untuk mensimulasikan masalah user existing
-- User sudah level 5, avatar current sudah Charmander, tapi unlock record belum ada

USE db_auth_robotic;

-- 1. Insert test user (skip jika sudah ada)
INSERT IGNORE INTO users (id, username, email, password, created_at, updated_at) 
VALUES (999, 'existing_level5_user', 'existing@test.com', '$2a$10$hash', NOW(), NOW());

-- 2. Insert user stats - level 5 dengan stats yang cukup untuk Charmander
INSERT IGNORE INTO user_stats (user_id, xp, level, strength, agility, endurance, focus, vitality, avatar_stage_id, created_at, updated_at)
VALUES (999, 250, 5, 3, 3, 3, 3, 3, 2, NOW(), NOW());

-- 3. Hapus unlock records untuk simulasi bug (user punya avatar tapi ga ada unlock record)
DELETE FROM unlocked_avatars WHERE user_id = 999;

-- 4. Insert hanya Bulbasaur unlock (simulasi kondisi bermasalah)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at, created_at, updated_at)
VALUES (999, 1, NOW(), NOW(), NOW());

-- 5. Check hasil simulasi
SELECT 'Simulated existing user with unlock bug:' as status;

SELECT 
    u.username,
    us.level,
    us.avatar_stage_id as current_avatar_id,
    av.name as current_avatar_name,
    us.strength, us.agility, us.endurance, us.focus, us.vitality
FROM users u
JOIN user_stats us ON u.id = us.user_id
LEFT JOIN avatar_stages av ON us.avatar_stage_id = av.id
WHERE u.id = 999;

SELECT 
    'Unlocked avatars for test user:' as info,
    COUNT(*) as unlocked_count
FROM unlocked_avatars ua
WHERE ua.user_id = 999;

SELECT 
    av.name,
    av.required_level,
    'UNLOCKED' as status
FROM unlocked_avatars ua
JOIN avatar_stages av ON ua.avatar_stage_id = av.id
WHERE ua.user_id = 999
ORDER BY av.required_level;

SELECT '
🐛 BUG SIMULATION COMPLETE!
- User level 5 ✓
- Current avatar: Charmander (ID=2) ✓  
- But only Bulbasaur unlocked ✗
- Missing Charmander unlock record ✗

Test this user with: email=existing@test.com, password=any
' as bug_summary;