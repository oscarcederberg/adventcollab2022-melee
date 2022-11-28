package melee.enemies;

import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import melee.states.PlayState;

class EnemyManager {
	public var enemies:FlxTypedGroup<Enemy>;

	var parent:PlayState;
	var spawnInfos:List<SpawnInfo>;

	public function new(parent:PlayState) {
		this.parent = parent;
		this.spawnInfos = new List();

		this.enemies = new FlxTypedGroup();

		this.spawnInfos.add(new SpawnInfo("devil", 2, SCATTERED, 0, 60, 15));
	}

	public function update(elapsed:Float) {
		this.enemies.update(elapsed);

		for (info in this.spawnInfos) {
			if (!info.active && info.isTime(parent.tick)) {
				info.active = true;
				info.timer.start(1 / info.freq, _ -> attemptSpawnEnemy(info), 0);
			} else if (info.active && !info.isTime(parent.tick)) {
				info.active = false;
				info.timer.cancel();
			}
		}
	}

	public function attemptSpawnEnemy(info:SpawnInfo) {
		if (info.count > info.max) {
			return;
		}

		info.count++;

		spawnEnemy(info);
	}

	public function spawnEnemy(info:SpawnInfo) {
		var length = parent.random.float(300, 400);
		var angle = parent.random.float(0, 360);
		var direction = new FlxPoint(length, 0).rotateByDegrees(angle);
		var position = parent.player.getGraphicMidpoint().addPoint(direction);
		var enemy:Enemy;

		switch (info.enemy.toLowerCase()) {
			case "devil":
				enemy = new Devil(position.x, position.y, "steak", info);
			default:
				return;
		}

		this.enemies.add(enemy);
	}

	public function getClosestEnemy(position:FlxPoint):Enemy {
		if (this.enemies.countLiving() <= 0) {
			return null;
		}

		var closestEnemy = this.enemies.getFirstAlive();
		var closestDistance = position.distanceTo(closestEnemy.getPosition());
		this.enemies.forEachAlive(enemy -> {
			var distance = position.distanceTo(enemy.getPosition());
			if (distance < closestDistance) {
				closestEnemy = enemy;
				closestDistance = distance;
			}
		});

		return closestEnemy;
	}
}
