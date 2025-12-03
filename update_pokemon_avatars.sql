-- ============================================
-- UPDATE AVATAR NAMES TO POKEMON NAMES
-- Mengubah nama avatar stage menjadi nama Pokemon sesuai permintaan:
-- Level 1: Bulbasaur, Level 5: Charmander, Level 10: Charizard, 
-- Level 15: Pikachu, Level 20: Wartortle, Level 25: Mewtwo, Level 30: Rayquaza
-- ============================================

USE db_auth_robotic;

-- Level 1: Bulbasaur (sprite #1)
UPDATE avatar_stages SET 
    name = 'Bulbasaur',
    description = 'Pokemon rumput pemula yang kuat dan dapat diandalkan',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif'
WHERE required_level = 1;

-- Level 5: Charmander (sprite #4) 
UPDATE avatar_stages SET 
    name = 'Charmander',
    description = 'Pokemon api kecil dengan semangat berkobar',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif'
WHERE required_level = 5;

-- Level 10: Charizard (sprite #6)
UPDATE avatar_stages SET 
    name = 'Charizard',
    description = 'Naga api legendaris dengan kekuatan menakjubkan',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif'
WHERE required_level = 10;

-- Level 15: Pikachu (sprite #25)
UPDATE avatar_stages SET 
    name = 'Pikachu',
    description = 'Pokemon listrik yang menggemaskan dan penuh energi',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif'
WHERE required_level = 15;

-- Level 20: Wartortle (sprite #8 - Wartortle yang benar)
UPDATE avatar_stages SET 
    name = 'Wartortle',
    description = 'Pokemon air yang seimbang dengan pertahanan kuat',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif'
WHERE required_level = 20;

-- Level 25: Mewtwo (sprite #150)
UPDATE avatar_stages SET 
    name = 'Mewtwo',
    description = 'Pokemon psikis legendaris dengan kekuatan luar biasa',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/150.gif'
WHERE required_level = 25;

-- Level 30: Rayquaza (sprite #384)
UPDATE avatar_stages SET 
    name = 'Rayquaza',
    description = 'Pokemon naga langit yang menguasai atmosfer',
    image_url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/384.gif'
WHERE required_level = 30;

-- Verifikasi perubahan
SELECT 
    required_level AS 'Level',
    name AS 'Pokemon Name',
    description AS 'Description',
    image_url AS 'Sprite URL'
FROM avatar_stages 
ORDER BY required_level;

SELECT '✅ Avatar Pokemon berhasil diupdate dengan sprite yang sesuai!' AS status;