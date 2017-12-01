package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;


class Bullet extends FlxSprite 
{

	private var contador:Float = 0;
	private var _trail:FlxTrail;
	private var _balasRef:FlxTypedGroup<Bullet>;
	public function new(_balas:FlxTypedGroup<Bullet>,facingDirection:String, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Bullet__png, true, 10, 6);
		_balasRef = _balas;
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
		updateHitbox();
		_trail = new FlxTrail(this, AssetPaths.Bullet__png, 5);
		FlxG.state.add(_trail);
		_trail.visible = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		loop();
		contador += elapsed;
		if (contador > 8)
		{
			this.destroy();
		}
	}
	

	
	override public function destroy():Void 
	{
		_trail.visible = false;
		_trail.destroy();
		super.destroy();
	}
	
	function loop() 
	{
		if (y < 0)
		this.y = 511;
		else if (y > 512)
		this.y = 0;
		else if (x > 512)
		this.x = 0;
		else if (x < 0)
		this.x = 512;
	}
	
	function checkFacing() 
	{
		if (facing == FlxObject.UP)
		{
			set_angle(-90);
		}
		else if (facing == FlxObject.DOWN)
		{
			set_angle(90);
		}
		else if(facing == FlxObject.LEFT)
		set_angle(180);
	}
	
}