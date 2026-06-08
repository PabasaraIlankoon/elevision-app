"""
Elevision Alert Testing Script for Raspberry Pi
Use this to test Firebase connectivity and push notifications
BEFORE integrating with your YOLO detection script
"""

import firebase_admin
from firebase_admin import credentials, firestore, messaging, storage
import time
import datetime
import uuid
import sys

# ===== CONFIGURATION =====
# Get these values from your Firebase Console
FIREBASE_KEY_PATH = '/home/pi/firebase-key.json'
STORAGE_BUCKET = 'elevision-606a9.appspot.com'  # Replace with your bucket
PROJECT_ID = 'elevision-606a9'  # Replace with your project ID

# ===== INITIALIZE FIREBASE =====
try:
    cred = credentials.Certificate(FIREBASE_KEY_PATH)
    firebase_admin.initialize_app(cred, {
        'storageBucket': STORAGE_BUCKET
    })
    db = firestore.client()
    bucket = storage.bucket()
    print("✓ Firebase initialized successfully")
except Exception as e:
    print(f"✗ Firebase initialization failed: {e}")
    print(f"  Make sure {FIREBASE_KEY_PATH} exists")
    sys.exit(1)

# ===== FUNCTIONS =====

def get_fcm_token():
    """Retrieve the device FCM token from Firestore"""
    try:
        doc = db.collection('system').document('device_tokens').get()
        if doc.exists:
            token = doc.to_dict().get('fcmToken')
            if token:
                return token
    except Exception as e:
        print(f"✗ Error reading FCM token: {e}")
    return None

def send_test_alert(fcm_token, confidence=0.92):
    """
    Send a test alert to Firestore and FCM
    confidence: detection confidence (0.0-1.0)
    """
    if not fcm_token:
        print("✗ No FCM token available")
        print("  Make sure to open the app and check for FCM token in logs")
        return False

    alert_id = str(uuid.uuid4())
    now = datetime.datetime.now()
    timestamp_ms = int(now.timestamp() * 1000)
    time_str = now.strftime("%I:%M %p")

    print(f"\n--- Sending Test Alert ---")
    print(f"Alert ID: {alert_id}")
    print(f"Timestamp: {time_str}")
    print(f"Confidence: {confidence*100:.0f}%")

    try:
        # 1. Create a test image (placeholder - in real system this would be from camera)
        test_image_path = '/tmp/test_alert.jpg'
        # For testing, we'll use a dummy image
        # In production, this would be your camera frame
        with open(test_image_path, 'rb') as f:
            pass  # File exists for upload

        # 2. Upload placeholder image to Firebase Storage
        print(f"\n1. Uploading image to Storage...")
        blob = bucket.blob(f'alerts/{now.strftime("%Y-%m-%d")}/{alert_id}.jpg')
        
        # For testing without a real image, create a minimal JPEG
        import struct
        minimal_jpeg = b'\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00\xff\xdb\x00C\x00\x08\x06\x06\x07\x06\x05\x08\x07\x07\x07\t\t\x08\n\x0c\x14\r\x0c\x0b\x0b\x0c\x19\x12\x13\x0f\x14\x1d\x1a\x1f\x1e\x1d\x1a\x1c\x1c $.\' ",#\x1c\x1c(7),01444\x1f\'9=82<.342\xff\xd9'
        blob.upload_from_string(minimal_jpeg, content_type='image/jpeg')
        blob.make_public()
        image_url = blob.public_url
        print(f"   ✓ Image uploaded: {image_url[:50]}...")

        # 3. Write alert to Firestore
        print(f"\n2. Writing alert to Firestore...")
        db.collection('alerts').document(alert_id).set({
            'timestampMs': timestamp_ms,
            'imageUrl': image_url,
            'confidence': float(confidence),
            'deviceId': 'shop-main',
            'status': 'new',
        })
        print(f"   ✓ Alert written to Firestore")

        # 4. Send push notification via FCM
        print(f"\n3. Sending push notification...")
        message = messaging.Message(
            notification=messaging.Notification(
                title='🚨 Intruder Alert!',
                body=f'Motion detected at your shop at {time_str}',
            ),
            android=messaging.AndroidConfig(
                priority='high',
                notification=messaging.AndroidNotification(
                    channel_id='security_alerts',
                    sound='default',
                    title='🚨 Intruder Alert!',
                    body=f'Motion detected at your shop at {time_str}',
                ),
            ),
            token=fcm_token,
        )
        response = messaging.send(message)
        print(f"   ✓ Notification sent! Message ID: {response}")

        print(f"\n✓ Test alert sent successfully!")
        print(f"  Check your phone for notification in 1-2 seconds")
        return True

    except Exception as e:
        print(f"\n✗ Error sending alert: {e}")
        import traceback
        traceback.print_exc()
        return False

def send_real_alert(image_path, confidence, fcm_token):
    """
    Send a real alert with actual image from camera
    Call this from your YOLO detection script
    """
    if not fcm_token:
        print("No FCM token - alerts won't be sent to phone")
        return False

    alert_id = str(uuid.uuid4())
    now = datetime.datetime.now()
    timestamp_ms = int(now.timestamp() * 1000)
    time_str = now.strftime("%I:%M %p")

    try:
        # Upload image
        blob = bucket.blob(f'alerts/{now.strftime("%Y-%m-%d")}/{alert_id}.jpg')
        blob.upload_from_filename(image_path, content_type='image/jpeg')
        blob.make_public()
        image_url = blob.public_url

        # Write to Firestore
        db.collection('alerts').document(alert_id).set({
            'timestampMs': timestamp_ms,
            'imageUrl': image_url,
            'confidence': float(confidence),
            'deviceId': 'shop-main',
            'status': 'new',
        })

        # Send notification
        message = messaging.Message(
            notification=messaging.Notification(
                title='🚨 Intruder Alert!',
                body=f'Confidence: {confidence*100:.0f}% at {time_str}',
            ),
            android=messaging.AndroidConfig(
                priority='high',
                notification=messaging.AndroidNotification(
                    channel_id='security_alerts',
                    sound='default',
                ),
            ),
            token=fcm_token,
        )
        messaging.send(message)
        print(f'Alert sent: {image_path} (Confidence: {confidence*100:.0f}%)')
        return True

    except Exception as e:
        print(f'Failed to send alert: {e}')
        return False

# ===== MAIN =====
if __name__ == '__main__':
    print("=" * 50)
    print("Elevision Test Alert System")
    print("=" * 50)

    # Get FCM token
    print("\nStep 1: Retrieving FCM token from Firestore...")
    fcm_token = get_fcm_token()

    if fcm_token:
        print(f"✓ FCM Token found: {fcm_token[:30]}...")
    else:
        print("\n⚠ NO FCM TOKEN FOUND!")
        print("\nYou need to:")
        print("1. Open the Elevision app on your phone")
        print("2. Login successfully")
        print("3. Look in the console for: === FCM Token: ... ===")
        print("4. This token must be saved to Firestore!")
        print("\nAfter that, run this script again.")
        sys.exit(1)

    # Send test alert
    print("\nStep 2: Sending test alert...")
    success = send_test_alert(fcm_token, confidence=0.95)

    if success:
        print("\n" + "=" * 50)
        print("SUCCESS! Your system is working!")
        print("=" * 50)
        print("\nNext steps:")
        print("1. Check your phone for the alert notification")
        print("2. Open the app - alert should appear in history")
        print("3. Integration with YOLO is ready!")
    else:
        print("\n" + "=" * 50)
        print("FAILED - Check errors above")
        print("=" * 50)
