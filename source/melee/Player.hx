package melee;

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

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.currentState = Idle;
        this.prevState = Idle;
        this.facing = LEFT;
        this.moveSpeed = SPEED_WALK;

        loadGraphic("assets/images/knose.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
        updateHitbox();
    }

    override public function update(elapsed:Float):Void
	{
		handleInput();
        animate();

		super.update(elapsed);
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
        if (this.prevState == Idle)
        {
            if (this.currentState == Walking)
            {
                var from = this.facing == LEFT ? -20 : 20;
                var to = -from;
                var duration = Math.abs(this.angle) == 0 ? 0.25 : 0.25 * Math.abs(this.angle) / 20;
                FlxTween.cancelTweensOf(this);
                FlxTween.angle(this, this.angle, to, duration, {
                    ease: FlxEase.bounceInOut, onComplete: tween -> {
                            FlxTween.angle(this, to, from, 0.5, {
                                type: FlxTweenType.PINGPONG, ease: FlxEase.bounceInOut
                            });
                        }
                });
            }
        } else if (this.prevState == Walking) {
            if (this.currentState == Idle)
            {
                var duration = Math.abs(this.angle) == 0 ? 0.25 : 0.25 * Math.abs(this.angle) / 20;
                FlxTween.cancelTweensOf(this);
                FlxTween.angle(this, this.angle, 0, duration, {
                    ease: FlxEase.bounceInOut
                });
            }
        }
    }
}