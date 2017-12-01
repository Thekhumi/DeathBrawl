package entities;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.group.FlxGroup.FlxTypedGroup;

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
class Player1 extends FlxSprite 
{

	public var fsm:FlxFSM<Player1>;
	public var _balas:Int = 5;
	public var bala:Bullet;
	public var _isBlocking:Bool = false;
	public var _timerReload:Float = 0;
	private var _balasRef:FlxTypedGroup<Bullet>;
	public function new(_balas:FlxTypedGroup<Bullet>, ?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		_balasRef = _balas;
		loadGraphic(AssetPaths.Player1__png, true, 32, 32);
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
		
		fsm = new FlxFSM<Player1>(this);
		fsm.transitions.add(Idle, Shooting, Conditions.shoot)
		.add(Shooting, Idle, Conditions.animationFinished)
		.add(Idle, Blocking, Conditions.block)
		.add(Blocking, Idle, Conditions.endBlock)
		.add(Idle, Reloading, Conditions.reload)
		.add(Reloading,Idle,Conditions.endReload)
		.start(Idle);
		
		FlxG.state.add(_balasRef);
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		checkFacing();
		super.update(elapsed);
		velocity.x = 0;
		velocity.y = 0;
		checkBorders();
	}
	
	function checkBorders() 
	{
		if (this.x < 0)
		this.x = 0;
		else if (this.x > 512 - this.width)
		this.x = 512 - this.width;
		else if (this.y < 0)
		this.y = 0;
		else if (this.y > 511 - this.height)
		this.y = 511 - this.height;
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
			bala = new Bullet(_balasRef,"Right",this.x+5+this.width,this.y);
			_balasRef.add(bala);
		}
		else if (facing == FlxObject.LEFT)
		{
			bala = new Bullet(_balasRef,"Left",this.x-15,this.y+this.height-5);
			_balasRef.add(bala);
		}
		else if (facing == FlxObject.UP)
		{
			bala = new Bullet(_balasRef,"Up",this.x,this.y-10);
			_balasRef.add(bala);
		}
		else
		{
		bala = new Bullet(_balasRef,"Down",this.x+this.width-10,this.y+this.height+5);
			_balasRef.add(bala);
		}
		
	}
	
	public function playerReload()
	{
		_balas = 5;
	}
}

	class Conditions
	{
		public static function shoot(Owner:Player1):Bool
		{
			if (FlxG.keys.justPressed.NUMPADONE && Owner._balas > 0)
			{
			Owner._balas --;
			Owner.playerShoot();
			return true;
			}
			else return false;
		}
		
		public static function animationFinished(Owner:Player1):Bool
		{
			return Owner.animation.finished;
		}
		
		public static function block(Owner:Player1):Bool 
		{
			return FlxG.keys.pressed.NUMPADTWO;
		}
		public static function endBlock(Owner:Player1):Bool 
		{
			return !FlxG.keys.pressed.NUMPADTWO;
		}
		public static function reload(Owner:Player1):Bool 
		{
			return (FlxG.keys.pressed.NUMPADTHREE && Owner._balas < 5);
		}
		public static function endReload(Owner:Player1):Bool 
		{
			if (Owner._timerReload > 3)
			{
			Owner.playerReload();
			return true;
			}
			else return false;
		}
	}
	class Idle extends FlxFSMState<Player1>
	{
		override public function enter(owner:Player1, fsm:FlxFSM<Player1>):Void
		{
			owner.animation.play("idle");
			owner._isBlocking = false;
		}
		override public function update(elapsed:Float, owner:Player1, fsm:FlxFSM<Player1>):Void 
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
	class Shooting extends FlxFSMState<Player1>
	{
		override public function enter(owner:Player1, fsm:FlxFSM<Player1>):Void
		{
			owner.animation.play("shooting");
		}
	}
	
	class Blocking extends FlxFSMState<Player1>
	{
		override public function enter(owner:Player1, fsm:FlxFSM<Player1>):Void
		{
			owner.animation.play("blocking");
			owner._isBlocking = true;
		}
	}
	
	class Reloading extends FlxFSMState<Player1>
	{
		override public function enter(owner:Player1, fsm:FlxFSM<Player1>):Void
		{
			owner._timerReload = 0;
		}
		override public function update(elapsed:Float, owner:Player1, fsm:FlxFSM<Player1>):Void 
		{
			owner._timerReload += elapsed;
		}
	}