package melee.enemies;

import flixel.util.FlxTimer;

enum SpawnMode {
	SCATTERED;
	BUBBLE(amount:Int);
	BOSS;
}

class SpawnInfo {
	public var active:Bool;
	public var enemy:String;
	public var freq:Float;
	public var mode:SpawnMode;
	public var fromTime:Int;
	public var toTime:Int;
	public var max:Int;
	public var count:Int;
	public var timer:FlxTimer;

	public function new(enemy:String, freq:Float, mode:SpawnMode, fromTime:Int, toTime:Int, max:Int) {
		this.active = false;
		this.enemy = enemy;
		this.freq = freq;
		this.mode = mode;
		this.fromTime = fromTime;
		this.toTime = toTime;
		this.max = max;
		this.count = 0;
		this.timer = new FlxTimer();
	}

	public function isTime(tick:Float) {
		return tick >= fromTime && tick < toTime;
	}
}
