package core;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.events.Event;
import openfl.events.TextEvent;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class Text extends TextField
{
	/**
	 * Static App text
	 **/
	public function new(?xp:Int,?yp:Int,fieldWidth:Int,textString:String,size:Int,color:Int,align:TextFormatAlign,ident:Null<Int>=null) 
	{
	super();
	mouseEnabled = false;
	mouseWheelEnabled = false;
	#if mobile
	tabEnabled = false;
	#else
	tabEnabled = true;
	#end
	selectable = false;
	wordWrap = true;
	embedFonts = true;
	border = false;
	x = xp;
	y = yp;
	if (fieldWidth == 0)
	{
	width = App.setWidth;
	}else{
	width = fieldWidth;
	}
	text = textString;
	var fn = "_sans";
	if (App.font != null) fn = Assets.getFont(App.font.format).fontName;
	defaultTextFormat = new TextFormat(fn, size, color, false, false, false, "", "", align, null, null, null, ident);
	cacheAsBitmap = true;
	}
	
	/*@:noCompletion override private function __updateText(value:String):Void
	{
		super.__updateText(value);
		//redraw();
	}
	
	public function redraw()
	{
		cacheAsBitmap = false;
		var timer = new Timer(1);
		timer.run = function()
		{
			cacheAsBitmap = true;
			timer.stop();
			timer = null;
		}
	}*/
}