extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group('Player')

func _process(delta):
	$MarginContainer/ProgressBar.value = player.health

