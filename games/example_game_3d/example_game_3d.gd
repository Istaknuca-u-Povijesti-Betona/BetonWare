extends MinigameBase

var score : int = 0
var score_required : int = 10
var score_label : Node
var ball_spawn_timer : Node
var enemy_spawn_area_corner_1 : Node	#TODO: this is evil as fuck but I cant be bothered with an area3d yet
var enemy_spawn_area_corner_2 : Node

var the_orb = preload("res://games/example_game_3d/orb.tscn")

func _ready():
	score_label = $Player/ScoreContainer/ScoreLabel
	enemy_spawn_area_corner_1 = $SpawnArea
	enemy_spawn_area_corner_2 = $SpawnArea/SpawnArea
	root_node = self.get_parent()
	ball_spawn_timer = $EnemySpawnTimer
	await get_tree().create_timer(1.0).timeout
	ball_spawn_timer.start()

func add_score():
	score += 1
	score_label.set_text(str(score) + " / " + str(score_required))
	if score == 10:
		root_node.end_game("win")

func _on_ball_spawn_timer_timeout():
	spawn_orb()

func spawn_orb():
	var random_position : Vector3 = Vector3(randi() % int(enemy_spawn_area_corner_2.position.x), randi() % int(enemy_spawn_area_corner_2.position.y), randi() % int(enemy_spawn_area_corner_2.position.z))
	var orb_instance = the_orb.instantiate()
	orb_instance.main = self
	enemy_spawn_area_corner_1.add_child(orb_instance)
	orb_instance.position = random_position
