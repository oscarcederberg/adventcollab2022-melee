package melee;

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

    var state:PlayerState;
    var moveSpeed:Int;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.state = Idle;
        this.facing = LEFT;
        this.moveSpeed = SPEED_WALK;

        loadGraphic("assets/images/knose.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
    }

    override public function update(elapsed:Float):Void
	{
		handleInput();

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

        this.state = (dx != 0 || dy != 0) ? Walking : Idle;
        this.facing = (dx == -1) ? LEFT : this.facing;
        this.facing = (dx == 1) ? RIGHT : this.facing;
    }
}