package melee.enemies;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Devil extends Enemy
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        this.moveSpeed = 16;
        this.wiggleDuration = 0.3;
        this.bounceDuration = 0.15;
        this.wiggleAngle = 15;
        this.bounceLength = 3;

        loadGraphic("assets/images/enemies/devil.png", 16, 16);
        setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
        setGraphicSize(2 * 16, 2 * 16);
        updateHitbox();
    }

}

