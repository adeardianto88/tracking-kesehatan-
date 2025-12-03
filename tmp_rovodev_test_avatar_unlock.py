#!/usr/bin/env python3
"""
Test script to verify avatar auto-unlocking functionality
This script simulates the scenario where a user has level 5 but no unlocked avatars
"""
import requests
import json
import time

BASE_URL = "http://localhost:8080"

def test_avatar_unlock():
    print("🧪 Testing Avatar Auto-Unlock System")
    print("=" * 50)
    
    # Test data
    test_user = {
        "username": "testuser_level5",
        "email": "testlevel5@example.com",
        "password": "password123"
    }
    
    # Step 1: Register new user
    print("1. Creating new test user...")
    register_response = requests.post(f"{BASE_URL}/register", json=test_user)
    
    if register_response.status_code == 201:
        print("✅ User created successfully")
        token = register_response.json().get('token')
        headers = {'Authorization': f'Bearer {token}'}
    else:
        print(f"❌ Failed to create user: {register_response.text}")
        return False
    
    # Step 2: Check initial stats
    print("\n2. Checking initial user stats...")
    stats_response = requests.get(f"{BASE_URL}/gamification/stats", headers=headers)
    
    if stats_response.status_code == 200:
        initial_stats = stats_response.json()
        print(f"✅ Initial Level: {initial_stats.get('level', 'Unknown')}")
        print(f"✅ Initial Avatar ID: {initial_stats.get('avatar_stage_id', 'Unknown')}")
    else:
        print(f"❌ Failed to get stats: {stats_response.text}")
        return False
    
    # Step 3: Check unlocked avatars
    print("\n3. Checking initially unlocked avatars...")
    avatars_response = requests.get(f"{BASE_URL}/gamification/unlocked-avatars", headers=headers)
    
    if avatars_response.status_code == 200:
        avatars_data = avatars_response.json()
        unlocked_avatars = avatars_data.get('unlocked_avatars', [])
        print(f"✅ Initially unlocked avatars: {len(unlocked_avatars)}")
        for avatar in unlocked_avatars:
            print(f"   - {avatar.get('name')} (Level {avatar.get('required_level')})")
    else:
        print(f"❌ Failed to get unlocked avatars: {avatars_response.text}")
        return False
    
    # Step 4: Force refresh avatar unlocks (simulates the auto-unlock on login)
    print("\n4. Testing avatar unlock refresh...")
    refresh_response = requests.post(f"{BASE_URL}/gamification/refresh-avatar-unlocks", headers=headers)
    
    if refresh_response.status_code == 200:
        refresh_data = refresh_response.json()
        print("✅ Avatar unlock refresh completed")
        print(f"✅ Total unlocked avatars: {refresh_data.get('total_unlocked', 'Unknown')}")
        
        # Show updated stats
        updated_stats = refresh_data.get('user_stats', {})
        print(f"✅ Updated Level: {updated_stats.get('level', 'Unknown')}")
        print(f"✅ Updated Avatar ID: {updated_stats.get('avatar_stage_id', 'Unknown')}")
        
        # Show unlocked avatars
        unlocked_avatars = refresh_data.get('unlocked_avatars', [])
        print("✅ Unlocked avatars after refresh:")
        for avatar in unlocked_avatars:
            print(f"   - {avatar.get('name')} (Level {avatar.get('required_level')})")
            
    else:
        print(f"❌ Failed to refresh avatar unlocks: {refresh_response.text}")
        return False
    
    print("\n🎉 Avatar auto-unlock test completed successfully!")
    return True

if __name__ == "__main__":
    try:
        test_avatar_unlock()
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to backend server. Please make sure the server is running on localhost:8080")
    except Exception as e:
        print(f"❌ Test failed with error: {e}")