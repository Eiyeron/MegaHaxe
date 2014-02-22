package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.effects.FlxFlicker;

import openfl.Assets;
/**
 * ...
 * @author 
 */

class Megaman extends FlxSprite {

	private static inline var PREWALK_SPEED:Float = 7.5;
	private static inline var WALK_SPEED:Float = 82.5;
	private static inline var WALK_JUMP_SPEED:Float = 78.75;
	private static inline var SLOWING_SPEED:Float = 30;
	
	private static inline var JUMP_SPEED:Float = 292.265625;
	private static inline var JUMP_GRAVITY_SPEED:Float = 15 * 60;
	
	private static inline var preWalkDuration:Float = 7 / 60;
	private static inline var slowingTimeDuration:Float = 2 / 60;
	
	private var lastBlinkTime:Float;
	private var blinking:Bool;
	
	private var justPressedForRunning:Bool;
	private var running:Bool;
	private var runningAnimation:Bool;
	private var runningPressedTime:Float;

	private var slowingDown:Bool;
	private var slowingDownTime:Float;
	
	private var firing:Bool;
	private var firingTime:Float;
	
	private var jumping:Bool;

	private var hurtImmobilily:Bool;
	private var hurtInvicibility:Bool;

	
	public function new() {
		super(0, 100);

		//this.forceComplexRender = true;
		
		this.velocity.y = -JUMP_SPEED;
		this.acceleration.y = JUMP_GRAVITY_SPEED;
		this.health = 27;
		
		maxVelocity.y = 7*60;
		
		lastBlinkTime = 0;
		blinking = false;
		
		justPressedForRunning = false;
		running = false;
		runningAnimation = false;
		runningPressedTime = 0;
		
		slowingDown = false;
		slowingDownTime = 0;
		
		firing = true;
		firingTime = 0;
		
		hurtImmobilily = false;
		hurtInvicibility = false;
		
		this.loadGraphic(Assets.getBitmapData("images/megaman.png"), true, true, 41, 32);
		this.animation.add("stand", [0], 1, false);
		this.animation.add("blink", [1,0], 4, false);
		this.animation.add("standFire", [7], 1, false);

		this.animation.add("jump", [2], 1, false);
		this.animation.add("jumpFire", [9], 1, false);
		
		this.animation.add("firstStep", [3], 1, false);
		this.animation.add("firstStepFire", [7], 1, false);
				
		this.animation.add("run", [5, 4, 6, 4], 10, true);
		this.animation.add("runFire", [12, 11, 13, 11], 10, true);

		this.animation.add("hurt", [10, 14], 10, true);
		
		this.animation.play("stand");
		//FlxG.watch.add(this, "running", "running");
		//FlxG.watch.add(this, "slowingDown", "slowing");
		//FlxG.watch.add(this, "blinking", "blinking");
		//FlxG.watch.add(this, "lastBlinkTime", "lastBlinkTime");
		//FlxG.watch.add(this, "health", "health");
		
		
		width = 20;
		height = 23;
		offset.x = 10;
		offset.y = 8;
	
	}
	
 	public override function update() {				
		if (!hurtImmobilily) {
			manageRunning();
									
			
			if (this.facing == FlxObject.LEFT) velocity.x *= -1;

			if (FlxG.keys.justPressed.UP && isTouching(FlxObject.FLOOR))
				velocity.y = -JUMP_SPEED;
				
			if (velocity.y != 0 || !isTouching(FlxObject.FLOOR))
				jumping = true;
			else
				jumping = false;
			
			
			if (FlxG.keys.justPressed.SPACE) {
				var yOffset:Int = jumping ? 2 : 9;
				
				if(facing == FlxObject.LEFT)
					FlxG.state.add(new Bullet(x - 15, y + yOffset, true));
				else
					FlxG.state.add(new Bullet(x + width + 8, y + yOffset, false));
				firing = true;
				firingTime = 0;
			} else if (firing) {
				firingTime += FlxG.elapsed;
				if (firingTime >= 0.3) {
					firing = false;
					firingTime = 0;
				}
			}
			
		} else {
			velocity.y = 0;
		}
				
		manageAnimations();
		super.update();
	}
	
	private function manageRunning():Void {
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.LEFT) {
			if (!justPressedForRunning) {
				
				justPressedForRunning = true;
			}
			else {
				if(FlxG.keys.pressed.RIGHT)
					set_facing(FlxObject.RIGHT);
				else
					set_facing(FlxObject.LEFT);

				runningPressedTime += FlxG.elapsed;
				running = true;
				
				if (jumping) {
					runningPressedTime = preWalkDuration + 1; // force running after then
					velocity.x = WALK_JUMP_SPEED;
				}
				else {				
					if (runningPressedTime <= preWalkDuration) {
						velocity.x = PREWALK_SPEED;
					}
					else {
						runningAnimation = true;
						velocity.x = WALK_SPEED;
					}
				}
			}

		}
		else {
			justPressedForRunning = false;
			if (velocity.x != 0 && !slowingDown) {
				slowingDown = true;
				slowingDownTime = 0;
			} else if (slowingDown) {
				slowingDownTime += FlxG.elapsed;
				if (slowingDownTime >= slowingTimeDuration) {
					slowingDown = false;
					slowingDownTime = 0;
				}
			} 
			
			running = false;
			runningAnimation = false;
			runningPressedTime = 0;
			velocity.x = slowingDown ? SLOWING_SPEED : 0;
		}
	}
	
	public function hit(me:Megaman, bullet:Bullet):Void {
		if (!hurtInvicibility) {
			push(bullet.x < x ? FlxObject.LEFT : FlxObject.RIGHT);		
			hurt(5);
		}
		bullet.destroy();
	}

	public override function hurt(Damage:Float) {
		super.hurt(Damage);
		hurtImmobilily = true;
		hurtInvicibility = true;
		FlxTimer.start(0.5, outOfImmobility, 1);
		FlxSpriteUtil.flicker(this, 4, 0.04, true, false, outOfInvincibility);
	}
	
	private function push(origin:Int):Void {
		if (origin == FlxObject.LEFT)
			velocity.x = 20;
		else
			velocity.x = 20;
	}
	
	private function manageAnimations():Void {

		if (hurtImmobilily) {
			animation.play("hurt");
			return;
		}
		
		var selectedAnimation:String = "stand";
		
		lastBlinkTime += FlxG.elapsed;
			
		if (FlxRandom.chanceRoll(30) && lastBlinkTime > 5 && !blinking) {			
			blinking = true;
		}
		if (lastBlinkTime >= 5.5) {
			blinking = false;
			lastBlinkTime = 0;
		}
		if (blinking) {
			selectedAnimation = "blink";
		}

		
		if (running) {
			if (runningAnimation) {
				selectedAnimation = "run";
			}
			else {
				selectedAnimation = "firstStep";
			}
		}
		
		if (jumping)
			selectedAnimation = "jump";
		
		if (firing) {
			if(selectedAnimation != "blink")
				selectedAnimation += "Fire";
			else
				selectedAnimation = "standFire";
		}
		animation.play(selectedAnimation);
	}
	
	public function outOfInvincibility(flicker:FlxFlicker):Void {
		hurtInvicibility = false;
	}

	public function outOfImmobility(timer:FlxTimer):Void {
		hurtImmobilily = false;
	}

}