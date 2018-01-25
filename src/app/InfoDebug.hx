package src.app;

import openfl.Lib;
import openfl.system.Capabilities;
import openfl.text.TextField;
import openfl.events.Event;
import openfl.text.TextFormat;
import openfl.system.System;
import haxe.Timer;
import src.app.App;

class InfoDebug extends TextField
{
	private var memPeak:Float = 0;
	private var timer:Int = 4;
	private var ver:String;
	private var scaleNum:Float;
	private var times:Array<Float>;
	public var tL:Int = 60;
	var mobileString:String = "F";
	public function new(inCol:Int = 16777215) 
	{
		super();
		if (src.app.App.mobile) mobileString = "T";
		times = [];
		y = Lib.current.stage.stageHeight - 20;
		selectable = false;
		#if (mobile || desktop)
		ver = Lib.current.stage.application.config.version;
		#end
		defaultTextFormat = new TextFormat("_sans", 15, inCol);
		width = 150 * 4;
		height = 70;
		Lib.current.addChild(this);
		y = src.app.App.main.stage.stageHeight - 20 * src.app.App.scale;
	}
	public function resize()
	{
	scaleX = src.app.App.scale;
	scaleY = src.app.App.scale;
	y = Lib.current.stage.stageHeight - 20 * src.app.App.scale;
	trace("scale " + src.app.App.scale);
	scaleNum = Math.round(src.app.App.scale * 100) / 100;
	}
	
	public function onEnter()
	{	
		if (timer == 0)
		{
		timer = 4;
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;
		//elasped
		//GET framerate
		var now = Timer.stamp();
		times.push(now);
		
		while (times[0] < now - 1)
			times.shift();
			tL = times.length * timer;
		
		text = "fps " + tL + " el " + Math.round((tL / Lib.current.stage.frameRate) * 10) / 10 +  " mem " + mem + "  mx " + memPeak  + " s " + scaleNum +  " v " + ver + " m " + mobileString;
		}
		timer += -1;
	}
}