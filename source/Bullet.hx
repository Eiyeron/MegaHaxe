package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Assets;
/**
 * ...
 * @author 
 */
class Bullet extends FlxSprite
{
	private static inline var VELOCITY:Float = 200;
	
	public function new(x:Float, y:Float, flipped:Bool) 
	{
			super(x, y);
			this.loadGraphic(Assets.getBitmapData("images/bullet.png"), false, true, 8, 6);
			if (flipped)
				set_facing(FlxObject.LEFT);

			this.velocity.x = flipped ? -VELOCITY : VELOCITY;
	}
	
	public override function update() {
		super.update();
		if (!this.isOnScreen(FlxG.camera)) {
			this.destroy();
		}
	}
	
	public function deviate():Void {
		this.solid = false;
		this.velocity.x = VELOCITY*Math.sin(22.5);
		this.velocity.y = VELOCITY*Math.cos(22.5);
	}
	
}