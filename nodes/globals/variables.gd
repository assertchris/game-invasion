extends Node

var room_position_options := []
var room_positions_taken := []
var rooms_made := []
var current_room : Node2D
var is_moving_rooms := false

var player_last_position : Vector2

var current_navigation : Navigation2D
