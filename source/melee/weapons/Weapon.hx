package melee.weapons;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
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
    var startDirection:FlxPoint;
    var rotation:Float;

    public function new(parent:Player)
    {
        super(0, 0);

        this.damage = 3;

        this.state = cast (Global.state, PlayState);
        this.parent = parent;
        this.lifetime = 0.6;
        this.rotation = 45;

        loadGraphic("assets/images/weapons/sword/slash.png");
        setGraphicSize(2 * Std.int(this.width), 2 * Std.int(this.height));
        updateHitbox();

        attack();
        new FlxTimer().start(lifetime, _ -> kill());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        this.direction.set(startDirection.x, startDirection.y);
        this.direction.rotateByDegrees(this.rotation);
        this.angle = new FlxPoint().degreesTo(direction);
        var position = this.parent.getMidpoint().addPoint(32 * direction).addPoint(this.offset);
        this.setPosition(position.x, position.y);
    }

    public function attack()
    {
        var enemy:Enemy = this.state.getClosestEnemy();

        if (enemy != null)
        {
            this.startDirection = enemy.getPosition().subtractPoint(parent.getPosition()).normalize();
        }
        else
        {
            this.startDirection = parent.facing == LEFT ? new FlxPoint(-1, 0) : new FlxPoint(1, 0);
        }
        this.direction = new FlxPoint(startDirection.x, startDirection.y);
        this.direction.rotateByDegrees(this.rotation);
        this.angle = new FlxPoint().degreesTo(direction);
        new FlxTimer().start(0.1, _ -> FlxTween.tween(this, {"rotation": -45}, lifetime - 0.2, {
                ease: FlxEase.backInOut
            })
        );

        var position = this.parent.getMidpoint().addPoint(32 * direction).addPoint(offset);
        this.setPosition(position.x, position.y);
    }
}