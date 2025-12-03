-- Canonicalize avatar stages to match backend logic and fix duplicates
-- This script will:
-- 1) Ensure a canonical row exists per avatar with the correct required_level and attribute thresholds
-- 2) Migrate user unlocks and current avatar references from any duplicate/old rows to the canonical row
-- 3) Deactivate non-canonical duplicates to avoid future confusion

USE db_auth_robotic;

-- Ensure table exists
CREATE TABLE IF NOT EXISTS avatar_stages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    required_level INT NOT NULL,
    required_strength INT DEFAULT 0,
    required_agility INT DEFAULT 0,
    required_endurance INT DEFAULT 0,
    required_focus INT DEFAULT 0,
    required_vitality INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- Ensure unlocks table exists
CREATE TABLE IF NOT EXISTS unlocked_avatars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    avatar_stage_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_unlocked_avatar_stage_id FOREIGN KEY (avatar_stage_id) REFERENCES avatar_stages(id)
);

-- Helper: upsert canonical stage by name
-- We will use INSERT ... ON DUPLICATE KEY UPDATE if unique index exists,
-- but since it may not, we do manual upsert style: update if exists by (name, required_level), else insert.

-- BULBASAUR (L1)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Bulbasaur', 'Pokemon rumput pemula yang kuat dan dapat diandalkan',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
       1, 0, 0, 0, 0, 0, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Bulbasaur' AND required_level=1
);

-- CHARMANER (L5)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Charmander', 'Pokemon api kecil dengan semangat berkobar',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif',
       5, 2, 2, 2, 2, 2, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Charmander' AND required_level=5
);

-- CHARIZARD (L10, 4/3/3/2/3)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Charizard', 'Evolusi naga api yang perkasa',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif',
       10, 4, 3, 3, 2, 3, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Charizard' AND required_level=10
);

-- WARTORTLE (L15, 3/3/5/3/4)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Wartortle', 'Turtle air yang tangguh',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif',
       15, 3, 3, 5, 3, 4, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Wartortle' AND required_level=15
);

-- PIKACHU (L20, 4/6/4/3/3)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Pikachu', 'Listrik cepat dan lincah',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif',
       20, 4, 6, 4, 3, 3, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Pikachu' AND required_level=20
);

-- MEWTWO (L25, 5/5/5/7/4)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Mewtwo', 'Psikis legendaris dengan kekuatan luar biasa',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif',
       25, 5, 5, 5, 7, 4, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Mewtwo' AND required_level=25
);

-- RAYQUAZA (L30, 7/6/6/6/6)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Rayquaza', 'Penguasa langit yang legendaris',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif',
       30, 7, 6, 6, 6, 6, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Rayquaza' AND required_level=30
);

-- Sync attributes and set canonical active rows for each name to match backend
UPDATE avatar_stages SET 
  description='Pokemon rumput pemula yang kuat dan dapat diandalkan',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
  required_strength=0, required_agility=0, required_endurance=0, required_focus=0, required_vitality=0,
  is_active=1
WHERE name='Bulbasaur' AND required_level=1;

UPDATE avatar_stages SET 
  description='Pokemon api kecil dengan semangat berkobar',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif',
  required_strength=2, required_agility=2, required_endurance=2, required_focus=2, required_vitality=2,
  is_active=1
WHERE name='Charmander' AND required_level=5;

UPDATE avatar_stages SET 
  description='Evolusi naga api yang perkasa',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif',
  required_strength=4, required_agility=3, required_endurance=3, required_focus=2, required_vitality=3,
  is_active=1
WHERE name='Charizard' AND required_level=10;

UPDATE avatar_stages SET 
  description='Turtle air yang tangguh',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif',
  required_strength=3, required_agility=3, required_endurance=5, required_focus=3, required_vitality=4,
  is_active=1
WHERE name='Wartortle' AND required_level=15;

UPDATE avatar_stages SET 
  description='Listrik cepat dan lincah',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif',
  required_strength=4, required_agility=6, required_endurance=4, required_focus=3, required_vitality=3,
  is_active=1
WHERE name='Pikachu' AND required_level=20;

