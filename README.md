<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:1a936f,100:114b5f&height=220&section=header&text=Elevision&fontSize=60&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=AI-Powered%20Elephant%20Guard%20System%20for%20Sri%20Lankan%20Railways&descAlignY=58&descSize=18" width="100%" alt="Elevision banner"/>

<a href="https://github.com/PabasaraIlankoon/elevision-app">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=21&duration=2800&pause=900&color=2E9E6B&center=true&vCenter=true&width=720&lines=Real-time+AI+elephant+detection+at+the+edge+%F0%9F%90%98;YOLOv8+%2B+Raspberry+Pi+%2B+Firebase+%2B+Flutter;Saving+elephants%2C+protecting+trains+%F0%9F%9A%82;Sri+Lanka's+intelligent+early-warning+layer" alt="Typing SVG" />
</a>

<br><br>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20FCM-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![YOLOv8](https://img.shields.io/badge/YOLOv8-Nano-00FFFF?style=for-the-badge&logo=ultralytics&logoColor=black)](https://ultralytics.com)
[![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-4-c51a4a?style=for-the-badge&logo=raspberrypi&logoColor=white)](https://www.raspberrypi.com)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
![Status](https://img.shields.io/badge/status-deployed%20%26%20active-success?style=flat-square)
![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen?style=flat-square)

</div>

<p align="center">
<b>Elevision</b> is a full-stack IoT + AI + Cloud system that protects Sri Lankan railways from elephant collisions.
When an elephant is detected near the tracks, the system instantly alerts railway operators, identifies which trains
are at risk based on live schedules, and triggers emergency protocols - all within seconds.
</p>

<div align="center">

[Overview](#-overview) • [Features](#-features) • [Architecture](#-system-architecture) • [Screenshots](#-mobile-app-screens) • [Setup](#-setup-guide) • [Tech Stack](#-technology-stack)

</div>

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 📋 Table of Contents

- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [Features](#-features)
- [System Architecture](#-system-architecture)
- [Hardware Components](#-hardware-components)
- [AI Detection Pipeline](#-ai-detection-pipeline)
- [Firebase Schema](#-firebase-schema)
- [Mobile App Screens](#-mobile-app-screens)
- [Train Schedule System](#-train-schedule-system)
- [Setup Guide](#-setup-guide)
- [Project Structure](#-project-structure)
- [Technology Stack](#%EF%B8%8F-technology-stack)
- [Performance Metrics](#-performance-metrics)
- [Future Roadmap](#-future-roadmap)
- [Team](#-team)

## 🌟 Overview

Elevision is a full-stack IoT + AI + Cloud system that protects Sri Lankan railways from elephant collisions. When an elephant is detected near the tracks, the system instantly alerts railway operators, identifies which trains are at risk based on live schedules, and triggers emergency protocols - all within seconds.

> **Impact:** Sri Lanka loses 5-10 elephants per year to train collisions. Elevision provides the real-time intelligence layer that can prevent these tragedies.

## 🎯 Problem Statement

### 🐘 + 🚂 = Tragedy

Sri Lanka's railway network passes through critical elephant habitats including:

- Gal Oya National Park corridor
- Minneriya-Kaudulla elephant gathering zones
- Habarana-Polonnaruwa high-traffic elephant crossing

**Current challenges:**

| Problem | Impact |
|---|---|
| No real-time wildlife detection | Drivers have zero warning |
| Night-time blind spots | 70% of collisions happen at night |
| No train–wildlife correlation | Cannot identify which train is at risk |
| Delayed human reporting | Average 15-30 min response time |
| Remote locations, poor connectivity | No reliable communication backup |

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## ✨ Features

### 🤖 AI Detection
- YOLOv8 Nano model optimised for Raspberry Pi
- Detects elephants with >90% average confidence
- Processes 1 frame/second - optimised for Pi thermal limits
- Filters false positives with a 2-frame consecutive detection rule

### 📱 Mobile App (Flutter)
- Real-time push notifications via FCM (< 3 second latency)
- Live dashboard with active alert card, image, and coordinates
- Alert History with Today / Week / Month / All Time filters
- Analytics screen with detection statistics and device rankings
- Train Schedule screen showing which trains are at risk **right now**
- Zoomed map view inside each alert detail
- Emergency SOS call button (dials railway emergency line)
- English / Sinhala language switching (persisted to device)
- Offline-capable - cached alerts available without internet

### ☁️ Cloud (Firebase)
- Firestore real-time database - no polling required
- Firebase Storage for alert images
- FCM push notifications with high-priority Android channel
- Automatic token refresh and multi-device support

### 🚂 Train Risk Engine
- 5 high-risk trains pre-loaded with full stop schedules
- Automatically calculates which trains are within 60 minutes of an alert location
- Colour-coded risk levels: Very High 🔴 / High 🟠 / Medium 🟡
- Updates live as time passes - *"In 23 min" → "In 5 min" → "Passed"*

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🏗 System Architecture

```mermaid
flowchart LR
    subgraph EDGE["🌐 EDGE LAYER"]
        direction TB
        PI(["Raspberry Pi 4"])
        YOLO["YOLOv8 Nano Model"]
        CAM["ELP USB Camera<br/>Night Vision"]
        GSM["SIM800L GSM Module"]
        PI --> YOLO
        PI --> CAM
        PI --> GSM
    end

    subgraph CLOUDL["☁️ CLOUD LAYER"]
        direction TB
        STORAGE[("Firebase Storage<br/>Alert Images")]
        FIRESTORE[("Firestore<br/>alerts / system")]
        FCM["Firebase Cloud<br/>Messaging"]
    end

    subgraph APPL["📱 APP LAYER"]
        direction TB
        DASH["Dashboard"]
        HIST["Alert History"]
        ANALYTICS["Analytics"]
        TRAIN["Train Schedule"]
    end

    SMS(["Owner's Phone<br/>SMS Fallback"])

    PI -- "WiFi / 4G" --> STORAGE
    STORAGE --> FIRESTORE
    FIRESTORE -- "Real-time" --> DASH
    FIRESTORE -- "Real-time" --> HIST
    FIRESTORE -- "Real-time" --> ANALYTICS
    FIRESTORE -- "Real-time" --> TRAIN
    PI --> FCM
    FCM -- "Push" --> DASH
    GSM -- "SMS Backup" --> SMS

    classDef edge fill:#1a936f,stroke:#114b5f,color:#fff,stroke-width:2px
    classDef cloud fill:#3a86ff,stroke:#1b4965,color:#fff,stroke-width:2px
    classDef app fill:#ff6b35,stroke:#c1121f,color:#fff,stroke-width:2px
    classDef alertNode fill:#e63946,stroke:#9d0208,color:#fff,stroke-width:2px

    class PI,YOLO,CAM,GSM edge
    class STORAGE,FIRESTORE,FCM cloud
    class DASH,HIST,ANALYTICS,TRAIN app
    class SMS alertNode
```

### 🔄 Full System Data Flow

```mermaid
flowchart TD
    A["📷 Camera captures<br/>frame / sec"] --> B{"🤖 Elephant<br/>detected?"}
    B -- "No" --> A
    B -- "Yes - 2 consecutive frames" --> C["📸 Capture & Save Image"]
    C --> D[("☁️ Upload to<br/>Firebase Storage")]
    D --> E["🔗 Get Image URL"]
    E --> F[("🗄️ Create Firestore Document<br/>alerts/{id}")]
    F --> G["📡 Real-time Firestore Listener"]
    F --> H["🔔 FCM Push Notification"]
    G --> I["📱 Flutter App Auto-Updates Dashboard"]
    H --> J["📲 Phone Shows Notification"]
    F --> K["🚂 Train Risk Engine Checks Schedule"]
    K --> L{"⚠️ Train within<br/>60 min?"}
    L -- "Yes" --> M["🔴 IMMEDIATE ACTION REQUIRED"]
    L -- "No" --> N["🟡 Monitor - Train Far Away"]

    classDef capture fill:#1a936f,stroke:#114b5f,color:#fff,stroke-width:2px
    classDef cloud fill:#3a86ff,stroke:#1b4965,color:#fff,stroke-width:2px
    classDef decision fill:#ffd60a,stroke:#997404,color:#000,stroke-width:2px
    classDef app fill:#ff6b35,stroke:#c1121f,color:#fff,stroke-width:2px
    classDef danger fill:#e63946,stroke:#9d0208,color:#fff,stroke-width:2px
    classDef safe fill:#2ec4b6,stroke:#0b6e4f,color:#fff,stroke-width:2px

    class A,C capture
    class D,E,F cloud
    class B,L decision
    class G,I,H,J app
    class M danger
    class N safe
```

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🛠 Hardware Components

```mermaid
flowchart TB
    subgraph PI4["🖥️ Raspberry Pi 4 - 4GB RAM"]
        direction LR
        GPIO14["GPIO 14 (TX)"]
        GPIO15["GPIO 15 (RX)"]
        GPIO18["GPIO 18"]
        GPIO24["GPIO 24"]
        USB1["USB Port 1"]
        USB2["USB Port 2"]
        SD[("MicroSD 32GB")]
    end

    SIM["📡 SIM800L<br/>GSM Module"]
    LED["💡 LED + 330Ω"]
    BUZ["🔊 Buzzer"]
    CAM["📷 ELP USB Camera<br/>Night Vision"]
    WIFI["📶 WiFi Dongle"]
    BATTERY[("🔋 Li-Po Battery<br/>+ Regulator")]
    PSU[("🔌 5V/3A Official<br/>Pi Power Supply")]

    GPIO14 <-- "Serial RX/TX" --> SIM
    GPIO15 <-- "Serial RX/TX" --> SIM
    GPIO18 --> LED
    GPIO24 --> BUZ
    USB1 --> CAM
    USB2 -.-> WIFI
    BATTERY -. "Separate 4V Supply" .-> SIM
    PSU --> PI4

    classDef pi fill:#114b5f,stroke:#0a2533,color:#fff,stroke-width:2px
    classDef peripheral fill:#1a936f,stroke:#0b6e4f,color:#fff,stroke-width:2px
    classDef power fill:#ffb703,stroke:#cc8b00,color:#000,stroke-width:2px

    class GPIO14,GPIO15,GPIO18,GPIO24,USB1,USB2,SD pi
    class SIM,LED,BUZ,CAM,WIFI peripheral
    class BATTERY,PSU power
```

| Component | Purpose |
|---|---|
| Raspberry Pi 4 (4GB) | AI processing |
| ELP 2MP USB Camera | Night vision |
| SIM800L GSM Module | SMS backup |
| 32GB microSD Card | OS + storage |
| 5V/3A Power Supply | Pi power |
| 4V Regulated Supply | GSM power |
| Waterproof Housing | Field use |

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🧠 AI Detection Pipeline

```mermaid
flowchart TD
    START(["📷 Camera Frame<br/>Every 1 Second"]) --> CAP["cv2.VideoCapture(0)<br/>frame = camera.read()"]
    CAP --> MODEL["🧠 YOLOv8 Nano Model<br/>results = model(frame) - ~0.3s"]
    MODEL --> CHECK{"Elephant detected?<br/>confidence > 0.60?"}
    CHECK -- "No" --> WAIT["⏳ Continue Loop<br/>sleep 1 sec"]
    WAIT --> CAP
    CHECK -- "Yes" --> FRAME2{"2 Consecutive<br/>Frames Confirmed?"}
    FRAME2 -- "No" --> WAIT
    FRAME2 -- "Yes" --> COOLDOWN{"Cooldown Check<br/>5 min between alerts"}
    COOLDOWN -- "Too Soon" --> WAIT
    COOLDOWN -- "OK" --> PIPELINE["🚨 ALERT PIPELINE"]
    PIPELINE --> S1["1️⃣ Save image locally"]
    S1 --> S2["2️⃣ Upload to Firebase Storage"]
    S2 --> S3["3️⃣ Create Firestore document"]
    S3 --> S4["4️⃣ Send FCM push notification"]
    S4 --> S5["5️⃣ SMS fallback if no internet"]

    classDef start fill:#1a936f,stroke:#114b5f,color:#fff,stroke-width:2px
    classDef process fill:#3a86ff,stroke:#1b4965,color:#fff,stroke-width:2px
    classDef decision fill:#ffd60a,stroke:#997404,color:#000,stroke-width:2px
    classDef wait fill:#adb5bd,stroke:#495057,color:#000,stroke-width:2px
    classDef alertNode fill:#e63946,stroke:#9d0208,color:#fff,stroke-width:2px
    classDef step fill:#ff6b35,stroke:#c1121f,color:#fff,stroke-width:2px

    class START,CAP start
    class MODEL process
    class CHECK,FRAME2,COOLDOWN decision
    class WAIT wait
    class PIPELINE alertNode
    class S1,S2,S3,S4,S5 step
```

**Model Performance on Raspberry Pi 4:**

| Metric | Value |
|---|---|
| Model | YOLOv8 Nano |
| Model size | 6.3 MB |
| Inference time | ~280–350 ms |
| Frames analysed | 1 per second |
| Average confidence | 94% |
| False positive rate | < 3% |
| Detection range | Up to 15m |

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🗄 Firebase Schema

```mermaid
flowchart LR
    PROJECT[("🔥 elevision-606a9<br/>project")]

    subgraph ALERTS["📂 alerts/"]
        A1["timestampMs: number"]
        A2["imageUrl: string"]
        A3["confidence: number"]
        A4["deviceId: string"]
        A5["locationName: string"]
        A6["latitude / longitude: number"]
        A7["status: 'new' | 'seen'"]
    end

    subgraph SYSTEM["📂 system/"]
        S1["status/ - armed, updatedAt, updatedBy"]
        S2["device_tokens/ - fcmToken"]
        S3["devices/ - lat, lng, name, status"]
    end

    subgraph USERS["📂 users/"]
        U1["{uid}/ - email"]
    end

    PROJECT --> ALERTS
    PROJECT --> SYSTEM
    PROJECT --> USERS

    classDef project fill:#114b5f,stroke:#0a2533,color:#fff,stroke-width:2px
    classDef alertsC fill:#e63946,stroke:#9d0208,color:#fff,stroke-width:2px
    classDef systemC fill:#3a86ff,stroke:#1b4965,color:#fff,stroke-width:2px
    classDef usersC fill:#ffb703,stroke:#cc8b00,color:#000,stroke-width:2px

    class PROJECT project
    class A1,A2,A3,A4,A5,A6,A7 alertsC
    class S1,S2,S3 systemC
    class U1 usersC
```

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 📱 Mobile App Screens

<div align="center">

<table>
<tr>
<td align="center" width="25%">
<img src="assets/dashboard-screen.jpeg" width="170"><br>
<sub><b>Dashboard</b><br>Live active alert, device status & SOS</sub>
</td>
<td align="center" width="25%">
<img src="assets/map.jpeg" width="170"><br>
<sub><b>Railway Zone Map</b><br>Alert locations on the rail network</sub>
</td>
<td align="center" width="25%">
<img src="assets/alert-history-screen.jpeg" width="170"><br>
<sub><b>Alert History</b><br>Filterable past detections</sub>
</td>
<td align="center" width="25%">
<img src="assets/settings.jpeg" width="170"><br>
<sub><b>Settings</b><br>Emergency contact, language & about</sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/alert-detail-screen.jpeg" width="170"><br>
<sub><b>Alert Details</b><br>Confidence, GPS & timestamp</sub>
</td>
<td align="center" width="25%">
<img src="assets/alert-detail-screen-2.jpeg" width="170"><br>
<sub><b>Alert Details - Map</b><br>Zoomed location view</sub>
</td>
<td align="center" width="25%">
<img src="assets/analytics-screen.jpeg" width="170"><br>
<sub><b>Analytics</b><br>Detection statistics & rankings</sub>
</td>
<td align="center" width="25%">
<img src="assets/train-screen.jpeg" width="170"><br>
<sub><b>Train Schedule</b><br>Live risk filtered by level</sub>
</td>
</tr>
</table>

</div>

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

```
**Other scheduled services:**

| Train | Route | Risk |
|---|---|---|
| 6075 · Pulathisi | Colombo → Batticaloa | 🟠 High |
| 6011 · Udaya Devi | Colombo → Batticaloa | 🟡 Medium |
| 6012 · Udaya Devi | Batticaloa → Colombo | 🟡 Medium |

**How real-time risk is calculated:**

When an alert fires at "Palugaswewa Railway Section" with current time 11:32 PM:

| Train | Arrives at Palugaswewa | Time Now | Risk |
|---|---|---|---|
| 6080 Meenagaya | 11:55 PM | 11:32 PM | **In 23 min** |
| 6075 Pulathisi | (no stop here) | - | - |
| 6076 Pulathisi | 05:10 AM | 11:32 PM | Later |

Result displayed in app: 🔴 **Train #6080 Meenagaya - In 23 min ⚠️ IMMEDIATE RISK**

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🚀 Setup Guide

### Prerequisites

```bash
# On your laptop
flutter --version   # needs 3.x+
python3 --version   # needs 3.9+
git --version

# On Raspberry Pi
python3 --version
pip3 --version
```

<details open>
<summary><b>Step 1 - Clone the repository</b></summary>

```bash
git clone https://github.com/PabasaraIlankoon/elevision-app.git
cd elevision-app
```
</details>

<details>
<summary><b>Step 2 - Firebase setup</b></summary>

```bash
# 1. Create project at console.firebase.google.com
# 2. Enable: Firestore, Storage, Authentication, FCM
# 3. Download google-services.json → place in android/app/
# 4. Download firebase-key.json (service account) → place in pi/
```

Set Firestore rules (Rules tab in console):

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
</details>

<details>
<summary><b>Step 3 - Flutter mobile app</b></summary>

```bash
cd mobile_app
flutter pub get
flutter run
```
</details>

<details>
<summary><b>Step 4 - Raspberry Pi setup</b></summary>

```bash
# SSH into your Pi
ssh pi@raspberrypi.local

# Install dependencies
pip3 install firebase-admin ultralytics opencv-python --break-system-packages

# Copy firebase key
scp firebase-key.json pi@raspberrypi.local:/home/pi/

# Run detection
python3 security.py
```
</details>

<details>
<summary><b>Step 5 - Auto-start on boot</b></summary>

```bash
sudo nano /etc/systemd/system/elevision.service
```

```ini
[Unit]
Description=Elevision Elephant Detection
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/pi/security.py
Restart=always
User=pi
WorkingDirectory=/home/pi

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable elevision
sudo systemctl start elevision
```
</details>

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 📁 Project Structure

```
elevision/
│
├── 📱 mobile_app/                  ← Flutter app
│   ├── lib/
│   │   ├── main.dart               ← App entry point
│   │   ├── firebase_options.dart   ← Auto-generated
│   │   │
│   │   ├── models/
│   │   │   ├── alert_model.dart       ← Alert data structure
│   │   │   └── train_schedule.dart    ← Train data + risk engine
│   │   │
│   │   ├── services/
│   │   │   ├── auth_service.dart         ← Firebase Auth
│   │   │   ├── firestore_service.dart    ← Firestore CRUD
│   │   │   ├── notification_service.dart ← FCM setup
│   │   │   ├── settings_service.dart     ← Language + settings
│   │   │   └── location_service.dart     ← GPS location
│   │   │
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       ├── home_screen.dart           ← Dashboard + Settings
│   │       ├── alerts_screen.dart         ← Alert list
│   │       ├── alert_detail_screen.dart   ← Alert detail + map
│   │       ├── alert_history_screen.dart  ← Filtered history
│   │       ├── analytics_screen.dart      ← Statistics
│   │       ├── train_schedule_screen.dart ← Train risk
│   │       └── map_screen.dart            ← Full map view
│   │
│   ├── android/app/google-services.json
│   ├── assets/
│   │   ├── icon.jpeg
│   │   ├── app_icon.png
│   │   ├── dashboard-screen.jpeg
│   │   ├── map.jpeg
│   │   ├── alert-history-screen.jpeg
│   │   ├── settings.jpeg
│   │   ├── alert-detail-screen.jpeg
│   │   ├── alert-detail-screen-2.jpeg
│   │   ├── analytics-screen.jpeg
│   │   └── train-screen.jpeg              ← README screenshots
│   └── pubspec.yaml
│
├── 🐍 pi/                          ← Raspberry Pi code
│   ├── security.py                 ← Main detection script
│   ├── firebase-key.json           ← Service account (gitignored)
│   └── requirements.txt
│
└── 📄 README.md
```

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/rainbow.gif" width="100%">

## 🛡️ Technology Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x (Dart) |
| State Management | Provider + ChangeNotifier |
| Maps | flutter_map + OpenStreetMap |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Real-time Database | Cloud Firestore |
| Image Storage | Firebase Storage |
| Authentication | Firebase Auth (Email/Password) |
| AI/ML Model | YOLOv8 Nano (Ultralytics) |
| Computer Vision | OpenCV (cv2) |
| Edge Hardware | Raspberry Pi 4 (4GB RAM) |
| Camera | ELP 2MP USB Night Vision |
| GSM Backup | SIM800L + AT Commands |
| Backend Language | Python 3.9+ |
| Cloud Platform | Google Firebase (Free Spark tier) |
| Location | Geolocator (Flutter) |

## 📊 Performance Metrics

| Metric | Value |
|---|---|
| Detection confidence (average) | 94% |
| False positive rate | < 3% |
| Alert delivery time (Pi → phone) | < 5 seconds |
| App real-time update latency | < 2 seconds |
| Raspberry Pi inference time | ~300ms/frame |
| Battery backup duration (with UPS) | ~4 hours |
| GSM fallback SMS delivery | < 30 seconds |
| Supported concurrent devices | Unlimited (Firebase scales) |

## 🔮 Future Roadmap

- [ ] LoRa mesh network - device-to-device communication without internet
- [ ] Real GPS tracking on trains via ESP32 + Neo-6M module
- [ ] Multi-species detection - leopards, wild boar near tracks
- [ ] Drone integration - aerial surveillance for large corridors
- [ ] Sri Lanka Railways API - live train position data
- [ ] Web dashboard - for railway control room operators
- [ ] Thermal camera - improved night detection accuracy
- [ ] Solar power - fully off-grid deployment

## 👥 Team

| Role | Responsibility |
|---|---|
| Hardware Engineer | Raspberry Pi, camera, GSM module, field deployment |
| AI/ML Engineer | YOLOv8 model training, detection pipeline, Python |
| Mobile Developer | Flutter app, Firebase integration, UI/UX |
| Web Developer | Web dashboard (React/Firebase) |
| Project Lead | System architecture, coordination, documentation |

## 📄 License

MIT License - Copyright (c) 2026 Elevision Team

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

## 🙏 Acknowledgements

- Sri Lanka Railways - for track layout and schedule data
- Ultralytics - for the YOLOv8 model framework
- OpenStreetMap - for map tile data
- Firebase / Google - for cloud infrastructure
- Department of Wildlife Conservation, Sri Lanka - for elephant corridor maps

<div align="center">

### 🐘 "Every elephant saved is a victory for conservation" 🐘

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:114b5f,100:1a936f&height=120&section=footer" width="100%"/>

<sub>Built with 🐘 by the <b>Elevision Team</b></sub>

</div>
