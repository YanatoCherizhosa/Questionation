using Godot;
using System;



public class Exit : Button
{
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Console.WriteLine("GODOT Hello!");
	}

	/*private void ExitApplication()
	{
		quit(0);	
	}*/
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}


private void _on_Exit_button_up()
{
	GetTree().Quit();
}
