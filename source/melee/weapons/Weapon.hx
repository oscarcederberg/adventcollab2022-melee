package melee.weapons;

import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import melee.states.PlayState;
import melee.enemies.Enemy;
import flixel.FlxSprite;

class Weapon extends FlxSprite {
    public var direction:FlxPoint;
    public var damage:Float;

    var state:PlayState;
    var parent:Player;
    var lifetime:Float;

    public function new(parent:Player)
    {
        super(0, 0);

        this.damage = 3;

        this.state = cast (Global.state, PlayState);
        this.parent = parent;
        this.lifetime = 0.4;

        loadGraphic("assets/images/weapons/sword/slash.png", 4, 8);
        setGraphicSize(2 * 4, 2 * 8);
        updateHitbox();

        attack();
        new FlxTimer().start(lifetime, _ -> kill());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        var position = this.parent.getMidpoint().addPoint(16 * direction).addPoint(this.offset);
        this.setPosition(position.x, position.y);
    }

    public function attack()
    {
        var enemy:Enemy = this.state.getClosestEnemy();

        if (enemy != null)
        {
            this.direction = enemy.getPosition().subtractPoint(this.parent.getPosition()).normalize();
        }
        else
        {
            this.direction = this.parent.facing == LEFT ? new FlxPoint(-1, 0) : new FlxPoint(1, 0);
        }
        this.angle = new FlxPoint().degreesTo(direction) + 90;

        var position = this.parent.getMidpoint().addPoint(16 * direction).addPoint(this.offset);
        this.setPosition(position.x, position.y);
    }
}