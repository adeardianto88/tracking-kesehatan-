-- Fix avatar stages issue
-- This script ensures avatar stages exist in the database

USE db_auth_robotic;

-- Check if avatar_stages table exists and create if it doesn't
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

-- Clear existing data and insert avatar stages (only if table is empty)
INSERT IGNORE INTO avatar_stages (id, name, description, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active, image_url) VALUES
(1, 'Bulbasaur', 'Pokemon rumput pemula yang kuat dan dapat diandalkan', 1, 0, 0, 0, 0, 0, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif'),
(2, 'Charmander', 'Pokemon api kecil dengan semangat berkobar', 5, 2, 2, 2, 2, 2, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif'),
(3, 'Charizard', 'Naga api legendaris dengan kekuatan menakjubkan', 10, 5, 3, 5, 2, 3, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif'),
(4, 'Pikachu', 'Pokemon listrik yang menggemaskan dan penuh energi', 15, 3, 7, 3, 5, 2, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif'),
(5, 'Wartortle', 'Pokemon air yang seimbang dengan pertahanan kuat', 20, 4, 4, 8, 3, 5, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif'),
(6, 'Mewtwo', 'Pokemon psikis legendaris dengan kekuatan luar biasa', 25, 3, 3, 3, 10, 4, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif'),
(7, 'Rayquaza', 'Pokemon naga langit yang menguasai atmosfer', 30, 5, 5, 5, 5, 10, 1, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif');

-- Verify the data was inserted
SELECT 'Avatar stages fixed successfully!' as status;
SELECT COUNT(*) as avatar_stages_count FROM avatar_stages;
SELECT id, name, required_level FROM avatar_stages ORDER BY required_level;