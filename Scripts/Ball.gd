extends RigidBody2D

export var maxspeed = 300

signal lives
signal score
var startpos
var trauma = 0
var decayrate= 0
var maxoffset = 1
func _ready():
 contact_monitor = true
 set_max_contacts_reported(4)
 var WorldNode = get_node("/root/World")
 connect("score", WorldNode, "increase_score")
 connect("lives", WorldNode, "decrease_lives")

func _physics_process(delta):
 var bodies = get_colliding_bodies()
 for body in bodies:
  if body.is_in_group("Tiles"):
   emit_signal("score",body.score)
   body.queue_free()
   var scene = "res://Scenes/Level1.tscn"
   if bodies.length() == 0 && scene == "res://Scenes/Level1.tscn":
    get_tree().change_scene("res://Scenes/Level2.tscn")
  if body.get_name() == "Paddle":
   pass
  
 if position.y > get_viewport_rect().end.y:
  emit_signal("lives")
  queue_free()
func addtrauma(amount):
	trauma = min(trauma + amount, 1)
func traumadecay(delta):
	var change = decayrate + delta
	trauma = max(trauma - change,0)
func shake():
	var shake = trauma + trauma
	var x = maxoffset + shake + _get_neg_or_pos_scalar()
	var y = maxoffset + shake + _get_neg_or_pos_scalar()
	ColorRect.rect_position = startpos + Vector2(x,y)
func _get_neg_or_pos_scalar():
	return rand_range(-1,1)