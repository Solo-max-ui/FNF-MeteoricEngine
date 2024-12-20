package openfl.display;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = 'FPS: ${currentFPS}'
		+ '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}';

		if (ClientPrefs.data.fpsColor == 'WHITE'){
			textColor = 0xFFFFFFFF;
		}else if (ClientPrefs.data.fpsColor == 'Cyan'){
			textColor = 0xFF00FFFF;
		}else if (ClientPrefs.data.fpsColor == 'Blue'){
			textColor = 0xFF0000FF;
		}else if (ClientPrefs.data.fpsColor == 'Red'){
			textColor = 0xFFFF0000;
		}else if (ClientPrefs.data.fpsColor == 'Green'){
			textColor = 0xFF00FF00;
		}else if (ClientPrefs.data.fpsColor == 'Yellow'){
			textColor = 0xFFFFFF00;
		}else{
			textColor = 0xFFFFFFFF;
		}
		if (currentFPS < FlxG.drawFramerate * 0.5){
			textColor = 0xFFFF0000;
		}
		if (ClientPrefs.data.showVer) {
		text += '\nMeteoric Engine v' + Main.meVersion + '\nBased on Psych Engine';
	    }
	}
	
	inline function get_memoryMegas():Float
	return cast(System.totalMemory, UInt);
}
