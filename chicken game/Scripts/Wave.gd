extends RichTextLabel


func _process(delta):
	if Global.curr_wave == 1:
		var text = str("You Survived ", str(Global.curr_wave), " wave\n", "Your highest is ", str(Global.high_wave))
		self.bbcode_text = "[center]" + text + "[/center]"
	else:
		var text = str("You Survived ", str(Global.curr_wave), " waves\n", "Your highest is ", str(Global.high_wave))
		self.bbcode_text = "[center]" + text + "[/center]"
