package melee.items;

import flixel.FlxSprite;

abstract class Item extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
    }

    public abstract function interact(player:Player):Void;
}