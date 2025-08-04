# Isometric Tile Set Development Plan
## Cyberpunk Dystopia Corpo Office Theme

### Overview
This document outlines the complete process for creating an isometric tile set for the basic demo of the stealth action portion of the CYBERCRAWLER game, focusing on a cyberpunk dystopia corpo office environment with multiple floors and distinct areas.

### 1. Tile Set Specifications

#### 1.1 Technical Specifications
- **Tile Size**: 32x16 pixels (isometric diamond shape)
- **Color Palette**: 
  - Primary: Dark blues (#1a1a2e, #16213e, #0f3460)
  - Secondary: Teal/cyan (#00d4ff, #00b4d8)
  - Accent: Orange/red (#ff6b35, #ff4757)
  - Neutral: Grays (#2d2d2d, #404040, #666666)
- **Style**: Pixel art with cyberpunk aesthetic
- **Format**: PNG with transparency support

#### 1.2 Required Tile Categories

##### Floor Tiles
- **Basic Floor**: Plain dark tile with subtle grid pattern
- **Floor with Grates**: Ventilated floor sections
- **Floor with Light Strips**: Embedded lighting
- **Floor with Security Grid**: Red laser lines
- **Corner Pieces**: For seamless connections
- **Edge Pieces**: For wall connections

##### Wall Tiles
- **Basic Wall**: Dark industrial panels
- **Wall with Security Light**: Orange/red glowing lights
- **Wall with Vent**: Air circulation grates
- **Wall with Control Panel**: Interactive elements
- **Wall with Window**: Transparent sections
- **Corner Walls**: Inner and outer corners
- **Door Frames**: Entry/exit points
- **Wall Ends**: Terminal pieces

##### Structural Elements
- **Pillars**: Support structures
- **Railings**: Safety barriers
- **Stairs**: Multi-level connections
- **Elevators**: Vertical transport
- **Beams**: Overhead structures

##### Interactive/Prop Tiles
- **Terminal Tiles**:
  - Standalone hacker terminal (glowing cyan screen)
  - Desk with multiple monitors
  - Wall-mounted control panel
- **Security Elements**:
  - Security cameras (red glowing light)
  - Laser tripwires
  - Access control panels
- **Office Furniture**:
  - Desks and chairs
  - Filing cabinets
  - Office plants
- **Industrial Elements**:
  - Server racks
  - Power units
  - Storage crates

##### Character Sprites
- **Player Character**:
  - Hooded figure with dark attire
  - Glowing cyan visor/eyes
  - Stealth pose variations
- **Enemy Characters**:
  - Armored guards with red visors
  - Various poses (idle, walking, alert)
  - Weapon variations

### 2. Tile Creation Process

#### 2.1 Aseprite Setup
1. **Create Canvas**: 256x256 pixels (8x8 tile grid)
2. **Set Up Layers**:
   - Background
   - Floor Tiles
   - Wall Tiles
   - Props
   - Characters
3. **Configure Grid**: 32x16 pixel isometric diamond
4. **Color Palette**: Import cyberpunk color scheme

#### 2.2 Tile Design Guidelines
- **Consistency**: Maintain uniform lighting direction
- **Modularity**: Ensure tiles connect seamlessly
- **Variety**: Create multiple variations for visual interest
- **Functionality**: Design for gameplay mechanics
- **Atmosphere**: Emphasize cyberpunk dystopia theme

#### 2.3 Creation Workflow
1. **Sketch Basic Shapes**: Outline tile boundaries
2. **Add Base Colors**: Apply primary color palette
3. **Detail Work**: Add textures, patterns, and effects
4. **Lighting**: Apply consistent lighting/shading
5. **Variations**: Create multiple versions of each tile type
6. **Testing**: Verify tile connections and compatibility

### 3. Export and Godot Integration

#### 3.1 Export Process
1. **Export as PNG**: Maintain transparency
2. **Organize by Category**: Separate files for different tile types
3. **Create Tile Atlas**: Combine related tiles into single images
4. **Document Tile Properties**: Note dimensions and connections

#### 3.2 Godot Tile Set Setup
1. **Import Assets**: Add PNG files to Godot project
2. **Create Tile Set Resource**: New TileSet in Godot
3. **Configure Isometric Settings**:
   - Tile Shape: Isometric
   - Tile Layout: Diamond Downward
   - Tile Size: 32x16
4. **Set Up Atlas**: Import tile images
5. **Configure Tile Properties**:
   - Texture Origin: (0, -8) for proper alignment
   - Margin: 16,16
   - Separation: 16,16
   - Texture Region: 32,32

   **IMPORTANT** TileMap is being deprecated in favor of the new TileMapLayer system.

#### 3.3 Tile Map Configuration
1. **Create Tile Map Layer**: Add to scene using the new TileMapLayer system.
2. **Assign Tile Set**: Link created TileSet resource
3. **Set Up Multiple Layers**: For different floor levels
4. **Configure Collision**: Add collision shapes to tiles
5. **Set Up Navigation**: Configure pathfinding

### 4. Basic Scene Creation

#### 4.1 Scene Structure
```
Main Scene
├── TileMapLayer (Ground Floor)
├── TileMapLayer (Upper Floor)
├── TileMapLayer (Props)
├── Player
├── Enemies
└── UI Elements
```

#### 4.2 Level Design Guidelines
- **Multi-Level Layout**: Use multiple TileMapLayers for depth
- **Functional Areas**: Design distinct zones (cubicles, executive, cafeteria)
- **Pathfinding**: Ensure navigable spaces for AI
- **Line of Sight**: Consider stealth mechanics
- **Interactive Elements**: Place terminals strategically

### 5. Player Movement and Interaction

#### 5.1 Movement System
1. **Input Handling**: Keyboard controls for isometric movement
2. **Pathfinding**: A* navigation on tile grid
3. **Collision Detection**: Wall and obstacle avoidance
4. **Animation**: Character sprite transitions

#### 5.2 Terminal Interaction
1. **Detection**: Proximity-based interaction zones
2. **Interface**: UI system for terminal access
3. **Functionality**: Hacking mechanics and feedback
4. **Visual Feedback**: Screen effects and animations

### 6. Implementation Timeline

#### Phase 1: Core Tiles (Week 1)
- [ ] Basic floor tiles (5 variations)
- [ ] Basic wall tiles (5 variations)
- [ ] Corner and edge pieces
- [ ] Simple props (desks, chairs)

#### Phase 2: Interactive Elements (Week 2)
- [ ] Terminal tiles (3 variations)
- [ ] Security elements (cameras, panels)
- [ ] Character sprites (player, enemies)
- [ ] Advanced props (servers, crates)

#### Phase 3: Godot Integration (Week 3)
- [ ] Tile set creation in Godot
- [ ] Basic scene construction
- [ ] Player movement implementation
- [ ] Terminal interaction system

#### Phase 4: Testing and Refinement (Week 4)
- [ ] Scene testing and debugging
- [ ] Performance optimization
- [ ] Visual polish and effects
- [ ] Documentation completion

### 7. Tools and Resources

#### 7.1 Aseprite MCP Tools Available
- `aseprite_create_canvas`: Create new Aseprite files
- `aseprite_draw_pixels`: Draw individual pixels
- `aseprite_draw_rectangle`: Create rectangular shapes
- `aseprite_draw_circle`: Create circular elements
- `aseprite_draw_line`: Draw lines and edges
- `aseprite_fill_area`: Fill areas with color
- `aseprite_export_sprite`: Export to PNG format
- `aseprite_add_layer`: Organize tile layers
- `aseprite_add_frame`: Create animation frames

#### 7.2 Reference Materials
- Cyberpunk color palettes
- Isometric design principles
- Godot TileSet documentation
- Pixel art techniques

### 8. Quality Assurance

#### 8.1 Tile Testing
- **Connection Testing**: Verify seamless tile connections
- **Visual Consistency**: Check lighting and style uniformity
- **Performance Testing**: Ensure reasonable file sizes
- **Gameplay Testing**: Validate functional requirements

#### 8.2 Scene Testing
- **Navigation Testing**: Verify pathfinding works correctly
- **Interaction Testing**: Test terminal and prop interactions
- **Performance Testing**: Check frame rates and memory usage
- **User Experience Testing**: Validate intuitive gameplay

### 9. Future Enhancements

#### 9.1 Advanced Features
- **Dynamic Lighting**: Real-time lighting effects
- **Weather Effects**: Environmental overlays
- **Animation**: Animated tiles and props
- **Sound Integration**: Audio cues for interactions

#### 9.2 Expansion Possibilities
- **Additional Areas**: More office zones and facilities
- **Variety Packs**: Different corporate themes
- **Seasonal Themes**: Holiday and event variations
- **Modular System**: Easy tile set modifications

---

This plan provides a comprehensive roadmap for creating a professional-quality isometric tile set that will serve as the foundation for the CYBERCRAWLER game's visual and gameplay systems. 