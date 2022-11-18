package melee.states;

import melee.enemies.EnemyManager;
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
	public var enemyManager:EnemyManager;
	public var random:FlxRandom;

	//This is the Start function
	override function create()
	{
		super.create();

		this.random = new FlxRandom();

		this.player = new Player(0, 0);
		Global.screenCenter(player);
		add(player);

		this.enemyManager = new EnemyManager(this);
		add(this.enemyManager.enemies);
	}

	/** This is where your game updates each frame */
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		this.player.update(elapsed);
		this.enemyManager.update(elapsed);

		FlxG.overlap(this.player.weaponManager.attacks, this.enemyManager.enemies, (attack:Weapon, enemy:Enemy) -> {
			if (enemy.currentState != Hit) enemy.hit(attack);
		});

		FlxG.overlap(this.enemyManager.enemies, this.enemyManager.enemies, (enemy:Enemy, other:Enemy) -> {
			FlxObject.separate(enemy, other);
		}, (enemy:Enemy, other:Enemy) -> {
			return (enemy.currentState != Hit && other.currentState != Hit);
		});

		FlxG.overlap(this.player, this.enemyManager.enemies, (player:Player, other:Enemy) -> {
			if (!player.invincible && other.currentState != Hit) {
				player.hit(other.damage);
				FlxObject.separate(player, other);
			} else if (other.currentState != Hit) {
				FlxObject.separate(player, other);
			}
		});
	}

	public function getClosestEnemy():Enemy {
			return this.enemyManager.getClosestEnemy(player.getPosition());
	}
}