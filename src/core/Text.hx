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
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.events.FocusEvent;
import lime.text.UTF8String;

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
	//events
	@:privateAccess __removeAllListeners();
	@:privateAccess __textEngine.getLayoutGroups();
	}

	public function scrollY(scroll:Float=0)
	{
		for(group in __textEngine.layoutGroups)
		{
			group.offsetY += scroll;
		}
		@:privateAccess __dirty = true;
	}

	@:noCompletion override private function set_text(value:String):String
	{
		__dirty = true;
		__layoutDirty = true;
		__setRenderDirty();
		if (__textEngine.textFormatRanges.length > 1)
		{
			__textEngine.textFormatRanges.splice(1, __textEngine.textFormatRanges.length - 1);
		}

		var utfValue:UTF8String = value;
		var range = __textEngine.textFormatRanges[0];
		range.format = __textFormat;
		range.start = 0;
		range.end = utfValue.length;

		__isHTML = false;

		//__forceCachedBitmapUpdate = false;
		
		__textEngine.text = value;
		__text = __textEngine.text;


		return value;
	}

}