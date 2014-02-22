package;

import flixel.group.FlxGroup;
import openfl.Assets;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.ui.FlxBar;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var player:Megaman;
	private var bar:FlxBar;
	public var map:FlxTilemap;
	
	private var ennemyBullets:FlxGroup;
	private var playerBullets:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{	
		this.set_bgColor(0x00000000);

		LevelLoader.loadLevel(this, "level");
		
		player = new Megaman();		
		this.add(player);
		
		ennemyBullets = new FlxGroup();
		add(ennemyBullets);
		playerBullets = new FlxGroup();
		add(playerBullets);
		
		bar = new FlxBar(16, 16, FlxBar.FILL_BOTTOM_TO_TOP, 8, 56, player, "health", 0, 27);
		bar.createImageBar(null, Assets.getBitmapData("images/health.png"));
		bar.scrollFactor.set(0, 0);
		this.add(bar);
		
		FlxG.worldBounds.set(0, 0, map.width - (map.width / map.widthInTiles), map.height - (map.height / map.heightInTiles));
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.bounds = new FlxRect(0, 0, FlxG.worldBounds.width, FlxG.worldBounds.height);
		super.create();
	}
	
	public function addEnnemyBullet(bullet:Bullet):Void {
		ennemyBullets.add(bullet);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		player.destroy();
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		FlxG.overlap(player, ennemyBullets, player.hit);
		FlxG.collide(player, map);
	}	
}