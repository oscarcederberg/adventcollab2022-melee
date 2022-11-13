package melee.states;

import melee.enemies.Enemy;
import melee.enemies.Devil;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
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
	public var player:Player;
	public var enemies:FlxTypedGroup<Enemy>;
	public var random:FlxRandom;

	//This is the Start function
	override function create()
	{
		super.create();

		this.random = new FlxRandom();

		this.player = new Player(0, 0);
		Global.screenCenter(player);
		add(player);

		this.enemies = new FlxTypedGroup();
		add(this.enemies);
		for (i in 0...10)
		{
			var enemy = new Devil(this.random.int(0, Global.width), this.random.int(0, Global.height));
			this.enemies.add(enemy);
		}
	}

	/** This is where your game updates each frame */
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		this.player.update(elapsed);
		this.enemies.update(elapsed);

		FlxG.collide(this.enemies, this.enemies);
		FlxG.collide(this.player, this.enemies);
	}
}