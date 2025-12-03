-- This script will drop the old table and let GORM recreate it correctly.
USE db_auth_robotic;

-- Drop the old table to avoid any schema conflicts
DROP TABLE IF EXISTS weight_records;

SELECT 'Table weight_records dropped. Golang AutoMigrate will recreate it on next run.' as message;
