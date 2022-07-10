using Godot;

public class Exit : Button
{
	private void _on_Exit_pressed()
	{
		GetTree().Quit();
	}
}

