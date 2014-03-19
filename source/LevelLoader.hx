package;

import openfl.Assets;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.tile.FlxTilemapExt;
import flixel.tile.FlxTilemap;


/**
 * ...
 * @author 
 */
class LevelLoader
{

	static public function loadLevel(state:PlayState, level:String) {
		
		var tmap:TiledMap = new TiledMap("assets/data/"+level+".tmx");
		var backLayer:TiledLayer = tmap.getLayer("back");
		var mainLayer:TiledLayer = tmap.getLayer("main");

		var backset:FlxTilemap = new FlxTilemap();
		backset.loadMap(backLayer.csvData, Assets.getBitmapData("images/tset.png"), 16, 16, 0, 1);
		backset.solid = false;
		state.add(backset);

		state.map = new FlxTilemapExt();
		state.map.loadMap(mainLayer.csvData, Assets.getBitmapData("images/tset.png"), 16, 16, 0, 1);
		state.map.scrollFactor.set(1, 1);
		//state.map.setSlopes([107], [108], [], []);
		//state.map.setClouds([109, 110, 134, 135]);
		state.add(state.map);
		
		var entities:FlxGroup = new FlxGroup();
		
		FlxG.log.add(tmap.getObjectGroup("ennemies").objects.length);
		for (i in tmap.getObjectGroup("ennemies").objects) {
			var flipped:Bool = false;
			if (i.custom.contains("facing") && i.custom.get("facing") == "left")
				flipped = true;
			FlxG.log.add(i.type);
			switch(i.type) {
				case "Met":
					entities.add(new Met(i.x, i.y));
			}
		}
		state.setEnnemies(entities);
		
		}
	
}