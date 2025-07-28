# CyberCrawler Stealth Action

**2.5D Stealth Action gameplay system for CyberCrawler - Navigate through corporate environments to access terminals for network infiltration**

## 🎯 Project Scope

This repository contains the **Stealth Action component** of CyberCrawler - a 2.5D stealth gameplay system that serves as the bridge between the physical world and the cyberspace tower defense battles.

### What This Repository IS For:
- **2.5D stealth action gameplay** in corporate environments
- **Multi-terminal interaction system** for network access
- **Player character movement and stealth mechanics**
- **Guard and security system interactions**
- **Alert system integration** with tower defense gameplay
- **Environmental storytelling** through level design
- **Terminal-based network infiltration** mechanics

### What This Repository IS NOT For:
- ❌ **Tower defense mechanics** (separate repository)
- ❌ **Hub/Safehouse systems** (separate repository)
- ❌ **Final art assets** (placeholder art only)
- ❌ **Story dialogue systems** (separate system)

## 🎮 Core Gameplay Concept

### The Multi-Terminal System
Players navigate through 2.5D corporate environments to access **multiple specialized terminals** that control different aspects of the tower defense battle:

#### Terminal Types:
1. **Main Terminal** 🎯
   - **Purpose**: Program data packet storage and release
   - **Location**: Hardest to reach, heavily guarded
   - **Function**: Primary win condition - release data packet into enemy network

2. **Tower Placement Terminal** 🏗️
   - **Purpose**: Deploy and manage defensive towers
   - **Function**: Strategic tower positioning in cyberspace

3. **Mine Deployment Terminal** 💣
   - **Purpose**: Place freeze mines and tactical devices
   - **Function**: Tactical countermeasures against rival hacker

4. **Upgrade Terminal** ⚡
   - **Purpose**: Enhance existing towers and systems
   - **Function**: Improve placed defenses and capabilities

5. **Future Terminals** 🔮
   - Additional specialized terminals to be determined
   - Modular system for future expansion

### Interconnected Gameplay Loop
1. **Stealth Navigation**: Move through 2.5D environment avoiding guards
2. **Terminal Access**: Reach and interact with specialized terminals
3. **Network Infiltration**: Jack into cyberspace for tower defense
4. **Alert Consequences**: Actions in each world affect the other
5. **Frantic Movement**: Switch between terminals under pressure

## 🚨 Alert System Integration

### Bidirectional Alert System
- **Stealth → Tower Defense**: Setting off alarms alerts the rival hacker
- **Tower Defense → Stealth**: Rival hacker actions alert guards in 2.5D world
- **Escalating Tension**: Player must manage both worlds simultaneously

### Security Responses
- **2.5D World**: Guards patrol, investigate disturbances, chase player
- **Cyberspace**: Rival hacker deploys countermeasures, increases difficulty
- **Cross-System**: Actions in one world make the other more dangerous

## 🎯 Development Goals

### Simple Core Goal
**Make a simple player character that can interact in a 2.5D world and use different terminals to play the tower defense game.**

### Key Objectives:
- ✅ **Player Character**: Basic 2.5D movement and stealth mechanics
- ✅ **Terminal Interaction**: Interface system for network access
- ✅ **Multi-Terminal Support**: Different terminals for different functions
- ✅ **Alert System**: Bidirectional consequences between worlds
- ✅ **Integration Layer**: Communication with tower defense system

## 🛠️ Development Workflow

### Git Workflow
We follow a strict branching strategy:

```
feature/bugfix/issue → dev → main
```

#### Branch Types:
- **`feature/[name]`**: New functionality development
- **`bugfix/[name]`**: Bug fixes and corrections
- **`issue/[number]`**: GitHub issue-specific fixes
- **`dev`**: Integration and testing branch
- **`main`**: Stable, production-ready code

#### Development Process:
1. **Start New Work**: `git checkout dev; git pull origin dev`
2. **Create Feature Branch**: `git checkout -b feature/your-feature-name`
3. **Development**: Make changes, test, commit regularly
4. **Push Feature**: `git push origin feature/your-feature-name`
5. **Pull Request**: Create PR from feature → dev
6. **Code Review**: Review and approval process
7. **Merge to Dev**: Integration testing on dev branch
8. **Release**: Merge dev → main when stable

