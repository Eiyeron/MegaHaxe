package ;
import flixel.animation.FlxAnimation;
/**
 * ...
 * @author 
 */
class MegamanRunAnimation extends FlxAnimation
{

	override public function new(Parent:FlxAnimationController, Name:String, Frames:Array<Int>, FrameRate:Int = 0, Looped:Bool = true)
	{
			super(Parent, Name, Frames, FrameRate, Looped);
	}
	override public function update():Void
	{
		if (delay > 0 && (looped || !finished) && !paused)
		{
			_frameTimer += FlxG.elapsed;
			while (_frameTimer > delay)
			{
				_frameTimer = _frameTimer - delay;
				if (looped && (curFrame == numFrames - 1))
				{
					curFrame = 1;
				}
				else
				{
					curFrame++;
				}
			}
		}
	}	
}