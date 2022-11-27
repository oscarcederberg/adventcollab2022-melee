package melee.enemies;

enum SpawnMode {
	SCATTERED;
	BUBBLE;
	BOSS;
}

class SpawnInfo {
	public var enemy:String;
	public var freq:Float;
	public var mode:SpawnMode;
    public var max:Int;
}
