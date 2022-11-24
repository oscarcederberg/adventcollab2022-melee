package melee.items;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

abstract class Item extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        FlxTween.tween(this, {"offset.y": offset.y - 8}, 1, {
            type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut
        });
    }

    public abstract function interact(player:Player):Void;
}