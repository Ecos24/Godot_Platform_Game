extends KinematicBody2D

# Motion Constants & Varialbes
const UP = Vector2(0,-1)
var max_speed = 200
var accelaeration = 50
var jump_height = -400
var gravity = 10

# Motion Vector
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument
func _physics_process(delta):
	
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+accelaeration, max_speed)
		$PlayerFace.flip_h = false
		$PlayerFace.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x-accelaeration, -max_speed)
		$PlayerFace.flip_h = true
		$PlayerFace.play("Run")
	else:
		$PlayerFace.play("Ideal")
		friction = true
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_height
		# Adding Ground Friction
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.20)
	else:
		if motion.y > (jump_height*0.25) && motion.y < -(jump_height*0.25):
			if motion.y < 0:
				$PlayerFace.play("JumpEnd")
			else:
				$PlayerFace.play("FallStart")
		elif motion.y < 0:
			$PlayerFace.play("Jump")
		else:
			$PlayerFace.play("Fall")
		# Adding Air Friction
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)

	motion = move_and_slide(motion, UP)
	pass
# End of function