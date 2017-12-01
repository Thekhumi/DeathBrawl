package;

import entities.Bullet;
import entities.Player1;
import entities.Player2;
import entities.Box;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
/**
 To be fair, you have to have a very high IQ to understand Haxe Flixel. The logic is extremely subtle, and without a solid grasp of theoretical programming
 most of the lines will go over a typical programmer head. There’s also Cid’s nihilistic outlook, which is deftly woven into his characterisation- 
 his personal philosophy draws heavily from Anime literature, for instance. The coders understand this stuff; they have the intellectual capacity 
 to truly appreciate the depths of these functions, to realise that they’re not just useful- they say something deep about LIFE. As a consequence people 
 who dislike Haxe Flixel truly ARE idiots- of course they wouldn’t appreciate, for instance, the built-in functions in Haxe’s existential library
 “FlxColor” which itself is a cryptic reference to COMMUNISM. I’m smirking right now just imagining one
 of those addlepated simpletons scratching their heads in confusion as Nicolas Cannasse’s genius wit unfolds itself on their computer screens. 
 What fools.. how I pity them.
 */
class PlayState extends FlxState
{
	private var _player1:Player1;
	private var _player2:Player2;
	private var _piso:FlxTilemap;
	private var _cajas:FlxTypedGroup<Box>;
	private var _balas:FlxTypedGroup<Bullet>;
	private var _emitter:FlxEmitter;
	
	override public function create():Void
	{
		super.create();
		_cajas = new FlxTypedGroup<Box>();
		_balas = new FlxTypedGroup<Bullet>();
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.Level__oel);
		_piso = loader.loadTilemap(AssetPaths.Floor__png, 32, 32, "Piso"); 
		_piso.setTileProperties(1, FlxObject.NONE);
		loader.loadEntities(BoxCreator, "Caja");
		_player1 = new Player1(_balas,32,448);
		_player2 = new Player2(_balas,448,32);
		add(_piso);
		add(_player1);
		add(_player2);
		add(_cajas);
		FlxG.worldBounds.set(0, 0, 512, 512);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		Collisions();
	}
	
	function Collisions() 
	{
		for (i in 0..._balas.members.length)
		{
			if (FlxG.overlap(_balas.members[i],_player1))
			{
				if (_player1.facing == FlxObject.UP && _balas.members[i].y < _player1.y && _player1._isBlocking || 
				_player1.facing == FlxObject.RIGHT &&  _balas.members[i].x > _player1.x && _player1._isBlocking ||
				_player1.facing == FlxObject.DOWN && _balas.members[i].y > _player1.y && _player1._isBlocking	||
				_player1.facing == FlxObject.LEFT &&  _balas.members[i].x < _player1.x && _player1._isBlocking)
				{
				_balas.members[i].x = -10;
				_balas.remove(_balas.members[i], true);
				}
				else
				{
				_emitter = new FlxEmitter();
				_emitter.makeParticles(3, 3, FlxColor.BLUE, 500);
				_emitter.start(false,0.03);
				_emitter.x = _player1.x;
				_emitter.y = _player1.y;
				add(_emitter);
				_player1.destroy();
				_balas.members[i].x = -10;
				_balas.remove(_balas.members[i], true);
				}
			}
			else if (FlxG.overlap(_balas.members[i],_player2))
			{
				if (_player2.facing == FlxObject.UP && _balas.members[i].y < _player2.y && _player2._isBlocking || 
				_player2.facing == FlxObject.RIGHT &&  _balas.members[i].x > _player2.x && _player2._isBlocking ||
				_player2.facing == FlxObject.DOWN && _balas.members[i].y > _player2.y && _player2._isBlocking	||
				_player2.facing == FlxObject.LEFT &&  _balas.members[i].x < _player2.x && _player2._isBlocking)
				{
				_balas.members[i].x = -10;
				_balas.remove(_balas.members[i], true);
				}
				else
				{
				_emitter = new FlxEmitter();
				_emitter.makeParticles(3, 3, FlxColor.RED, 500);
				_emitter.start(false,0.03);
				_emitter.x = _player2.x;
				_emitter.y = _player2.y;
				add(_emitter);
				_player2.destroy();
				_balas.members[i].x = -10;
				_balas.remove(_balas.members[i], true);
				}
			}
		}
		
		for (i in 0..._cajas.members.length)
		{
			FlxG.collide(_cajas.members[i], _player1);
			FlxG.collide(_cajas.members[i], _player2);
			for (h in 0..._balas.members.length)
			{
				if (FlxG.overlap(_cajas.members[i], _balas.members[h]))
				{
					_balas.members[h].x = -10;
					_balas.remove(_balas.members[h], true);
					_cajas.remove(_cajas.members[i], true);
					FlxG.camera.shake(0.02, 0.4);
				}
			}
		}
	}
	
	private function BoxCreator (entityName:String, entityData: Xml)//CAJAS
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		var box:Box = new Box(x,y);
		_cajas.add(box);
	}
}