extends RigidBody


var time = 0


func _ready():
	pass # Replace with function body.



func _process(delta):
	time += delta
	self.translation = Vector3(0, 2.3 + sin(time), -19)
