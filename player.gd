extends Area2D

signal hit

@export var speed = 400
@export var shoot_scene: PackedScene
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func shoot():
	var projectile = shoot_scene.instantiate()
	projectile.position = $AnimatedSprite2D.position
	#projectile.rotation = 1 + PI / 2
	#projectile.linear_velocity.x += 1
	var sprite_2d = projectile.find_child("Sprite2D", false, false)
	add_child(projectile)
	print("abc", position, sprite_2d.get_frame_coords())
	if $AnimatedSprite2D.animation == "up" && $AnimatedSprite2D.flip_v:
		var velocity = Vector2(0, randf_range(150.0, 250.0))
		projectile.linear_velocity = velocity * 2.5
		sprite_2d.rotation_degrees = 90
		#print("Baixo")
	if $AnimatedSprite2D.animation == "up" && !$AnimatedSprite2D.flip_v:
		var velocity = Vector2(0, randf_range(-150.0, -250.0))
		projectile.linear_velocity = velocity * 2.5
		sprite_2d.rotation_degrees = 270
		#print("Cima")
	if $AnimatedSprite2D.animation == "walk" && $AnimatedSprite2D.flip_h:
		var velocity = Vector2(randf_range(-150.0, -250.0), 0)
		projectile.linear_velocity = velocity * 2.5
		sprite_2d.rotation_degrees = 180
		#print("Esquerda")
	if $AnimatedSprite2D.animation == "walk" && !$AnimatedSprite2D.flip_h:
		var velocity = Vector2(randf_range(150.0, 250.0), 0)
		projectile.linear_velocity = velocity * 2.5
		#print("Direita")

func _on_body_entered(body):
	if !body is Shoot:
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true) # disable colision so that it won't trigger hit more than once
