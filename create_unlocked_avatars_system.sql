-- SQL Script untuk Avatar Customization System
-- Membuat tabel unlocked_avatars dan mengisi data awal

USE db_auth_robotic;

-- ========================================
-- 1. BUAT TABEL UNLOCKED_AVATARS
-- ========================================

CREATE TABLE IF NOT EXISTS unlocked_avatars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    avatar_stage_id INT NOT NULL,
    unlocked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (avatar_stage_id) REFERENCES avatar_stages(id) ON DELETE CASCADE,
    
    -- Unique constraint untuk mencegah duplicate unlock
    UNIQUE KEY unique_user_avatar (user_id, avatar_stage_id),
    
    -- Index untuk performa
    INDEX idx_user_id (user_id),
    INDEX idx_avatar_stage_id (avatar_stage_id),
    INDEX idx_unlocked_at (unlocked_at),
    INDEX idx_deleted_at (deleted_at)
);

-- ========================================
-- 2. UNLOCK AVATAR AWAL UNTUK USER YANG SUDAH ADA
-- ========================================

-- Unlock avatar yang sedang digunakan user (current avatar)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, us.avatar_stage_id, NOW()
FROM user_stats us
WHERE us.avatar_stage_id IS NOT NULL
  AND us.avatar_stage_id > 0;

-- ========================================
-- 3. AUTO-UNLOCK BERDASARKAN LEVEL DAN STATS
-- ========================================

-- Level 1+ -> Bulbasaur (Default starter - semua user harus punya)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Bulbasaur' 
  AND av.is_active = 1
  AND av.required_level <= us.level;

-- Level 5+ -> Charmander (STR>=2, AGI>=2, END>=2, FOC>=2, VIT>=2)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Charmander' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- Level 10+ -> Charizard (STR>=5, AGI>=3, END>=5, FOC>=2, VIT>=3)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Charizard' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- Level 15+ -> Pikachu (STR>=3, AGI>=7, END>=3, FOC>=5, VIT>=2)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Pikachu' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- Level 20+ -> Wartortle (STR>=4, AGI>=4, END>=8, FOC>=3, VIT>=5)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Wartortle' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- Level 25+ -> Mewtwo (STR>=3, AGI>=3, END>=3, FOC>=10, VIT>=4)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Mewtwo' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- Level 30+ -> Rayquaza (STR>=5, AGI>=5, END>=5, FOC>=5, VIT>=10)
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at)
SELECT DISTINCT us.user_id, av.id, NOW()
FROM user_stats us
CROSS JOIN avatar_stages av
WHERE av.name = 'Rayquaza' 
  AND av.is_active = 1
  AND us.level >= av.required_level
  AND us.strength >= av.required_strength 
  AND us.agility >= av.required_agility 
  AND us.endurance >= av.required_endurance 
  AND us.focus >= av.required_focus 
  AND us.vitality >= av.required_vitality;

-- ========================================
-- 4. TAMPILKAN HASIL
-- ========================================

SELECT '✅ Tabel unlocked_avatars berhasil dibuat!' as status;

-- Summary total unlocked avatars per user
SELECT 
    u.username,
    us.level,
    COUNT(ua.id) as total_unlocked_avatars,
    GROUP_CONCAT(av.name ORDER BY av.required_level SEPARATOR ', ') as unlocked_avatars
FROM users u
LEFT JOIN user_stats us ON u.id = us.user_id
LEFT JOIN unlocked_avatars ua ON u.id = ua.user_id AND ua.deleted_at IS NULL
LEFT JOIN avatar_stages av ON ua.avatar_stage_id = av.id AND av.is_active = 1
WHERE u.deleted_at IS NULL
GROUP BY u.id, u.username, us.level
ORDER BY us.level DESC, u.username;

-- Summary avatar unlock distribution
SELECT 
    av.name as avatar_name,
    av.required_level,
    COUNT(ua.id) as total_users_unlocked
FROM avatar_stages av
LEFT JOIN unlocked_avatars ua ON av.id = ua.avatar_stage_id AND ua.deleted_at IS NULL
WHERE av.is_active = 1
GROUP BY av.id, av.name, av.required_level
ORDER BY av.required_level;

-- Check if any user has multiple unlocked avatars (ready for customization)
SELECT 
    COUNT(*) as users_with_multiple_avatars
FROM (
    SELECT ua.user_id
    FROM unlocked_avatars ua
    WHERE ua.deleted_at IS NULL
    GROUP BY ua.user_id
    HAVING COUNT(ua.id) > 1
) as multi_avatar_users;

SELECT '🎨 Avatar Customization System siap digunakan!' as final_status;