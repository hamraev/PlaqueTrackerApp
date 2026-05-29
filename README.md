# PlaqueTracker iOS App

A kid-friendly, gamified iPhone app that connects to PlaqueTracker Arduino device over BLE (primary) and Wi-Fi (optional). Features interactive brushing maps, real-time plaque detection, achievements, and educational content.

## 📱 Features

### Core Features ✅
- **Dashboard**: Smile Score tracking, daily streaks, XP progression
- **Brush Map**: Interactive tooth zone visualization with brushing tips
- **Gamification**: Streak system, XP points, achievement tracking
- **Live Scanning**: Real-time plaque detection via device
- **Learning Center**: Educational dental hygiene content
- **Rewards System**: Badges, trophies, and achievements
- **Photo Gallery**: Before/after comparison and progress tracking

### Current Implementation Status
- ✅ Dashboard with gamification basics (Smile Score, Streaks, XP)
- ✅ Interactive Brush Map with zone selection
- ✅ Tab-based navigation (Home, Scan, Brush Map, Learn, Rewards)
- ⏳ Design System (IN PROGRESS)
- ⏳ Learn Section with educational content
- ⏳ Rewards & Achievements system
- ⏳ Live Scan with camera integration
- ⏳ Photo gallery & before/after comparison

## 🎨 Design System

The app uses a comprehensive design system built on SwiftUI for consistency and maintainability.

### Color Palette
- **Primary**: Vibrant blue (#007AFF) - for main actions and highlights
- **Secondary**: Fresh green (#34C759) - for achievements and progress
- **Accent**: Warm orange (#FF9500) - for rewards and special elements
- **Success**: Light green (#5AC8FA) - for positive feedback
- **Warning**: System red (#FF3B30) - for attention-needed areas
- **Neutrals**: Gray scales for text, backgrounds, and dividers

### Typography
- **Display**: 32pt, Bold, Rounded - screen titles
- **Headline**: 18pt, Semibold - section headers
- **Body**: 15pt, Regular - body text
- **Caption**: 12pt, Regular - supplementary text

### Components
- **Cards**: Rounded corners (20pt radius), subtle shadows, padding consistency
- **Buttons**: Prominent (filled), Secondary (bordered), Text-only
- **Badges**: Achievement stickers, streak indicators
- **Progress Indicators**: Circular progress, bars, animations

### Spacing System
- Tight: 4pt (minimal spacing)
- Default: 8pt (standard gaps)
- Medium: 16pt (section spacing)
- Large: 24pt (major spacing)
- Extra Large: 32pt (full screen margins)

## 🏗️ Project Structure

```
PlaqueTracker/
├── PlaqueTrackerApp.swift          # App entry point
├── ContentView.swift               # Root view router
├── RootTabView.swift               # Tab navigation
├── Models/
│   └── TelemetryPayload.swift      # Device data model
├── Device/
│   ├── DeviceManager.swift         # BLE/WiFi communication
│   └── MockDeviceManager.swift     # Testing mock
├── UI/
│   ├── Shared/
│   │   ├── AppColors.swift         # Color palette (DESIGN SYSTEM)
│   │   ├── Theme.swift             # Typography & styling (DESIGN SYSTEM)
│   │   ├── ReusableCards.swift     # Common components (DESIGN SYSTEM)
│   │   └── Extensions/             # SwiftUI extensions
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   └── DashboardViewModel.swift
│   ├── Scan/
│   │   ├── LiveScanView.swift
│   │   └── LiveScanViewModel.swift
│   ├── BrushMap/
│   │   ├── BrushMapView.swift
│   │   ├── BrushMapViewModel.swift
│   │   └── ToothMapShapes.swift
│   ├── Learn/
│   │   └── LearnView.swift
│   ├── Rewards/
│   │   └── RewardsView.swift
│   └── Onboarding/
│       └── WelcomeGateView.swift
└── Assets/
    ├── Colors & Images
    └── AppIcon sets
```

## 🚀 Development Roadmap

### Phase 1: Design System Foundation ✅ COMPLETE
- [x] Create color palette (AppColors.swift)
- [x] Define typography system (Theme.swift)
- [x] Build reusable components (ReusableCards.swift)
- [x] Create extensions for common modifiers
- [x] Update Dashboard with design system
- [x] Route ContentView to RootTabView

### Phase 2: Rewards & Achievements
- [ ] Build achievements data model
- [ ] Implement RewardsView with badge display
- [ ] Create badge animation system
- [ ] Add milestone tracking
- [ ] Wire up reward notifications

### Phase 3: Educational Content
- [ ] Populate LearnView sections
- [ ] Add educational illustrations
- [ ] Create content hierarchy
- [ ] Implement reading progress tracking

### Phase 4: Photo Integration
- [ ] Build LiveScanView with camera capture
- [ ] Create photo gallery view
- [ ] Implement before/after comparison
- [ ] Add progress visualization

### Phase 5: Polish & Publishing
- [ ] Animations and micro-interactions
- [ ] Sound effects and haptics
- [ ] Settings and customization
- [ ] Notifications and reminders
- [ ] Dark mode support
- [ ] App Store optimization

## 🛠️ Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **Architecture**: MVVM with Combine
- **Device Communication**: Core Bluetooth (BLE)
- **Data**: UserDefaults / Core Data (for persistence)
- **iOS Target**: iOS 15+

## 🔧 Setup & Installation

### Prerequisites
- Xcode 14+
- iOS 15+ deployment target
- PlaqueTracker Arduino device (for full functionality)

### Getting Started
1. Clone the repository:
   ```bash
   git clone git@github.com:hamraev/PlaqueTrackerApp.git
   cd PlaqueTrackerApp
   ```

2. Open workspace:
   ```bash
   open PlaqueTrackerApp.code-workspace
   ```

3. Or open in Xcode:
   ```bash
   open PlaqueTracker/PlaqueTracker.xcodeproj
   ```

4. Build and run on simulator or device

## 📊 Git Workflow

```
main (production)
  └─ develop (integration/working)
      ├─ feature/* (new features)
      ├─ bugfix/* (fixes)
      └─ codex/* (experimental)
```

### Branch Guidelines
- **feature/** - New features, branch off `develop`
- **bugfix/** - Bug fixes, branch off `develop`
- **main** - Production-ready releases only
- **develop** - Integration branch, always stable

### Creating a Feature Branch
```bash
git checkout develop
git checkout -b feature/your-feature-name
# ... make changes ...
git push -u origin feature/your-feature-name
# Create PR to develop
```

## 🎯 Game Mechanics

- **Streaks**: Encourages daily app usage
- **XP System**: Progression and rewards
- **Smile Score**: Real-time feedback on brushing
- **Achievements**: Badges for milestones
- **Leaderboards**: Social motivation (coming soon)

## 📸 Image Assets Needed

To complete the app, provide images for:
1. **Mascot/Character** - Friendly tooth character in multiple states
2. **Educational Illustrations** - Dental hygiene guides
3. **Badge/Achievement Art** - Sticker set for rewards
4. **UI Assets** - Custom icons and backgrounds
5. **Example Photos** - Sample scan results for gallery

## 🤝 Contributing

1. Create a feature branch from `develop`
2. Make your changes with clear commit messages
3. Push and create a Pull Request
4. Request review before merging to `develop`
5. After testing, merge feature branch to `develop`
6. When ready for release, merge `develop` to `main`

## 📝 License

[Add your license here]

## 👨‍💻 Author

Gayrat Hamraev - Created March 2026
