class_name PlayerMovementComponent
extends RefCounted

@export var speed: float = 200.0
@export var acceleration: float = 10.0
var current_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func update_movement(delta: float, input_direction: Vector2) -> Vector2:
    # Smooth movement with acceleration
    if input_direction != Vector2.ZERO:
        velocity = velocity.move_toward(input_direction * speed, acceleration * speed * delta)
    else:
        velocity = velocity.move_toward(Vector2.ZERO, acceleration * speed * delta)
    
    current_direction = input_direction
    return velocity

func get_current_direction() -> Vector2:
    return current_direction

func is_moving() -> bool:
    return velocity.length() > 1.0