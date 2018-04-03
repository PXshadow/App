package core;
import haxe.Timer;
import openfl.events.TextEvent;
import openfl.text.TextField;
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
	public var initalTextRender:Bool = true;
	/**
	 * Static App text
	 **/
	public function new(?xp:Int,?yp:Int,fieldWidth:Int,textString:String,size:Int,color:Int,align:TextFormatAlign,ident:Null<Int>=null) 
	{
	super();
	mouseEnabled = false;
	tabEnabled = false;
	selectable = false;
	wordWrap = true;
	cacheAsBitmap = true;
	x = xp;
	y = yp;
	if (fieldWidth == 0)
	{
	width = App.setWidth;
	}else{
	width = fieldWidth;
	}
	text = textString;
	var fn = null;
	if (App.font != null) fn = Assets.getFont(App.font.format).fontName;
	defaultTextFormat = new TextFormat(fn, size, color, false, false, false, "", "", align,null,null,null,ident);
	}
	@:noCompletion override private function __updateText(value:String):Void
	{
		super.__updateText(value);
		if (!initalTextRender)
		{
		var time = new Timer(1);
		cacheAsBitmap = false;
		time.run = function()
		{
			cacheAsBitmap = true;
			time.stop();
			time = null;
		}
		}
		initalTextRender = false;
	}
}