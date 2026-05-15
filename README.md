# OculaCare

OculaCare is a Flutter app for eye health. It uses the phone camera and a CNN model to detect cataracts and other conditions, then maps each result to a guided therapy program. It also includes vision training games built with the Flame engine, a clinic finder on Google Maps, and a calendar for tracking therapy adherence.

> 🏆 1st Place — COMSATS Industrial Expo 2024
> 🥈 2nd Place — Securiti.ai National AI Security Challenge
> Validated with practicing ophthalmologists

---

## What It Does

Routine eye care is expensive and hard to access. OculaCare runs on any Android or iOS device. A user takes a photo, gets a detection result, and can follow a therapy program from there — no appointment needed.

---

## Features

### Disease Detection
- Camera-based cataract detection using on-device ML (Google ML Kit) and a custom CNN
- Covers cataracts, crossed eyes (strabismus), pterygium, and bulgy eyes
- Adaptive symptom questionnaire — follow-up questions change based on previous answers

### Therapy Programs
Each condition maps to a therapy protocol with step-by-step visual guides and audio:

| Condition | Exercises |
|-----------|-----------|
| General eye strain | Palming, eye rolling, blinking, distance gazing, figure-eight focus, focus shifting |
| Crossed eyes | Pencil push-ups, barrel card, Brock string, eye patch, mirror eye, peripheral awareness |
| Bulgy eyes | Squint technique, rotation, directional eye movement |
| Pterygium | Cold compress, eye massage |
| Relaxation | Mind-chest breathing, kaleidoscope focus, yin-yang clarity |

### Vision Training Games
Built with the Flame game engine. These are actual interactive games, not animated GIFs — color recognition, visual tracking, and jumping stripes stimulus training.

### Health Tracking
- Heatmap calendar showing therapy adherence over time
- Progress charts via fl_chart
- Exportable PDF health reports (via `pdf` + `printing` packages)
- Local notifications for therapy reminders

### Clinic Finder
- Google Maps with real-time location
- Geocoding to find nearby ophthalmology clinics

### Voice & Accessibility
- TTS guidance through each exercise
- STT input for symptom reporting
- Audio-guided sessions

### Authentication
- Email/password with Firebase Auth
- Google Sign-In
- Facebook Login

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart SDK ≥3.2.3) |
| State Management | flutter_bloc + BLoC pattern |
| Navigation | go_router |
| ML / Vision | Google ML Kit Face Detection, custom CNN models |
| Games | Flame engine |
| Maps | Google Maps Flutter, Geolocator, Geocoding |
| Auth | Firebase Auth, Google Sign-In, Facebook Auth |
| Animations | Rive, Lottie |
| Charts | fl_chart |
| Notifications | flutter_local_notifications |
| PDF | pdf + printing |
| Voice | speech_to_text, flutter_tts, audioplayers |
| UI Utilities | flutter_screenutil, flutter_svg, shimmer, animate_do |
| Storage | shared_preferences |
| HTTP | Dio, http |

---

## Project Structure

```
lib/
├── config/           # App configuration, theme, router setup
├── data/             # Repositories, data sources, models
├── domain/           # Use cases, entities, interfaces
├── presentation/
│   ├── blocs/        # BLoC state management per feature
│   ├── screens/      # Full screens (auth, home, detection, therapy, games)
│   └── widgets/      # Reusable UI components
└── utils/            # Helpers, constants, extensions

assets/
├── images/           # Therapy exercise illustrations (per condition)
├── svgs/             # Vector UI assets
├── lotties/          # Loading and feedback animations
├── audio/            # Guided exercise audio
├── pdfs/             # Static reference documents
└── map_styles/       # Custom Google Maps JSON styles
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥3.2.3
- Dart SDK ≥3.2.3
- Android Studio / Xcode for device emulation
- A Firebase project with Auth enabled
- Google Maps API key
- Facebook Developer App ID (for Facebook login)

### Installation

```bash
git clone https://github.com/BilalKhanT/OculaCare.git
cd OculaCare
flutter pub get
```

### Environment Setup

Create a `.env` file in the project root (already referenced in `pubspec.yaml` assets):

```env
GOOGLE_MAPS_API_KEY=your_key_here
BASE_URL=your_backend_url
```

Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console into the respective platform directories.

### Run

```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | Structure present |
| Desktop (Linux/macOS/Windows) | Structure present |

---

## Awards

Final-year capstone for a BS Software Engineering degree at COMSATS University Islamabad (2025). Reviewed by practicing ophthalmologists during development.

- 1st Place — COMSATS Industrial Expo 2024
- 2nd Place — Securiti.ai National AI Security Challenge

---

## Contributors

- [Awais ur Rehman](https://github.com/awaisjarral37)
- [Bilal Khan](https://github.com/BilalKhanT)

---

## License

Academic and demonstration use. Contact contributors for anything else.
