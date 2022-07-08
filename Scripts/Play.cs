using Godot;
public class Play : Button
{
	private void _on_Play_button_up()
	{
		GetTree().ChangeScene("res://Scenes/Game.tscn");
	}
}
