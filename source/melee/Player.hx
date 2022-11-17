package melee;

import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
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

    public var currentState:PlayerState;
    public var prevState:PlayerState;
    public var invincible:Bool;
    public var weaponManager:WeaponManager;

    var moveSpeed:Int;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.health = 100;
        this.currentState = Idle;
        this.prevState = Idle;
        this.invincible = false;
        this.weaponManager = new WeaponManager(this);
        this.moveSpeed = SPEED_WALK;

        this.facing = LEFT;
        this.immovable = true;

        loadGraphic("assets/images/knose.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
        updateHitbox();
    }

    override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        this.weaponManager.update(elapsed);

        handleInput();
        animate(this.prevState, this.currentState);
	}

    public function hit(damage:Float)
    {
        this.health -= damage;

        new FlxTimer().start(0.75, _ -> {
                recover();
        });
        FlxFlicker.flicker(this, 0.75);
        this.invincible = true;
    }

    public function recover()
    {
        this.invincible = false;
    }

    public function handleInput()
    {
        var _up:Bool = Controls.pressed.UP;
		var _down:Bool = Controls.pressed.DOWN;
		var _left:Bool = Controls.pressed.LEFT;
		var _right:Bool = Controls.pressed.RIGHT;

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

    public function animate(prev:PlayerState, current:PlayerState)
    {
        var wiggleDuration = 0.5;
        var bounceDuration = 0.25;
        var wiggleAngle = 20;
        var bounceLength = 4;

        if (prev == Idle)
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
        }
    }
}