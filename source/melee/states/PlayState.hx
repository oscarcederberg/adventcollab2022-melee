package melee.states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * PlayState.hx is where Advent will start to access your game,
 * if you would like to add a menu to your game contact George!
**/
class PlayState extends FlxState
{
	//Initialize Variables Here
	var player:Player;

	//This is the Start function
	override function create()
	{
		super.create();

		this.player = new Player(0, 0);
		Global.screenCenter(player);
		add(player);
	}

	/** This is where your game updates each frame */
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		player.update(elapsed);
	}
}