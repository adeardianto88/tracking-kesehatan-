-- Insert seed data for challenges
INSERT INTO challenges (title, description, type, xp_reward, target_value, category, is_active) VALUES
('Daily Water Goal', 'Drink 2000ml of water today', 'daily', 50, 2000, 'water', 1),
('Healthy Breakfast', 'Log a healthy breakfast meal', 'daily', 30, 1, 'diet', 1),
('Balanced Lunch', 'Log a balanced lunch meal', 'daily', 30, 1, 'diet', 1),
('Light Dinner', 'Log a light dinner meal', 'daily', 30, 1, 'diet', 1),
('Weekly Exercise', 'Complete 3 exercise sessions this week', 'weekly', 150, 3, 'exercise', 1),
('Calorie Control', 'Stay within daily calorie goal for 5 days', 'weekly', 200, 5, 'diet', 1);

-- Insert seed data for avatar stages
INSERT INTO avatar_stages (name, description, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality, is_active) VALUES
('Beginner Robot', 'Your starting avatar', 1, 0, 0, 0, 0, 0, 1),
('Apprentice Bot', 'Level up to unlock this avatar', 5, 2, 2, 2, 2, 2, 1),
('Warrior Mech', 'Prove your strength', 10, 5, 3, 5, 2, 3, 1),
('Ninja Drone', 'Master of agility', 15, 3, 7, 3, 5, 2, 1),
('Endurance Titan', 'Built for endurance', 20, 4, 4, 8, 3, 5, 1),
('Focus Sage', 'Mind over matter', 25, 3, 3, 3, 10, 4, 1),
('Vitality Guardian', 'Peak physical condition', 30, 5, 5, 5, 5, 10, 1);

-- Insert seed data for rewards
INSERT INTO rewards (name, description, type, cost, rarity, is_active) VALUES
('XP Boost Potion', 'Doubles XP gain for 24 hours', 'potion', 100, 'rare', 1),
('Golden Skin', 'Shiny golden avatar skin', 'skin', 500, 'epic', 1),
('Mystery Loot Box', 'Contains random rewards', 'loot_box', 200, 'common', 1),
('Strength Boost', 'Permanently increases strength by 1', 'item', 300, 'rare', 1),
('Energy Drink', 'Restores energy for challenges', 'item', 50, 'common', 1);

SELECT 'Seed data inserted successfully!' as message;
