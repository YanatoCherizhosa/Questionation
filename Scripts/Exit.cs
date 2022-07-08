using Godot;
public class Exit : Button
{
	private void _on_Exit_button_up()
	{
		GetTree().Quit();
	}
}
