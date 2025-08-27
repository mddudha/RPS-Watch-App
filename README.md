# 🎮 RPS Watch App - Rock Paper Scissors for Apple Watch

A beautifully designed, feature-rich Rock Paper Scissors game built specifically for Apple Watch with modern SwiftUI animations and engaging gameplay.

## 📱 Overview

RPS Watch App is a best-of-3 match-based Rock Paper Scissors game that offers an immersive gaming experience on Apple Watch. The app features smooth animations, haptic feedback, confetti celebrations, and a responsive design that works perfectly across all watch sizes.

## ✨ Features

### 🎯 Core Gameplay
- **Best-of-3 Match Format**: First to win 2 rounds takes the match
- **Instant Gameplay**: No countdown - choose your move and see results immediately
- **Smart Round Logic**: Draws don't count as rounds, matches can end early
- **Persistent Statistics**: Tracks overall matches won/lost across sessions

### 🎨 Visual Design
- **Modern UI**: Clean, game-like interface with material design elements
- **Color-Coded Moves**: Each move (Rock/Paper/Scissors) has its own color theme
- **Responsive Layout**: Adapts to different watch sizes automatically
- **Beautiful Animations**: Smooth transitions and engaging visual effects

### 🎊 Celebration Effects
- **Confetti Animation**: Colorful confetti with physics simulation on victory
- **Victory Glow**: Radial gradient effect when you win
- **Shockwave Effect**: Expanding circle animation for dramatic impact
- **Trophy Animation**: Animated trophy with spring effects

### 📊 Game Statistics
- **Match Tracking**: Persistent win/loss record using @AppStorage
- **Round Counter**: Shows current round (1-3) and match progress
- **Score Display**: Real-time score tracking during matches
- **Final Results**: Comprehensive match summary

### 🎮 User Experience
- **Haptic Feedback**: Different haptic patterns for wins, losses, draws, and interactions
- **Intuitive Controls**: Simple tap-to-play interface
- **Context-Aware Buttons**: Different colored buttons for different actions
- **Smooth Transitions**: Seamless flow between game stages

## 🛠 Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **WatchKit Integration**: Native watch features and haptics
- **State Management**: Reactive UI with @State and @AppStorage
- **Enum-Based Design**: Clean separation of game logic

### Key Components
- **Move Enum**: Rock (✊), Paper (✋), Scissors (✌️) with color properties
- **Stage System**: Selecting → Reveal → Match Over flow
- **Confetti System**: Custom particle animation with physics
- **Responsive Design**: Adaptive layouts for different watch sizes

### Animations
- **Spring Animations**: Natural, bouncy feel for interactions
- **Confetti Physics**: Random rotation, scaling, and falling motion
- **Victory Effects**: Multiple layered animations for celebrations
- **Smooth Transitions**: Asymmetric transitions between stages

## 📋 Requirements

### Development
- **Xcode**: 15.0 or later
- **iOS**: 17.0 or later
- **watchOS**: 10.0 or later
- **Swift**: 5.9 or later

