package melee.enemies;

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
}

class Enemy extends FlxSprite
{
    public static inline final SPEED_WALK:Int = 16;

    var parent:PlayState;
    var currentState:EnemyState;
    var prevState:EnemyState;
    var moveSpeed:Int;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.parent = cast (Global.state, PlayState);
        this.currentState = Idle;
        this.prevState = Idle;
        this.facing = LEFT;
        this.moveSpeed = SPEED_WALK;

        loadGraphic("assets/images/enemies/devil.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
        updateHitbox();
    }

    override public function update(elapsed:Float):Void
	{
		handleLogic();
        animate();

		super.update(elapsed);
	}

    public function handleLogic()
    {
        var playerPosition = parent.player.getPosition();
        var direction = playerPosition.subtractPoint(getPosition()).normalize();

        this.velocity = this.moveSpeed*direction;
        this.prevState = this.currentState;
        this.currentState = Walking;
    }

    public function animate()
    {
        var wiggleDuration = 0.3;
        var bounceDuration = 0.15;
        var wiggleAngle = 15;
        var bounceLength = 3;

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

