package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;


class Bullet extends FlxSprite 
{

	private var contador:Float = 0;
	public function new(facingDirection:String, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Bullet__png, true, 10, 6);
		updateHitbox();
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, true);
		setFacingFlip(FlxObject.UP, true, true);
		setFacingFlip(FlxObject.DOWN,false,false);
		if (facingDirection == "Right")
		{
		velocity.x = 300;
		facing = FlxObject.RIGHT;
		}
		else if (facingDirection == "Left")
		{
		velocity.x = -300;
		facing = FlxObject.LEFT;
		}
		else if (facingDirection == "Up")
		{
		velocity.y = -300;
		facing = FlxObject.UP;
		}
		else
		{
		velocity.y = 300;
		facing = FlxObject.DOWN;
		}
		checkFacing();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		contador + elapsed;
		if (contador > 10)
		{
			this.destroy();
		}
	}
	
	function checkFacing() 
	{
		if (facing == FlxObject.UP || facing == FlxObject.DOWN)
		{
			set_angle(90);
		}
		else
		set_angle(0);
	}
}