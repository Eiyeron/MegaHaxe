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
	
	private var currentState:PlayState;

	private var isHidden:Bool;
	private var isFiring:Bool;
	
	private var fireTimer:FlxTimer;

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		health = 10;
		immovable = true;
		isHidden = true;
		isFiring = false;

		currentState = cast(FlxG.state, PlayState);
		loadGraphic(Assets.getBitmapData("images/met.png"), true, true, 18, 19);
		animation.add("hide", [0], 5, false);
		animation.add("show", [2], 60, false);
		animation.add("walk", [2, 3], 5, true);
		animation.play("hide");

		this.height = 11;
		this.offset.y = 8;
		
	}
	
	public override function update():Void {
		if (currentState.player.getMidpoint().x < getMidpoint().x)
			this.facing = FlxObject.LEFT;
		else
			this.facing = FlxObject.RIGHT;
		
		var distance:Float = FlxMath.distanceBetween(this, currentState.player);

		if(distance <= 50) {
			// We need to hide
			isHidden = true;
			animation.play("hide");
		} else if(distance <= 150){
			isHidden = false;
			if (!isFiring) {
				FlxTimer.start(1, fire, 0);
				isFiring = true;
			}
		} else {
			isHidden = true;
			animation.play("hide");			
		}

		if (isHidden && height == 19) {
			height = 11;
			offset.y = 8;
			y += 8;
		} else if(!isHidden && height == 11){
			this.height = 19;
			this.offset.y = 0;
			y -= 8;
		}
	}
	
	public function hit(me:Met, bullet:Bullet) {
		if (isHidden)
			bullet.deviate();
		else {
			hurt(3);
			bullet.destroy();
		}
	}

	public override function kill() {
		super.kill();
		if (fireTimer != null) {			
			fireTimer.abort();
			fireTimer.destroy();
		}
	}
	
	public function fire(timer:FlxTimer):Void {
		fireTimer = timer;
		if (FlxMath.distanceBetween(this, currentState.player) > 200 || FlxMath.distanceBetween(this, currentState.player) < 50) {			
			timer.abort();
			isFiring = false;
			return;
		}
		animation.play("show");
		currentState.addEnnemyBullet(new Bullet(x, y, facing == FlxObject.LEFT));
	}
	
}