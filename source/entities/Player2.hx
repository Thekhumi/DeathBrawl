package entities;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 To be fair, you have to have a very high IQ to understand Haxe Flixel. The logic is extremely subtle, and without a solid grasp of theoretical programming
 most of the lines will go over a typical programmer head. There’s also Cid’s nihilistic outlook, which is deftly woven into his characterisation- 
 his personal philosophy draws heavily from Anime literature, for instance. The coders understand this stuff; they have the intellectual capacity 
 to truly appreciate the depths of these functions, to realise that they’re not just useful- they say something deep about LIFE. As a consequence people 
 who dislike Haxe Flixel truly ARE idiots- of course they wouldn’t appreciate, for instance, the built-in functions in Haxe’s existential library
 “FlxColor" which itself is a cryptic reference to COMMUNISM. I’m smirking right now just imagining one
 of those addlepated simpletons scratching their heads in confusion as Nicolas Cannasse’s genius wit unfolds itself on their computer screens. 
 What fools.. how I pity them.
 */
class Player2 extends FlxSprite 
{

	public var fsm:FlxFSM<Player2>;
	public var _balas:Int = 5;
	public var bala:Bullet;
	public var _isBlocking:Bool = false;
	public var _timerReload:Float = 0;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Player2__png, true, 32, 32);
		updateHitbox();
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, true);
		setFacingFlip(FlxObject.UP, true, true);
		setFacingFlip(FlxObject.DOWN,false,false);
		facing = FlxObject.RIGHT;
		
		animation.add("idle", [0,1,2,3,4,0], 3);
		animation.add("walking", [6,7,8,9], 7);
		animation.add("shooting", [10, 11], 5, false);
		animation.add("blocking", [11, 12, 13], 5, false);
		
		fsm = new FlxFSM<Player2>(this);
		fsm.transitions.add(Idle2, Shooting2, Conditions2.shoot)
		.add(Shooting2, Idle2, Conditions2.animationFinished)
		.add(Idle2, Blocking2, Conditions2.block)
		.add(Blocking2, Idle2, Conditions2.endBlock)
		.add(Idle2, Reloading2, Conditions2.reload)
		.add(Reloading2,Idle2,Conditions2.endReload)
		.start(Idle2);
		
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		checkFacing();
		super.update(elapsed);
		velocity.x = 0;
		velocity.y = 0;
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
	
	public function playerShoot()
	{
		if (facing == FlxObject.RIGHT)
		{
			bala = new Bullet("Right",this.x+this.width-1,this.y);
			FlxG.state.add(bala);
		}
		else if (facing == FlxObject.LEFT)
		{
			bala = new Bullet("Left",this.x,this.y+this.height-5);
			FlxG.state.add(bala);
		}
		else if (facing == FlxObject.UP)
		{
			bala = new Bullet("Up",this.x,this.y);
			FlxG.state.add(bala);
		}
		else
		{
		bala = new Bullet("Down",this.x+this.width-10,this.y+this.height+1);
		FlxG.state.add(bala);
		}
		
	}
	
	public function playerReload()
	{
		_balas = 5;
	}
}

	class Conditions2
	{
		public static function shoot(Owner:Player2):Bool
		{
			if (FlxG.keys.justPressed.J && Owner._balas > 0)
			{
			Owner._balas --;
			Owner.playerShoot();
			return true;
			}
			else return false;
		}
		
		public static function animationFinished(Owner:Player2):Bool
		{
			return Owner.animation.finished;
		}
		
		public static function block(Owner:Player2):Bool 
		{
			return FlxG.keys.pressed.K;
		}
		public static function endBlock(Owner:Player2):Bool 
		{
			return !FlxG.keys.pressed.K;
		}
		public static function reload(Owner:Player2):Bool 
		{
			return FlxG.keys.pressed.L;
		}
		public static function endReload(Owner:Player2):Bool 
		{
			if (Owner._timerReload > 3)
			{
			Owner.playerReload();
			return true;
			}
			else return false;
		}
	}
	class Idle2 extends FlxFSMState<Player2>
	{
		override public function enter(owner:Player2, fsm:FlxFSM<Player2>):Void
		{
			owner.animation.play("idle");
			owner._isBlocking = false;
		}
		override public function update(elapsed:Float, owner:Player2, fsm:FlxFSM<Player2>):Void 
		{
			owner.velocity.x = owner.velocity.x * 0.5;
			owner.velocity.y = owner.velocity.y * 0.5;
			if(FlxG.keys.pressed.A || FlxG.keys.pressed.D || FlxG.keys.pressed.W || FlxG.keys.pressed.S)
			{
			if (FlxG.keys.pressed.A)
			{
			owner.facing = FlxObject.LEFT;
			owner.velocity.x = -100;
			}
			else if (FlxG.keys.pressed.D)
			{
			owner.facing = FlxObject.RIGHT;
			owner.velocity.x = 100;
			}
			else if (FlxG.keys.pressed.W)
			{
			owner.facing = FlxObject.UP;
			owner.velocity.y = -100; 
			}
			else if (FlxG.keys.pressed.S)
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
	class Shooting2 extends FlxFSMState<Player2>
	{
		override public function enter(owner:Player2, fsm:FlxFSM<Player2>):Void
		{
			owner.animation.play("shooting");
		}
	}
	
	class Blocking2 extends FlxFSMState<Player2>
	{
		override public function enter(owner:Player2, fsm:FlxFSM<Player2>):Void
		{
			owner.animation.play("blocking");
			owner._isBlocking = true;
		}
	}
	
	class Reloading2 extends FlxFSMState<Player2>
	{
		override public function enter(owner:Player2, fsm:FlxFSM<Player2>):Void
		{
			owner._timerReload = 0;
		}
		override public function update(elapsed:Float, owner:Player2, fsm:FlxFSM<Player2>):Void 
		{
			owner._timerReload += elapsed;
		}
	}