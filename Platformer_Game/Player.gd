extends CharacterBody2D

var direction_x := 0.0
@export var speed = 150
var can_shoot := true
var facing_right := true
var has_gun := false
var health := 100
var vulnerable := true

signal shoot (pos: Vector2, direction: bool)


func _process(_delta):
	get_input()
	apply_gravity()
	get_animation()
	get_facing_direction()
	
	velocity.x = direction_x * speed
	move_and_slide()
	check_death()
	
func get_input():
	direction_x = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -200
		$Node/JumpSound.play()
	if Input.is_action_just_pressed("shoot") and can_shoot and has_gun:
		shoot.emit(global_position, facing_right)
		can_shoot = false
		$Timer/Cooldown_Timer.start()
		$Timer/Fire_Timer.start()
		$Node/FireSound.play()
		$Fire.get_child(int(facing_right)).show()
		
func apply_gravity():
	velocity.y += 20
		
func get_facing_direction():
	if direction_x != 0:
		facing_right = direction_x >= 0
		
func get_animation():
	var animation = "idle"
	if not is_on_floor():
		animation = 'jump'
	elif direction_x != 0:
		animation = 'walk'
		
	if has_gun:
		animation += '_gun'
	$AnimatedSprite2D.animation = animation
	$AnimatedSprite2D.flip_h = not facing_right
	
func _on_cooldown_timer_timeout():
	can_shoot = true

func _on_fire_timer_timeout():
	for child in $Fire.get_children():
		child.hide()

func get_damage(amount):
	if vulnerable:
		health -= amount
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0,0.0)
		tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0,0.2).set_delay(0.2)
		$Node/Damage.play()
		vulnerable = false
		$Timer/Invisibility_Timer.start()
		
func check_death():
	if health <= 0:
		get_tree().quit()


func _on_invisibility_timer_timeout():
	vulnerable = true
