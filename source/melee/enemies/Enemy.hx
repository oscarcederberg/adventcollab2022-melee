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

abstract class Enemy extends FlxSprite
{
    var parent:PlayState;
    var currentState:EnemyState;
    var prevState:EnemyState;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.parent = cast (Global.state, PlayState);
        this.currentState = Idle;
        this.prevState = Idle;
        this.facing = LEFT;
    }

    override public function update(elapsed:Float):Void
	{
		handleLogic();
        animate();

		super.update(elapsed);
	}

    public abstract function handleLogic():Void;

    public abstract function animate():Void;
}