#### Branch Commands:
```bash
# Check current branch and status
git branch -a
git status

# Create new feature branch
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name

# Switch between branches
git checkout dev
git checkout main
git checkout feature/your-feature-name

# Push feature branch
git push origin feature/your-feature-name

# Clean up after merge
git checkout dev
git branch -d feature/your-feature-name
```

## 🏗️ Technical Architecture

### Game Engine
- **Godot Engine**: Primary development platform
- **2.5D Rendering**: Isometric or pseudo-3D perspective
- **Modular Design**: Interface-driven architecture

### Core Systems (Planned)
- **Player Controller**: Movement, stealth, interaction
- **Terminal System**: Multi-terminal management and UI
- **Security System**: Guards, cameras, patrol routes
- **Alert Manager**: Cross-system communication
- **Level Manager**: Environment loading and progression
- **Integration Layer**: Communication with tower defense system

### Development Constraints
- **Placeholder Art**: Focus on functionality over visuals
- **Modular Architecture**: Support future integration with other systems
- **Interface-Driven**: Clean separation between systems
- **Testing-First**: Comprehensive test coverage for stability

## 📋 Development Phases

### Phase 1: Foundation Setup 🚧 CURRENT PHASE
**Goal**: Establish basic project structure and core systems

**Tasks**:
- [ ] Project setup and repository organization
- [ ] Git workflow implementation and branch structure
- [ ] Basic player character with 2.5D movement
- [ ] Simple environment for testing
- [ ] Terminal interaction framework

**Success Criteria**:
- Player can move in 2.5D space
- Basic terminal interaction works
- Development workflow is established
- Foundation is ready for expansion

### Phase 2: Multi-Terminal System 📋 NEXT
**Goal**: Implement the multi-terminal interaction system

**Tasks**:
- [ ] Terminal base class and interface system
- [ ] Main terminal implementation (data packet release)
- [ ] Tower placement terminal
- [ ] Mine deployment terminal  
- [ ] Upgrade terminal
- [ ] Terminal UI and feedback systems

**Success Criteria**:
- All terminal types are functional
- Player can switch between terminals effectively
- UI provides clear feedback for each terminal type
- Integration points with tower defense are established

### Phase 3: Stealth Mechanics 📋 FUTURE
**Goal**: Core stealth gameplay systems

**Tasks**:
- [ ] Guard AI and patrol systems
- [ ] Player stealth mechanics (visibility, sound)
- [ ] Security cameras and detection systems
- [ ] Alert states and consequences
- [ ] Environmental hazards and obstacles

### Phase 4: Alert System Integration 📋 FUTURE
**Goal**: Bidirectional alert system with tower defense

**Tasks**:
- [ ] Alert manager for cross-system communication
- [ ] Stealth → Tower Defense alert triggers
- [ ] Tower Defense → Stealth alert responses
- [ ] Dynamic difficulty scaling based on alert states
- [ ] Visual and audio feedback for alert states

### Phase 5: Polish and Integration 📋 FUTURE
**Goal**: Refinement and full system integration

**Tasks**:
- [ ] Performance optimization
- [ ] Visual polish and placeholder art improvements
- [ ] Audio integration
- [ ] Full integration testing with tower defense system
- [ ] Balancing and difficulty tuning

## 🎨 Art Style Guidelines

- **Style**: Stylized 2.5D Isometric
- **Approach**: Hi-Bit Pixel Art or Vector Noir
- **Constraint**: Placeholder art during development
- **Consistency**: Match tower defense visual style
- **Perspective**: Isometric or pseudo-3D for clear navigation

## 🎮 Design Pillars

Every development decision must serve these core principles:

1. **The Ghost & The Machine**
   - Player embodies a cunning "ghost" in the physical world
   - Seamless transition between stealth and strategic thinking

2. **Asymmetrical Warfare**
   - Player is outnumbered and outgunned
   - Victory through cunning, not direct confrontation

3. **A Living, Breathing Dystopia**  
   - Corporate environments tell the story of oppression
   - Environmental storytelling through level design

## 🧪 Testing Strategy

### Testing Framework
- **GDScript Unit Tests**: I use GUT for unit tests and integration tests. Core system functionality is tested with unit tests
- **Integration Tests**: Cross-system communication
- **Performance Tests**: 2.5D rendering and AI systems
- **User Experience Tests**: Terminal interaction flow

