#!/usr/bin/env python3
"""
Test script to verify the unlock bug fix:
- User has Charmander as current avatar (evolution worked)
- But unlocked avatars view only shows 1 avatar (Bulbasaur)
- Should show both Bulbasaur + Charmander after fix
"""
import requests
import json

BASE_URL = "http://localhost:8080"

def test_unlock_bug_fix():
    print("🐛 Testing Avatar Unlock Bug Fix")
    print("=" * 60)
    print("Problem: Avatar evolution works but unlocked view is wrong")
    print()
    
    # Test data
    test_user = {
        "username": "testunlock_bug",
        "email": "testunlock@example.com", 
        "password": "password123"
    }
    
    # Step 1: Register user
    print("1. Creating test user...")
    try:
        register_response = requests.post(f"{BASE_URL}/register", json=test_user)
        if register_response.status_code == 201:
            print("✅ User created successfully")
            token = register_response.json().get('token')
            headers = {'Authorization': f'Bearer {token}'}
        else:
            print(f"❌ Failed: {register_response.text}")
            return False
    except Exception as e:
        print(f"❌ Registration error: {e}")
        return False
    
    # Step 2: Get initial stats
    print("\n2. Getting initial user stats...")
    try:
        stats_response = requests.get(f"{BASE_URL}/gamification/stats", headers=headers)
        if stats_response.status_code == 200:
            stats = stats_response.json()
            print(f"✅ Level: {stats.get('level', 'Unknown')}")
            print(f"✅ Current Avatar ID: {stats.get('avatar_stage_id', 'Unknown')}")
            print(f"✅ Stats: STR={stats.get('strength')}, AGI={stats.get('agility')}, END={stats.get('endurance')}, FOC={stats.get('focus')}, VIT={stats.get('vitality')}")
        else:
            print(f"❌ Failed to get stats: {stats_response.text}")
            return False
    except Exception as e:
        print(f"❌ Stats error: {e}")
        return False
    
    # Step 3: Check initial unlocked avatars
    print("\n3. Checking initially unlocked avatars...")
    try:
        avatars_response = requests.get(f"{BASE_URL}/gamification/unlocked-avatars", headers=headers)
        if avatars_response.status_code == 200:
            data = avatars_response.json()
            unlocked = data.get('unlocked_avatars', [])
            current_id = data.get('current_avatar_id')
            
            print(f"✅ Current Avatar ID: {current_id}")
            print(f"✅ Total Unlocked: {len(unlocked)}")
            print("✅ Unlocked Avatars:")
            for avatar in unlocked:
                status = "🔥 CURRENT" if avatar.get('id') == current_id else ""
                print(f"   - {avatar.get('name')} (ID: {avatar.get('id')}, Level {avatar.get('required_level')}) {status}")
                
        else:
            print(f"❌ Failed to get unlocked avatars: {avatars_response.text}")
            return False
    except Exception as e:
        print(f"❌ Unlocked avatars error: {e}")
        return False
    
    # Step 4: Force refresh to trigger the fix
    print("\n4. Triggering avatar unlock refresh (this should fix the bug)...")
    try:
        refresh_response = requests.post(f"{BASE_URL}/gamification/refresh-avatar-unlocks", headers=headers)
        if refresh_response.status_code == 200:
            refresh_data = refresh_response.json()
            print("✅ Refresh completed successfully")
            
            # Show updated stats
            updated_stats = refresh_data.get('user_stats', {})
            print(f"✅ Updated Level: {updated_stats.get('level')}")
            print(f"✅ Updated Avatar ID: {updated_stats.get('avatar_stage_id')}")
            print(f"✅ Total Unlocked After Fix: {refresh_data.get('total_unlocked')}")
            
        else:
            print(f"❌ Refresh failed: {refresh_response.text}")
            return False
    except Exception as e:
        print(f"❌ Refresh error: {e}")
        return False
    
    # Step 5: Verify fix - check unlocked avatars again
    print("\n5. Verifying the fix - checking unlocked avatars again...")
    try:
        final_response = requests.get(f"{BASE_URL}/gamification/unlocked-avatars", headers=headers)
        if final_response.status_code == 200:
            data = final_response.json()
            unlocked = data.get('unlocked_avatars', [])
            current_id = data.get('current_avatar_id')
            
            print(f"✅ Final Current Avatar ID: {current_id}")
            print(f"✅ Final Total Unlocked: {len(unlocked)}")
            print("✅ Final Unlocked Avatars:")
            for avatar in unlocked:
                status = "🔥 CURRENT" if avatar.get('id') == current_id else ""
                print(f"   - {avatar.get('name')} (ID: {avatar.get('id')}, Level {avatar.get('required_level')}) {status}")
            
            # Check if bug is fixed
            if len(unlocked) >= 2:
                print("\n🎉 BUG FIXED! User now has multiple unlocked avatars!")
                return True
            else:
                print(f"\n⚠️  Still only {len(unlocked)} avatar unlocked. Bug might persist.")
                return False
                
        else:
            print(f"❌ Final check failed: {final_response.text}")
            return False
    except Exception as e:
        print(f"❌ Final check error: {e}")
        return False

if __name__ == "__main__":
    try:
        success = test_unlock_bug_fix()
        if success:
            print("\n✅ TEST PASSED: Avatar unlock bug has been fixed!")
        else:
            print("\n❌ TEST FAILED: Bug still exists or other issues")
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to backend. Please start the server first.")
    except Exception as e:
        print(f"❌ Test error: {e}")