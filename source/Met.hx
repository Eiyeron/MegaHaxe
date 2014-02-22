package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class Met extends FlxSprite
{
	public static inline var BULLET_LOOP:Float = 5;
	public static inline var HIDING_TIME:Float = 2;
	
	private var currentState:PlayState;
		
	private var hidingRequired:Bool;
	private var isHidden:Bool;
	private var willFire:Bool;
	private var isInvicible:Bool;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		hidingRequired = false;
		isHidden = true;
		willFire = false;
		
		currentState = cast(FlxG.state, PlayState);
		loadGraphic(Assets.getBitmapData("images/met.png"), true, true, 18, 19);
		animation.add("hide", [0], 5, false);
		animation.add("show", [2], 1, false);
		animation.add("walk", [2, 3], 5, true);
		animation.play("hide");
		
		FlxG.watch.add(this, "hidingRequired", "hidingRequired");
		FlxG.watch.add(this, "isHidden", "isHidden");
		FlxG.watch.add(this, "willFire", "willFire");
	}
	
	public override function update():Void {
		if (currentState.player.getMidpoint().x < getMidpoint().x)
			this.facing = FlxObject.LEFT;
		else
			this.facing = FlxObject.RIGHT;
		
		if (FlxMath.distanceBetween(this, currentState.player) < 50) {
			hide(null);
		}
		else if (FlxMath.distanceBetween(this, currentState.player) < 120) {
			if ((isHidden || hidingRequired) && !willFire) {
				willFire = true;
				FlxTimer.start(BULLET_LOOP, fire, 1);
			}
		}
		else {
			if (hidingRequired && !willFire) {
				FlxTimer.start(HIDING_TIME, hide, 1);
				hidingRequired = false;
			}
		}
	}
	
	public function hide(timer:FlxTimer):Void {
			animation.play("hide");
			hidingRequired = false;
			isHidden = true;
	}
	
	public function fire(timer:FlxTimer):Void {
			animation.play("show");
			currentState.addEnnemyBullet(new Bullet(x, y + 5, facing == FlxObject.LEFT));
			isHidden = false;
			willFire = false;
			hidingRequired = true;
	}
	
}