package melee.states;

import flixel.FlxObject;
import melee.weapons.Weapon;
import melee.enemies.Enemy;
import melee.enemies.Devil;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
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

		FlxG.overlap(this.player.weaponManager.attacks, this.enemies, (attack:Weapon, enemy:Enemy) -> {
			if (enemy.currentState != Hit) enemy.hit(attack);
		});

		this.enemies.update(elapsed);

		FlxG.overlap(this.enemies, this.enemies, (enemy:Enemy, other:Enemy) -> {
			FlxObject.separate(enemy, other);
		}, (enemy:Enemy, other:Enemy) -> {
			return (enemy.currentState != Hit && other.currentState != Hit);
		});
		FlxG.collide(this.player, this.enemies);
	}

	public function getClosestEnemy():Enemy {
		if (this.enemies.countLiving() <= 0)
		{
			return null;
		}

		var closestEnemy = this.enemies.getFirstAlive();
		var closestDistance = this.player.getPosition().distanceTo(closestEnemy.getPosition());
		for (enemy in this.enemies)
		{
			var distance = this.player.getPosition().distanceTo(enemy.getPosition());
			if (distance < closestDistance)
			{
				closestEnemy = enemy;
				closestDistance = distance;
			}
		}

		return closestEnemy;
	}
}