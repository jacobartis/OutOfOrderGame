extends RayCast3D

@onready var magnet_area = $MagnetArea
@onready var default = $Default

#Handles pulling magnetic objects to the player
func pull() -> void:
	magnet_area.set_global_position(get_magnet_point())
	var mag_pos = magnet_area.get_global_position()
	for body in magnet_area.get_overlapping_bodies():
		if body.is_in_group("Magnetic"):
			body.pull(mag_pos,10*sqrt(mag_pos.distance_to(body.get_position())))

func push() -> void:
	magnet_area.set_global_position(get_magnet_point())
	for body in magnet_area.get_overlapping_bodies():
		if body.is_in_group("Magnetic"):
			body.push(get_global_position(),10*sqrt(get_global_position().distance_to(body.get_position())))

#Gets the point of the magnatisms origin
func get_magnet_point() -> Vector3:
	if (get_collision_point()-global_position).length_squared() > 2.5:
		#If the distance is bigger than 2 a default position is used instead
		return default.get_global_position()
	#Returns the point of collision if the default would be behind a wall
	return get_collision_point()