### Quality Assurance
- **Code Coverage**: Maintain high test coverage
- **Performance Monitoring**: Frame rate and memory usage
- **Cross-Platform Testing**: Ensure compatibility
- **Integration Validation**: Test with tower defense system

## 🚀 Getting Started

### Prerequisites
- **Godot Engine 4.x**: Primary development environment
- **Git**: Version control with submodule support
- **PowerShell**: Windows development shell
- **Tower Defense Repository**: For integration testing

### Setup Instructions

#### 1. Clone and Setup
```bash
# Clone the repository
git clone https://github.com/rivie13/cybercrawler-stealth-action.git
cd cybercrawler-stealth-action

# Set up development branch
git checkout dev
git pull origin dev
```

#### 2. Create Development Branch
```bash
# Create your feature branch
git checkout -b feature/your-feature-name

# Verify you're on the correct branch
git branch
```

#### 3. Godot Setup
1. Open Godot Engine 4.x
2. Import project from repository root
3. Configure project settings for 2.5D development
4. Test basic functionality

#### 4. Development Workflow
1. Make changes on your feature branch
2. Test thoroughly before committing
3. Push feature branch and create pull request
4. Review and merge through dev → main workflow

### Project Structure (Planned)
```
cybercrawler-stealth-action/
├── scenes/                 # Godot scene files
│   ├── player/            # Player character scenes
│   ├── terminals/         # Terminal interaction scenes
│   ├── environments/      # Level and environment scenes
│   └── ui/               # User interface scenes
├── scripts/               # GDScript source code
│   ├── player/           # Player controller and mechanics
│   ├── terminals/        # Terminal system scripts
│   ├── security/         # Guard and security systems
│   ├── managers/         # System managers
│   └── integration/      # Tower defense integration
├── assets/               # Art, audio, and resource files
│   ├── sprites/          # 2D sprites and textures
│   ├── audio/           # Sound effects and music
│   └── fonts/           # UI fonts
├── tests/                # Automated test scripts
└── docs/                # Additional documentation
```

## 🤝 Contributing

### Development Guidelines
1. **Follow Git Workflow**: Always use feature branches
2. **Test Before Commit**: Ensure functionality works
3. **Code Standards**: Follow GDScript best practices
4. **Documentation**: Update docs for new features
5. **Integration**: Consider tower defense system impact

### Code Review Process
- **Pull Requests**: All changes go through PR review
- **Testing**: Automated tests must pass
- **Integration**: Test with related systems
- **Performance**: Monitor impact on frame rate
- **Architecture**: Maintain modular, interface-driven design

### Communication
- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: Use repository discussions for design questions
- **Documentation**: Keep README and docs up to date

## 🔗 Integration with CyberCrawler Ecosystem

### Repository Relationships
- **Parent Repository**: CyberCrawler main orchestration
- **Tower Defense**: Primary integration target
- **Hub System**: Future mission selection integration
- **Shared Assets**: Common resources and utilities

### Cross-System Communication
- **Alert System**: Bidirectional communication with tower defense
- **Progress Tracking**: Mission state and player progress
- **Resource Sharing**: Assets and configuration data
- **State Management**: Save/load integration

## 📈 Development Status

### Current Phase: Foundation Setup 🚧
- ⚡ **Active Development**: Project setup and basic systems
- 📋 **Next Priority**: Player character and basic movement
- 🎯 **Goal**: Establish foundation for multi-terminal system

### Completed Milestones
- ✅ Repository setup and documentation
- ✅ Git workflow establishment
- ✅ Development branch structure

### Upcoming Milestones
- 🔄 Basic player character implementation
- 🔄 Terminal interaction framework
- 🔄 Integration layer with tower defense system

## 📄 License

[License information to be determined - should match parent CyberCrawler repository]

---

**CyberCrawler Stealth Action** - *Where the physical and digital worlds collide in tactical infiltration gameplay.*

---

### Quick Reference Commands

```bash
# Start new feature
git checkout dev && git pull origin dev
git checkout -b feature/your-feature-name

# Daily workflow
git status
git add .
git commit -m "Descriptive commit message"
git push origin feature/your-feature-name

# Switch branches
git checkout dev          # Switch to dev
git checkout main         # Switch to main
git branch -a            # List all branches
```

*Remember: Always work on feature branches, never directly on dev or main!*
