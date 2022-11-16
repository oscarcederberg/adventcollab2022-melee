package melee.enemies;

import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import melee.weapons.Weapon;
import melee.states.PlayState;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

enum EnemyState
{
	Idle;
	Walking;
    Hit;
}

abstract class Enemy extends FlxSprite
{
    public var currentState:EnemyState;
    public var prevState:EnemyState;

    var moveSpeed:Float;
    var wiggleDuration:Float;
    var bounceDuration:Float;
    var wiggleAngle:Float;
    var bounceLength:Float;

    var state:PlayState;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.state = cast (Global.state, PlayState);
        this.currentState = Idle;
        this.prevState = Idle;
        this.facing = LEFT;
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        handleLogic();
	}

    public function hit(weapon:Weapon)
    {
        this.health -= weapon.damage;
        this.velocity = 48 * weapon.direction;
        this.acceleration = -16 * weapon.direction;
        this.color = FlxColor.RED;

        new FlxTimer().start(0.75, _ -> {
            if (this.health <= 0)
                kill();
            else
                recover();
        });
        FlxFlicker.flicker(this, 0.75);

        this.prevState = this.currentState;
        this.currentState = Hit;
        animate(Walking, Hit);
    }

    public function recover()
    {
        this.velocity.set(0, 0);
        this.acceleration.set(0, 0);
        this.color = FlxColor.WHITE;

        this.prevState = Hit;
        this.currentState = Walking;
        animate(Hit, Walking);
    }

    public function handleLogic()
    {
        if (this.currentState == Hit) {
            return;
        }

        var playerPosition = this.state.player.getPosition();
        var direction = playerPosition.subtractPoint(getPosition()).normalize();

        this.velocity = this.moveSpeed * direction;

        this.prevState = this.currentState;
        this.currentState = Walking;
        animate(this.prevState, this.currentState);
    }

    public function animate(prev:EnemyState, current:EnemyState) {
        if (current == Walking)
        {
            this.facing = this.velocity.x < 0 ? LEFT : this.facing;
            this.facing = this.velocity.x > 0 ? RIGHT : this.facing;
        }

        if (prev == Idle || prev == Hit)
        {
            if (current == Walking)
            {
                var from = this.facing == LEFT ? -wiggleAngle : wiggleAngle;
                var to = -from;

                FlxTween.cancelTweensOf(this);

                FlxTween.angle(this, this.angle, to, wiggleDuration / 2, {
                    ease: FlxEase.quadInOut, onComplete: tween -> {
                        FlxTween.angle(this, to, from, wiggleDuration, {
                            type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut
                        });
                    }
                });

                // NOTE: hardcoded offset
                FlxTween.tween(this, {"offset.y": -8 - bounceLength}, bounceDuration / 2, {
                    ease: FlxEase.cubeInOut, onComplete: tween -> {
                        FlxTween.tween(this, {"offset.y": -8 + bounceLength}, bounceDuration, {
                            type: FlxTweenType.PINGPONG, ease: FlxEase.cubeInOut
                        });
                    }
                });
            }
        } else if (prev == Walking) {
            if (current == Idle)
            {
                FlxTween.cancelTweensOf(this);

                FlxTween.angle(this, this.angle, 0, wiggleDuration / 2, {
                    ease: FlxEase.quadOut
                });

                // NOTE: hardcoded offset
                FlxTween.tween(this, {"offset.y": -8}, bounceDuration / 2, {
                    ease: FlxEase.cubeOut
                });
            }
            else if (current == Hit)
            {
                var to = this.facing == LEFT ? -2 * wiggleAngle : 2 * wiggleAngle;
                if (this.health <= 0) to = 2 * to;

                FlxTween.cancelTweensOf(this);

                FlxTween.angle(this, this.angle, to, wiggleDuration, {
                    ease: FlxEase.quadInOut, onComplete: tween -> {
                        if (health > 0) FlxTween.angle(this, to, 0, wiggleDuration, {
                            ease: FlxEase.quadInOut
                        });
                    }
                });
            }
        }
    }
}

