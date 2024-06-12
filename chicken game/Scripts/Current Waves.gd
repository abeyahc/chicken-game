extends RichTextLabel

var default_text = "Current Wave: "

func _process(delta):
	var text = str(default_text, str(Global.curr_wave))
	self.text = text
