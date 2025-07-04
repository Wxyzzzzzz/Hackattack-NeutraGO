# NeutraGO - Carbon Footprint Tracking App

A Flutter mobile application that helps users track their carbon footprint by monitoring transportation habits and encouraging eco-friendly choices.

## 🌱 Overview

NeutraGO automatically detects your transportation modes (walking, car, bus, etc.) and calculates your daily CO₂ emissions. The app provides smart trip planning, rewards for green choices, and leaderboards to compete with other users.

## ✨ Key Features

- **Automatic Trip Detection**: Tracks your movement and identifies transportation modes
- **Carbon Footprint Calculator**: Real-time CO₂ emission calculations
- **Smart Trip Planning**: Google Maps integration with eco-friendly route suggestions
- **Rewards System**: Earn points for sustainable transportation choices
- **Leaderboards**: Compete with other users on carbon savings
- **Trip History**: View past trips and emission data

## 🚀 How to Run

### Prerequisites
- Flutter SDK (3.1.5+)
- Android Studio or VS Code
- Android device/emulator

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Wxyzzzzzz/Hackattack-NeutraGO.git
   cd HackAttack-NeutraGO
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Required)
   - Create a Firebase project
   - Add `google-services.json` to `android/app/`
   - Enable Authentication and Firestore

4. **Configure Google Maps** (Required)
   - Get Google Maps API key
   - Add to your configuration

5. **Run the app**
   ```bash
   flutter run
   ```

### Route Suggestion Model
   The source code for route suggestion model can be obtained from the Github link below:
   https://github.com/Wxyzzzzzz/Hackattack-NeutraGO.git
   
---

Built with Flutter, Firebase, and Google Maps Platform.
