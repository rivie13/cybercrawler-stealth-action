class_name MockTileMapLayer
extends Node2D

var mock_cells: Dictionary = {}
var mock_used_cells: Array = []
var mock_source_ids: Dictionary = {}

# Mock methods that match the interface expected by TerminalSpawner
func get_used_cells() -> Array:
	return mock_used_cells

func get_cell_atlas_coords(pos: Vector2i) -> Vector2i:
	return mock_cells.get(pos, Vector2i.ZERO)

func get_cell_source_id(pos: Vector2i) -> int:
	return mock_source_ids.get(pos, -1)

func map_to_local(cell_pos: Vector2i) -> Vector2:
	# Convert cell position to world position (16x16 tiles)
	return Vector2(cell_pos.x * 16, cell_pos.y * 16)

func set_mock_cell(pos: Vector2i, atlas_coords: Vector2i, source_id: int = 0):
	mock_cells[pos] = atlas_coords
	mock_source_ids[pos] = source_id
	if not mock_used_cells.has(pos):
		mock_used_cells.append(pos)

func clear_mock_cells():
	mock_cells.clear()
	mock_used_cells.clear()
	mock_source_ids.clear() 