UPDATE avatar_stages SET 
  description='Psikis legendaris dengan kekuatan luar biasa',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif',
  required_strength=5, required_agility=5, required_endurance=5, required_focus=7, required_vitality=4,
  is_active=1
WHERE name='Mewtwo' AND required_level=25;

UPDATE avatar_stages SET 
  description='Penguasa langit yang legendaris',
  image_url='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif',
  required_strength=7, required_agility=6, required_endurance=6, required_focus=6, required_vitality=6,
  is_active=1
WHERE name='Rayquaza' AND required_level=30;

-- Migrate data from non-canonical rows (by name) to canonical rows
-- Wartortle: move from any row where name='Wartortle' and required_level<>15 to the canonical L15 row
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at, created_at, updated_at)
SELECT ua.user_id, a_new.id, COALESCE(ua.unlocked_at, NOW()), NOW(), NOW()
FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Wartortle' AND a_old.required_level <> 15
JOIN avatar_stages a_new ON a_new.name='Wartortle' AND a_new.required_level = 15;

DELETE ua FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Wartortle' AND a_old.required_level <> 15;

UPDATE user_stats us
JOIN avatar_stages a_old ON us.avatar_stage_id = a_old.id AND a_old.name='Wartortle' AND a_old.required_level <> 15
JOIN avatar_stages a_new ON a_new.name='Wartortle' AND a_new.required_level = 15
SET us.avatar_stage_id = a_new.id;

UPDATE avatar_stages SET is_active=0 WHERE name='Wartortle' AND required_level <> 15;

-- Pikachu: canonical L20
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at, created_at, updated_at)
SELECT ua.user_id, a_new.id, COALESCE(ua.unlocked_at, NOW()), NOW(), NOW()
FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Pikachu' AND a_old.required_level <> 20
JOIN avatar_stages a_new ON a_new.name='Pikachu' AND a_new.required_level = 20;

DELETE ua FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Pikachu' AND a_old.required_level <> 20;

UPDATE user_stats us
JOIN avatar_stages a_old ON us.avatar_stage_id = a_old.id AND a_old.name='Pikachu' AND a_old.required_level <> 20
JOIN avatar_stages a_new ON a_new.name='Pikachu' AND a_new.required_level = 20
SET us.avatar_stage_id = a_new.id;

UPDATE avatar_stages SET is_active=0 WHERE name='Pikachu' AND required_level <> 20;

-- Charizard: canonical L10
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at, created_at, updated_at)
SELECT ua.user_id, a_new.id, COALESCE(ua.unlocked_at, NOW()), NOW(), NOW()
FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Charizard' AND a_old.required_level <> 10
JOIN avatar_stages a_new ON a_new.name='Charizard' AND a_new.required_level = 10;

DELETE ua FROM unlocked_avatars ua
JOIN avatar_stages a_old ON ua.avatar_stage_id = a_old.id AND a_old.name='Charizard' AND a_old.required_level <> 10;

UPDATE user_stats us
JOIN avatar_stages a_old ON us.avatar_stage_id = a_old.id AND a_old.name='Charizard' AND a_old.required_level <> 10
JOIN avatar_stages a_new ON a_new.name='Charizard' AND a_new.required_level = 10
SET us.avatar_stage_id = a_new.id;

UPDATE avatar_stages SET is_active=0 WHERE name='Charizard' AND required_level <> 10;

-- Charmander: canonical L5
UPDATE avatar_stages SET is_active=0 WHERE name='Charmander' AND required_level <> 5;
-- Bulbasaur: canonical L1
UPDATE avatar_stages SET is_active=0 WHERE name='Bulbasaur' AND required_level <> 1;
-- Mewtwo: canonical L25
UPDATE avatar_stages SET is_active=0 WHERE name='Mewtwo' AND required_level <> 25;
-- Rayquaza: canonical L30
UPDATE avatar_stages SET is_active=0 WHERE name='Rayquaza' AND required_level <> 30;

SELECT 'Canonicalization complete' AS status;
SELECT name, required_level, is_active FROM avatar_stages ORDER BY name, required_level;