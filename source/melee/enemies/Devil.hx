package melee.enemies;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Devil extends Enemy {
	public function new(x:Float, y:Float, itemToDrop:String) {
		super(x, y, itemToDrop);

		this.health = 10;
		this.damage = 5;
		this.moveSpeed = 16;
		this.wiggleDuration = 0.3;
		this.bounceDuration = 0.15;
		this.wiggleAngle = 15;
		this.bounceLength = 3;

		loadGraphic("assets/images/enemies/devil.png");
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setGraphicSize(2 * Std.int(this.width), 2 * Std.int(this.height));
		updateHitbox();
	}
}
