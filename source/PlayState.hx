package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var coins:FlxTypedGroup<Coin>;

	override public function create()
	{
		super.create();
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "Walls");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		player = new Player();
		FlxG.camera.follow(player, TOPDOWN, 1);
		map.loadEntities(placeEntities, "Entities");
		add(player);
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "Player")
		{
			player.setPosition(entity.x, entity.y);
		}
		else if (entity.name == "Coin")
		{
			coins.add(new Coin(entity.x + 4, entity.y + 4));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, coins, playerTouchCoin);
	}

	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
		}
	}
}
