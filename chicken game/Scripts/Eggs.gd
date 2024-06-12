extends RichTextLabel

var default_text = "Eggs: "

func _process(delta):
	var text = str(default_text, str(Global.points), "/", str(Global.num_egg))
	self.text = text
