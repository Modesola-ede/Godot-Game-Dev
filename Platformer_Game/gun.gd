extends Area2D

func _process(delta):
	position.y += sin(Time.get_ticks_msec()/200.0)* 10* delta


func _on_body_entered(body):
	body.has_gun = true
	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
