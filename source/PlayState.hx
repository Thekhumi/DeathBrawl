package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var plataforma:FlxSprite; 
	override public function create():Void
	{
		super.create();
		plataforma = new FlxSprite();
		plataforma.makeGraphic(500, 65, FlxColor.RED);
		plataforma.immovable = true;
		add(plataforma);
		plataforma.x = camera.width / 2 - plataforma.width / 2;
		plataforma.y = camera.height / 2 - plataforma.height / 2;
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}