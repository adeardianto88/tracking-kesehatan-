-- ============================================
-- Robotic Auth Database - Updated with Weight Records
-- ============================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS db_auth_robotic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_auth_robotic;

-- Table: users (already exists, but for completeness)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- Table: weight_records (NEW TABLE)
CREATE TABLE IF NOT EXISTS weight_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    height INT NOT NULL,
    bmi DECIMAL(4,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_recorded_at (recorded_at)
) ENGINE=InnoDB;

-- Table: water_records (NEW TABLE)
CREATE TABLE IF NOT EXISTS water_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    amount_ml INT NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_recorded_at (recorded_at)
) ENGINE=InnoDB;

-- Table: blood_pressure_records (NEW TABLE)
CREATE TABLE IF NOT EXISTS blood_pressure_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    systolic INT NOT NULL,
    diastolic INT NOT NULL,
    pulse INT,
    measurement_date TIMESTAMP NOT NULL,
    notes TEXT,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_measurement_date (measurement_date)
) ENGINE=InnoDB;

SELECT 'Database db_auth_robotic with all health tracking tables are ready!' as message;

-- Table: challenges
CREATE TABLE IF NOT EXISTS challenges (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    xp_reward INT NOT NULL,
    target_value INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_type (type),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: rewards
CREATE TABLE IF NOT EXISTS rewards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    cost INT NOT NULL,
    rarity VARCHAR(50) DEFAULT 'common',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_type (type),
    INDEX idx_rarity (rarity),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: avatar_stages
CREATE TABLE IF NOT EXISTS avatar_stages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    required_level INT NOT NULL,
    required_strength INT DEFAULT 0,
    required_agility INT DEFAULT 0,
    required_endurance INT DEFAULT 0,
    required_focus INT DEFAULT 0,
    required_vitality INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_required_level (required_level),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: user_stats
CREATE TABLE IF NOT EXISTS user_stats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    xp INT DEFAULT 0,
    level INT DEFAULT 1,
    strength INT DEFAULT 1,
    agility INT DEFAULT 1,
    endurance INT DEFAULT 1,
    focus INT DEFAULT 1,
    vitality INT DEFAULT 1,
    avatar_stage_id INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (avatar_stage_id) REFERENCES avatar_stages(id),
    INDEX idx_user_id (user_id),
    INDEX idx_level (level),
    INDEX idx_avatar_stage_id (avatar_stage_id)
) ENGINE=InnoDB;

-- Table: challenge_completions
CREATE TABLE IF NOT EXISTS challenge_completions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    challenge_id INT NOT NULL,
    completed_at TIMESTAMP NOT NULL,
    xp_earned INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_challenge_id (challenge_id),
    INDEX idx_completed_at (completed_at)
) ENGINE=InnoDB;

-- Table: user_rewards
CREATE TABLE IF NOT EXISTS user_rewards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    reward_id INT NOT NULL,
    quantity INT DEFAULT 1,
    purchased_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reward_id) REFERENCES rewards(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_reward_id (reward_id),
    INDEX idx_purchased_at (purchased_at)
) ENGINE=InnoDB;

-- Table: food_logs
CREATE TABLE IF NOT EXISTS food_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    food_name VARCHAR(255) NOT NULL,
    calories INT NOT NULL,
    protein DECIMAL(5,2) DEFAULT 0,
    carbs DECIMAL(5,2) DEFAULT 0,
    fat DECIMAL(5,2) DEFAULT 0,
    meal_type VARCHAR(50) NOT NULL,
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_meal_type (meal_type),
    INDEX idx_logged_at (logged_at)
) ENGINE=InnoDB;

-- Insert default avatar stages
INSERT INTO avatar_stages (name, description, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality) VALUES
('Beginner Robot', 'Your starting avatar', 1, 0, 0, 0, 0, 0),
('Apprentice Bot', 'Level up to unlock this avatar', 5, 2, 2, 2, 2, 2),
('Warrior Mech', 'Prove your strength', 10, 5, 3, 5, 2, 3),
('Ninja Drone', 'Master of agility', 15, 3, 7, 3, 5, 2),
('Endurance Titan', 'Built for endurance', 20, 4, 4, 8, 3, 5),
('Focus Sage', 'Mind over matter', 25, 3, 3, 3, 10, 4),
('Vitality Guardian', 'Peak physical condition', 30, 5, 5, 5, 5, 10);

-- Insert default challenges
INSERT INTO challenges (title, description, type, xp_reward, target_value, category) VALUES
('Daily Water Goal', 'Drink 2000ml of water today', 'daily', 50, 2000, 'water'),
('Healthy Breakfast', 'Log a healthy breakfast meal', 'daily', 30, 1, 'diet'),
('Balanced Lunch', 'Log a balanced lunch meal', 'daily', 30, 1, 'diet'),
('Light Dinner', 'Log a light dinner meal', 'daily', 30, 1, 'diet'),
('Weekly Exercise', 'Complete 3 exercise sessions this week', 'weekly', 150, 3, 'exercise'),
('Calorie Control', 'Stay within daily calorie goal for 5 days', 'weekly', 200, 5, 'diet');

-- Insert default rewards
INSERT INTO rewards (name, description, type, cost, rarity) VALUES
('XP Boost Potion', 'Doubles XP gain for 24 hours', 'potion', 100, 'rare'),
('Golden Skin', 'Shiny golden avatar skin', 'skin', 500, 'epic'),
('Mystery Loot Box', 'Contains random rewards', 'loot_box', 200, 'common'),
('Strength Boost', 'Permanently increases strength by 1', 'item', 300, 'rare'),
('Energy Drink', 'Restores energy for challenges', 'item', 50, 'common');

SELECT 'Gamification and diet tables created successfully!' as message;
