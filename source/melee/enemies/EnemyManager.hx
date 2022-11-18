package melee.enemies;

import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;
import melee.states.PlayState;

class EnemyManager {
    public var enemies:FlxTypedGroup<Enemy>;

    var parent:PlayState;
    var maxSize:Int;
    var spawnRate:Float;

    public function new(parent:PlayState)
    {
        this.parent = parent;
        this.maxSize = 15;
        this.spawnRate = 2;

        this.enemies = new FlxTypedGroup();

		for (i in 0...10)
        {
            spawnEnemy("devil");
        }

        new FlxTimer().start(1 / spawnRate, attemptSpawnEnemy, 0);
    }

	public function update(elapsed:Float)
    {
        this.enemies.update(elapsed);
    }

    public function attemptSpawnEnemy(timer:FlxTimer)
    {
        if (this.enemies.countLiving() > maxSize)
        {
            return;
        }

        spawnEnemy("Devil");
    }

    public function spawnEnemy(enemyType:String)
    {
        var length = parent.random.float(300, 400);
        var angle = parent.random.float(0, 360, [360]);
        var direction = new FlxPoint(length, 0).rotateByDegrees(angle);
        var position = parent.player.getGraphicMidpoint().addPoint(direction);
        var enemy:Enemy;

        switch (enemyType.toLowerCase()) {
            case "devil": enemy = new Devil(position.x, position.y);
            default: return;
        }

        this.enemies.add(enemy);
    }

	public function getClosestEnemy(position:FlxPoint):Enemy {
		if (this.enemies.countLiving() <= 0)
		{
			return null;
		}

		var closestEnemy = this.enemies.getFirstAlive();
		var closestDistance = position.distanceTo(closestEnemy.getPosition());
		for (enemy in this.enemies)
		{
			var distance = position.distanceTo(enemy.getPosition());
			if (distance < closestDistance)
			{
				closestEnemy = enemy;
				closestDistance = distance;
			}
		}

		return closestEnemy;
	}
}