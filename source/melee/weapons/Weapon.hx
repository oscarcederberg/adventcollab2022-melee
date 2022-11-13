package melee.weapons;

import flixel.math.FlxPoint;
import melee.states.PlayState;
import melee.enemies.Enemy;
import flixel.FlxSprite;

class Weapon extends FlxSprite {
    var state:PlayState;
    var parent:Player;
    var weaponSpeed:Float;

    public function new(parent:Player)
    {
        super(0, 0);

        this.state = cast (Global.state, PlayState);
        this.parent = parent;
        this.weaponSpeed = 0.75;
        loadGraphic("assets/images/weapons/sword/slash.png", 4, 8);
        setGraphicSize(2 * 4, 2 * 8);
        updateHitbox();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        attack();
    }

    public function attack()
    {
        var enemy:Enemy = this.state.getClosestEnemy();
        var direction:FlxPoint;
        var angle:Float;

        if (enemy != null)
        {
            direction = enemy.getPosition().subtractPoint(this.parent.getPosition()).normalize();
        }
        else
        {
            direction = this.parent.facing == LEFT ? new FlxPoint(-1, 0) : new FlxPoint(1, 0);
        }
        angle = new FlxPoint().degreesTo(direction) + 90;

        var position = this.parent.getMidpoint().addPoint(16 * direction).addPoint(this.offset);
        this.setPosition(position.x, position.y);
        this.angle = angle;
    }
}