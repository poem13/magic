extends TextureButton
signal click

export(bool) var pointer_is_over_target

func _ready():
	connect("click", self, "click")	

func _on_TimedClickBar_pressed():
	print("callback")
	if pointer_is_over_target:
		Global.pointer_over_target = true
		State.damage = State.damage * 2
		emit_signal("click")
	else:
		Global.pointer_over_target = false
		print(Global.pointer_over_target)
		emit_signal("click")


func _on_TimedClickBar_mouse_entered():
	self.material.set_shader_param("line_scale", 2)


func _on_TimedClickBar_mouse_exited():
	self.material.set_shader_param("line_scale", 0)
