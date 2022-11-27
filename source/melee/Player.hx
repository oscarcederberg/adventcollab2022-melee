package melee;

import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import melee.weapons.WeaponManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

enum PlayerState {
	IDLE;
	WALKING;
}

class Player extends FlxSprite {
	public static inline final SPEED_WALK:Float = 24;

	public var currentState:PlayerState;
	public var prevState:PlayerState;
	public var invincible:Bool;
	public var weaponManager:WeaponManager;

	public var maxHealth:Float;
	public var moveSpeed:Float;

	public var healthBar:FlxBar;

	var showBar:Bool;
	var barTimer:FlxTimer;

	public function new(x:Float, y:Float) {
		super(x, y);

		this.maxHealth = 100;
		this.health = this.maxHealth;
		this.currentState = IDLE;
		this.prevState = IDLE;
		this.invincible = false;
		this.weaponManager = new WeaponManager(this);

		this.moveSpeed = SPEED_WALK;
		this.facing = LEFT;
		this.immovable = true;

		this.healthBar = new FlxBar(this.x, this.y + 40, LEFT_TO_RIGHT, 32, 4, this, "health");
		this.healthBar.createFilledBar(FlxColor.BLACK, FlxColor.RED);
		this.showBar = false;
		this.barTimer = new FlxTimer();

		loadGraphic("assets/images/knose.png");
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setGraphicSize(2 * Std.int(this.width), 2 * Std.int(this.height));
		updateHitbox();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		this.weaponManager.update(elapsed);
		handleHealthBar();
		this.healthBar.update(elapsed);

		handleInput();
		animate(this.prevState, this.currentState);
	}

	public function hit(damage:Float) {
		this.health -= damage;
		new FlxTimer().start(0.75, _ -> {
			recover();
		});
		FlxFlicker.flicker(this, 0.75);
		this.invincible = true;
	}

	public function recover() {
		this.invincible = false;
	}

	public function handleHealthBar() {
		this.healthBar.setPosition(this.x, this.y + 40);

		if (this.health < this.maxHealth) {
			this.showBar = true;
		} else if (this.health == this.maxHealth && !this.barTimer.active) {
			this.barTimer.start(4, _ -> {
				if (this.health == this.maxHealth) {
					this.showBar = false;
				}
			});
		}

		this.healthBar.visible = this.showBar;
	}

	public function handleInput() {
		var _up:Bool = Controls.pressed.UP;
		var _down:Bool = Controls.pressed.DOWN;
		var _left:Bool = Controls.pressed.LEFT;
		var _right:Bool = Controls.pressed.RIGHT;

		if (_up && _down) {
			_up = _down = false;
		}
		if (_left && _right) {
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
		this.currentState = (dx != 0 || dy != 0) ? WALKING : IDLE;
	}

	public function animate(prev:PlayerState, current:PlayerState) {
		var wiggleDuration = 0.5;
		var bounceDuration = 0.25;
		var wiggleAngle = 20;
		var bounceLength = 4;

		if (prev == IDLE) {
			if (current == WALKING) {
				var from = this.facing == LEFT ? -wiggleAngle : wiggleAngle;
				var to = -from;

				FlxTween.cancelTweensOf(this);

				FlxTween.angle(this, this.angle, to, wiggleDuration / 2, {
					ease: FlxEase.quadInOut,
					onComplete: tween -> {
						FlxTween.angle(this, to, from, wiggleDuration, {
							type: FlxTweenType.PINGPONG,
							ease: FlxEase.quadInOut
						});
					}
				});

				// NOTE: hardcoded offset
				FlxTween.tween(this, {"offset.y": -8 - bounceLength}, bounceDuration / 2, {
					ease: FlxEase.cubeInOut,
					onComplete: tween -> {
						FlxTween.tween(this, {"offset.y": -8 + bounceLength}, bounceDuration, {
							type: FlxTweenType.PINGPONG,
							ease: FlxEase.cubeInOut
						});
					}
				});
			}
		} else if (prev == WALKING) {
			if (current == IDLE) {
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
