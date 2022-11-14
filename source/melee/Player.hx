package melee;

import melee.weapons.Weapon;
import melee.weapons.WeaponManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

enum PlayerState
{
	Idle;
	Walking;
}

class Player extends FlxSprite
{
    public static inline final SPEED_WALK:Int = 24;

    var currentState:PlayerState;
    var prevState:PlayerState;
    var moveSpeed:Int;
    var weaponManager:WeaponManager;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.currentState = Idle;
        this.prevState = Idle;
        this.facing = LEFT;
        this.moveSpeed = SPEED_WALK;
        this.immovable = true;

        this.weaponManager = new WeaponManager(this);

        loadGraphic("assets/images/knose.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
        updateHitbox();
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        handleInput();
        animate();
        this.weaponManager.update(elapsed);
	}

    public function handleInput()
    {
        var _up:Bool = Controls.pressed.UP;
		var _down:Bool = Controls.pressed.DOWN;
		var _left:Bool = Controls.pressed.LEFT;
		var _right:Bool = Controls.pressed.RIGHT;
		var _action:Bool = Controls.pressed.A;

		if (_up && _down)
		{
			_up = _down = false;
		}
		if (_left && _right)
		{
			_left = _right = false;
		}

        var dx = 0, dy = 0;
        dx = _left ? -1 : dx;
        dx = _right ? 1 : dx;
        dy = _up ? -1 : dy;
        dy = _down ? 1 : dy;

        this.velocity = this.moveSpeed * new FlxPoint(dx, dy).normalize();
        this.facing = (dx == -1) ? LEFT : this.facing;
        this.facing = (dx == 1) ? RIGHT : this.facing;
        this.prevState = currentState;
        this.currentState = (dx != 0 || dy != 0) ? Walking : Idle;
    }

    public function animate()
    {
        var wiggleDuration = 0.5;
        var bounceDuration = 0.25;
        var wiggleAngle = 20;
        var bounceLength = 4;

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