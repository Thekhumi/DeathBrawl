package entities;

import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Player1 extends FlxSprite 
{

	public var fsm:FlxFSM<FlxSprite>;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Player1__png, true, 32, 32);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, true);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, false);
		facing = FlxObject.RIGHT;
		
		animation.add("idle", [0,1,2,3,4,0], 3);
		animation.add("walking", [6,7,8,9], 7);
		animation.add("shooting", [10, 11], 5, false);
		animation.add("blocking", [11, 12], 5, false);
		
		fsm = new FlxFSM<FlxSprite>(this);
		fsm.transitions.start(Idle);
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}
	
}

	
	class Idle extends FlxFSMState<FlxSprite>
	{
		override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
		{
			owner.animation.play("idle");
		}
		override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
		{
			owner.velocity.x = owner.velocity.x * 0.5;
			owner.velocity.y = owner.velocity.y * 0.5;
			if(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN)
			{
			if (FlxG.keys.pressed.LEFT)
			{
			owner.facing = FlxObject.LEFT;
			owner.velocity.x = -100;
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
			owner.facing = FlxObject.RIGHT;
			owner.velocity.x = 100;
			}
			else if (FlxG.keys.pressed.UP)
			{
			owner.facing = FlxObject.UP;
			owner.velocity.y = -100; 
			}
			else if (FlxG.keys.pressed.DOWN)
			{
			owner.facing = FlxObject.DOWN;
			owner.velocity.y = 100;
			}
			
			owner.animation.play("walking");
			
			}
			else
			{
				owner.animation.play("idle");
			}
		}
	}