### Runtime
- **Apple Watch**: Series 4 or later
- **watchOS**: 10.0 or later
- **iPhone**: iOS 17.0 or later (for pairing)

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd RPS
```

### 2. Open in Xcode
```bash
open RPS.xcodeproj
```

### 3. Configure Signing
- Select the project in the navigator
- Go to "Signing & Capabilities" tab
- Check "Automatically manage signing"
- Select your Apple Developer Team

### 4. Select Target
- Choose "RPS Watch App" target (not the main "RPS" target)
- Ensure deployment target matches your watch's watchOS version

### 5. Run the App
- Select your Apple Watch as the run destination
- Press Cmd+R or click the Play button
- The app will install on your watch automatically

## 🎮 How to Play

### Game Flow
1. **Choose Your Weapon**: Tap Rock (✊), Paper (✋), or Scissors (✌️)
2. **Instant Reveal**: See both your choice and CPU's choice immediately
3. **Round Result**: View the outcome (Victory/Defeat/Tie)
4. **Continue**: Tap "Next" to continue or "Result" to see final match outcome
5. **Play Again**: Start a new match after completion

### Scoring System
- **Round Win**: +1 to your score
- **Round Loss**: +1 to CPU score
- **Draw**: No points awarded, round doesn't count
- **Match Win**: First to 2 round wins
- **Statistics**: Overall matches won/lost are tracked persistently

### Button Colors
- **Blue "Next"**: Continue to next round
- **Orange "Result"**: View final match result
- **Green "Play Again"**: Start new match
- **Red "Reset"**: Reset all statistics

## 🎨 Design Features

### Visual Elements
- **Gradient Background**: Purple/blue/pink animated gradient
- **Material Design**: Ultra-thin material effects for cards
- **Color Themes**: Red (Rock), Blue (Paper), Green (Scissors)
- **Rounded Corners**: Modern, friendly appearance

### Animations
- **Card Scaling**: Buttons scale when pressed
- **Pulsing Winners**: Winner cards pulse with spring animation
- **Confetti System**: 15 pieces with random colors, shapes, and physics
- **Victory Effects**: Glow, shockwave, and trophy animations

### Responsive Design
- **Adaptive Spacing**: Different spacing for small vs large watches
- **Flexible Layouts**: Components scale appropriately
- **Edge Protection**: No elements cut off at screen edges
- **Touch Optimization**: Properly sized touch targets

## 🔧 Development Notes

### Project Structure
```
RPS/
├── RPS Watch App/
│   ├── ContentView.swift      # Main game interface
│   ├── RPSApp.swift          # App entry point
│   └── Assets.xcassets/      # App icons and colors
├── RPS Watch AppTests/       # Unit tests
├── RPS Watch AppUITests/     # UI tests
└── RPS.xcodeproj/           # Xcode project file
```

### Key Files
- **ContentView.swift**: Main game logic and UI
- **RPSApp.swift**: App initialization
- **project.pbxproj**: Xcode project configuration

### State Management
- **@AppStorage**: Persistent match statistics
- **@State**: Game state and animations
- **Enum Stages**: Clean state transitions

## 🐛 Troubleshooting

### Common Issues

#### Device Not Appearing
1. Ensure iPhone and Apple Watch are paired
2. Check both devices are signed in with same Apple ID
3. Enable Developer Mode on Apple Watch
4. Trust developer certificate on iPhone

#### Build Errors
1. Clean Build Folder (Product → Clean Build Folder)
2. Reset Package Caches (File → Packages → Reset Package Caches)
3. Check deployment target compatibility
4. Verify signing configuration

#### App Not Installing
1. Select correct target ("RPS Watch App")
2. Choose Apple Watch as run destination
3. Ensure watch is unlocked and nearby
4. Check available storage on watch

### Performance Optimization
- **Efficient Animations**: Uses SwiftUI's built-in animation system
- **Memory Management**: Confetti automatically cleans up
- **Smooth Performance**: Optimized for 60fps on all watch models

## 📈 Future Enhancements

### Potential Features
- **Multiplayer Support**: Play against friends
- **Achievement System**: Unlock badges and rewards
- **Custom Themes**: Different visual themes
- **Sound Effects**: Audio feedback for actions
- **Statistics Dashboard**: Detailed game analytics
- **Tournament Mode**: Best-of-5 or longer matches

### Technical Improvements
- **Core Data Integration**: More robust data persistence
- **CloudKit Sync**: Cross-device statistics
- **Widget Support**: Quick game access
- **Complications**: Watch face integration

## 🤝 Contributing

### Development Guidelines
- Follow SwiftUI best practices
- Maintain responsive design principles
- Add comprehensive comments
- Test on multiple watch sizes
- Ensure accessibility compliance

### Code Style
- Use SwiftUI declarative syntax
- Implement proper state management
- Follow Apple's Human Interface Guidelines
- Maintain consistent naming conventions

## 📄 License

This project is created for educational and personal use. Please respect Apple's developer guidelines and terms of service.

## 👨‍💻 Author

**Mirvaben Dudhagara**
- Created: August 25, 2025
- Platform: Apple Watch
- Language: Swift
- Framework: SwiftUI

## 🙏 Acknowledgments

- Apple for SwiftUI and WatchKit frameworks
- SwiftUI community for best practices
- Apple Watch design guidelines
- Swift programming language

---

**Enjoy playing RPS on your Apple Watch! 🎮⌚**
