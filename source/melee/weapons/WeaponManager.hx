package melee.weapons;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

class WeaponManager {
	public var attacks:FlxTypedGroup<Weapon>;

	var parent:Player;
	var attackFreq:Float;
	var attackTimer:FlxTimer;

	public function new(parent:Player) {
		this.parent = parent;
		this.attacks = new FlxTypedGroup<Weapon>();
		this.attackFreq = 1;
		this.attackTimer = new FlxTimer();
		this.attackTimer.start(1 / this.attackFreq, beginAttack, 0);
	}

	public function update(elapsed:Float) {
		this.attacks.update(elapsed);
	}

	function beginAttack(timer:FlxTimer) {
		this.attacks.add(new Weapon(this.parent));
	}
}
