package melee.enemies;

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
    var moveSpeed:Float;
    var wiggleDuration:Float;
    var bounceDuration:Float;
    var wiggleAngle:Float;
    var bounceLength:Float;

    var state:PlayState;
    var currentState:EnemyState;
    var prevState:EnemyState;

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
        animate();
	}

    public function hit(weapon:Weapon)
    {
        this.prevState = this.currentState;
        this.currentState = Hit;

        this.velocity = 48 * weapon.direction;
        this.acceleration = -16 * weapon.direction;
        new FlxTimer().start(0.75, recover);
        FlxFlicker.flicker(this, 0.75);
    }

    public function recover(timer:FlxTimer)
    {
        this.prevState = this.currentState;
        this.currentState = Walking;
        this.velocity.set(0, 0);
        this.acceleration.set(0, 0);
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
    }

    public function animate() {

        this.facing = this.velocity.x < 0 ? LEFT : this.facing;
        this.facing = this.velocity.x > 0 ? RIGHT : this.facing;

        if (this.prevState == Idle)
        {
            if (this.currentState == Walking)
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
        } else if (this.prevState == Walking) {
            if (this.currentState == Idle)
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
        }
    }
}

