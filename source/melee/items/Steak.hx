package melee.items;

class Steak extends Item {
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic("assets/images/items/steak.png");
		setGraphicSize(2 * Std.int(this.width), 2 * Std.int(this.height));
		updateHitbox();
	}

	public function interact(player:Player) {
		player.health += 0.1 * player.maxHealth;
		player.health = Math.min(player.health, player.maxHealth);
		kill();
	}
}
