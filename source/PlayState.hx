package;

import entities.Bullet;
import entities.Player1;
import entities.Player2;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
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
	var _player1:Player1;
	var _player2:Player2;
	override public function create():Void
	{
		super.create();
		_player1 = new Player1();
		_player2 = new Player2();
		add(_player1);
		add(_player2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}