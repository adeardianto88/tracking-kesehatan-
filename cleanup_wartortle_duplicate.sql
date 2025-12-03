-- Cleanup duplicate Wartortle entries
-- Remove Wartortle level 20 since Pikachu already exists at level 20
-- Migrate all references to Wartortle level 15 (canonical)

USE db_auth_robotic;

-- Step 1: Ensure canonical Wartortle L15 exists
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Wartortle', 'Turtle air yang tangguh',
       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif',
       15, 3, 3, 5, 3, 4, 1
WHERE NOT EXISTS (
  SELECT 1 FROM avatar_stages WHERE name='Wartortle' AND required_level=15
);

-- Step 2: Get the canonical Wartortle L15 ID for migration
SET @canonical_wartortle_id = (SELECT id FROM avatar_stages WHERE name='Wartortle' AND required_level=15 LIMIT 1);

-- Step 3: Migrate unlocked_avatars from Wartortle L20 to L15
-- First, insert new unlock records for users who only had L20
INSERT IGNORE INTO unlocked_avatars (user_id, avatar_stage_id, unlocked_at, created_at, updated_at)
SELECT ua.user_id, @canonical_wartortle_id, ua.unlocked_at, NOW(), NOW()
FROM unlocked_avatars ua
JOIN avatar_stages a ON ua.avatar_stage_id = a.id
WHERE a.name = 'Wartortle' AND a.required_level = 20;

-- Step 4: Delete old Wartortle L20 unlock records
DELETE ua FROM unlocked_avatars ua
JOIN avatar_stages a ON ua.avatar_stage_id = a.id
WHERE a.name = 'Wartortle' AND a.required_level = 20;

-- Step 5: Update user_stats current avatar from Wartortle L20 to L15
UPDATE user_stats us
JOIN avatar_stages a ON us.avatar_stage_id = a.id
SET us.avatar_stage_id = @canonical_wartortle_id
WHERE a.name = 'Wartortle' AND a.required_level = 20;

-- Step 6: Delete Wartortle L20 entry completely
DELETE FROM avatar_stages 
WHERE name = 'Wartortle' AND required_level = 20;

-- Step 7: Verify cleanup
SELECT 'Wartortle cleanup complete!' AS status;
SELECT id, name, required_level, is_active 
FROM avatar_stages 
WHERE name = 'Wartortle' 
ORDER BY required_level;

-- Show all active avatar stages for verification
SELECT id, name, required_level, is_active 
FROM avatar_stages 
WHERE is_active = 1
ORDER BY required_level, name;