extends CanvasLayer

func flash(color:Color = Color.white):
	$ColorRect.color = color
	$AnimationPlayer.play('Flash')