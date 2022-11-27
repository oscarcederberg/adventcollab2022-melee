package melee.states;

import flixel.util.FlxStringUtil;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import melee.items.*;
import melee.enemies.EnemyManager;
import flixel.FlxObject;
import melee.weapons.Weapon;
import melee.enemies.Enemy;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxState;

/**
 * PlayState.hx is where Advent will start to access your game,
 * if you would like to add a menu to your game contact George!
**/
class PlayState extends FlxState {
	// Initialize Variables Here
	public var player:Player;
	public var enemyManager:EnemyManager;
	public var items:FlxTypedGroup<Item>;
	public var random:FlxRandom;

	var time:Float;
	var timerText:FlxText;
	var tick:Float = 0;

	// This is the Start function
	override function create() {
		super.create();

		this.random = new FlxRandom();
		this.player = new Player(0, 0);
		Global.screenCenter(player);
		this.enemyManager = new EnemyManager(this);
		this.items = new FlxTypedGroup<Item>();
		this.time = 30 * 60;
		this.timerText = new FlxText(0, 0, 0, "30:00", 16);
		this.timerText.autoSize = false;
		this.timerText.alignment = CENTER;
		Global.screenCenterX(this.timerText);
		this.timerText.scrollFactor.set(0, 0);

		add(items);
		add(enemyManager.enemies);
		add(player);
		add(player.weaponManager.attacks);
		add(player.healthBar);
		add(timerText);

		FlxG.camera.follow(player, TOPDOWN_TIGHT, 0.2);
	}

	/** This is where your game updates each frame */
	override function update(elapsed:Float) {
		super.update(elapsed);
		this.player.update(elapsed);
		this.enemyManager.update(elapsed);
		FlxG.worldBounds.set(FlxG.camera.scroll.x - FlxG.camera.width / 2, FlxG.camera.scroll.y - FlxG.camera.height / 2, 2 * FlxG.camera.width,
			2 * FlxG.camera.height);

		FlxG.overlap(this.items, this.player, (item:Item, player:Player) -> {
			item.interact(player);
		});

		FlxG.overlap(this.player.weaponManager.attacks, this.enemyManager.enemies, (attack:Weapon, enemy:Enemy) -> {
			if (enemy.currentState != HIT)
				enemy.hit(attack);
		});

		FlxG.overlap(this.enemyManager.enemies, this.enemyManager.enemies, (enemy:Enemy, other:Enemy) -> {
			FlxObject.separate(enemy, other);
		}, (enemy:Enemy, other:Enemy) -> {
			return (enemy.currentState != HIT && other.currentState != HIT);
		});

		FlxG.overlap(this.player, this.enemyManager.enemies, (player:Player, other:Enemy) -> {
			if (!player.invincible && other.currentState != HIT) {
				player.hit(other.damage);
				FlxObject.separate(player, other);
			} else if (other.currentState != HIT) {
				FlxObject.separate(player, other);
			}
		});

		this.timerText.text = FlxStringUtil.formatTime(tick += elapsed);
	}

	public function getClosestEnemy():Enemy {
		return this.enemyManager.getClosestEnemy(player.getPosition());
	}

	public function spawnItem(x:Float, y:Float, itemString:String) {
		var item;
		switch (itemString.toLowerCase()) {
			case "steak":
				item = new Steak(x, y);
			default:
				return;
		}
		this.items.add(item);
	}
}
