-- ============================================
-- UPDATE AVATAR ANIME BERGERAK PER 5 LEVEL
-- File ini TIDAK mengubah skema tabel yang sudah ada.
-- Hanya melakukan INSERT jika belum ada dan UPDATE kolom image_url + name + description.
-- Kompatibel dengan MySQL (lihat backend/config/database.go -> MySQL driver)
-- ============================================

USE db_auth_robotic;

-- Pastikan stage utama tersedia (setiap 5 level)
INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Chibi Hero', 'Pahlawan mungil memulai perjalanan besar', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif', 1, 0, 0, 0, 0, 0, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 1);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Rookie Ninja', 'Si lincah pemula yang mulai menguasai teknik dasar', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif', 5, 2, 2, 2, 2, 2, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 5);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Blade Knight', 'Ksatria pedang dengan teknik serangan elegan', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif', 10, 5, 3, 5, 2, 3, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 10);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Shadow Ronin', 'Pendekar bayangan yang menguasai kelincahan', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif', 15, 3, 7, 3, 5, 2, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 15);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Aegis Titan', 'Raksasa tameng dengan daya tahan luar biasa', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/131.gif', 20, 4, 4, 8, 3, 5, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 20);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Arcane Sage', 'Pertapa arcane dengan fokus yang tajam', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif', 25, 3, 3, 3, 10, 4, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 25);

INSERT INTO avatar_stages (name, description, image_url, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active)
SELECT 'Vital Guardian', 'Pelindung kehidupan dengan aura energi kuat', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif', 30, 5, 5, 5, 5, 10, 1
WHERE NOT EXISTS (SELECT 1 FROM avatar_stages WHERE required_level = 30);

-- Update konten untuk menggunakan GIF animasi (bergerak)
UPDATE avatar_stages SET 
    name = 'Chibi Hero',
    description = 'Pahlawan mungil memulai perjalanan besar',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif'
WHERE required_level = 1;

UPDATE avatar_stages SET 
    name = 'Rookie Ninja',
    description = 'Si lincah pemula yang mulai menguasai teknik dasar',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif'
WHERE required_level = 5;

UPDATE avatar_stages SET 
    name = 'Blade Knight',
    description = 'Ksatria pedang dengan teknik serangan elegan',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif'
WHERE required_level = 10;

UPDATE avatar_stages SET 
    name = 'Shadow Ronin',
    description = 'Pendekar bayangan yang menguasai kelincahan',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif'
WHERE required_level = 15;

UPDATE avatar_stages SET 
    name = 'Aegis Titan',
    description = 'Raksasa tameng dengan daya tahan luar biasa',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/131.gif'
WHERE required_level = 20;

UPDATE avatar_stages SET 
    name = 'Arcane Sage',
    description = 'Pertapa arcane dengan fokus yang tajam',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif'
WHERE required_level = 25;

UPDATE avatar_stages SET 
    name = 'Vital Guardian',
    description = 'Pelindung kehidupan dengan aura energi kuat',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif'
WHERE required_level = 30;

SELECT '✅ Avatar stages anime animated berhasil diset per level 5' AS status;
