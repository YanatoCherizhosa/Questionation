using Godot;

public class Play : Button
{
	private void _on_Play_pressed()
	{
		GetTree().ChangeScene("res://Scenes/Game.tscn");
	}
}
