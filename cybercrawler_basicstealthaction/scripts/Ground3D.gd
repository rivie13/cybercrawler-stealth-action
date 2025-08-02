class_name Ground3D
extends StaticBody3D

@onready var ground_mesh: MeshInstance3D = $GroundMesh
@onready var ground_collision: CollisionShape3D = $GroundCollision

func _ready() -> void:
    # Create a simple ground plane
    var plane_mesh = PlaneMesh.new()
    plane_mesh.size = Vector2(20, 20)  # 20x20 unit ground
    
    # Create material for the ground
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.3, 0.3, 0.3, 1)  # Dark gray
    material.metallic = 0.0
    material.roughness = 0.8
    
    # Apply mesh and material
    ground_mesh.mesh = plane_mesh
    ground_mesh.material_override = material
    
    # Set up collision
    var collision_shape = BoxShape3D.new()
    collision_shape.size = Vector3(20, 0.1, 20)  # Thin box for ground collision
    ground_collision.shape = collision_shape
    
    # Position the ground at Y=0
    global_position = Vector3(0, 0, 0) 