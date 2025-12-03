-- Clean up duplicate avatar stages
USE db_auth_robotic;

-- Show current avatar stages to see duplicates
SELECT id, name, required_level, is_active FROM avatar_stages ORDER BY name, required_level;

-- Find duplicate Bulbasaur entries
SELECT 
    id, 
    name, 
    required_level, 
    is_active,
    ROW_NUMBER() OVER (PARTITION BY name, required_level ORDER BY id) as row_num
FROM avatar_stages 
WHERE name = 'Bulbasaur';

-- Keep only the first Bulbasaur entry and delete duplicates
-- First, update user_stats to use the first Bulbasaur ID
SET @first_bulbasaur_id = (
    SELECT MIN(id) 
    FROM avatar_stages 
    WHERE name = 'Bulbasaur' AND required_level = 1
);

-- Update user_stats to use the first Bulbasaur
UPDATE user_stats 
SET avatar_stage_id = @first_bulbasaur_id 
WHERE avatar_stage_id IN (
    SELECT id FROM avatar_stages 
    WHERE name = 'Bulbasaur' AND required_level = 1 AND id != @first_bulbasaur_id
);

-- Delete duplicate Bulbasaur entries (keep the one with lowest ID)
DELETE FROM avatar_stages 
WHERE name = 'Bulbasaur' 
AND required_level = 1 
AND id != @first_bulbasaur_id;

-- Show final results
SELECT 'Cleanup completed!' as status;
SELECT id, name, required_level, is_active FROM avatar_stages ORDER BY required_level;
SELECT COUNT(*) as bulbasaur_count FROM avatar_stages WHERE name = 'Bulbasaur';