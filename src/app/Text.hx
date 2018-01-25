package src.app;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import src.app.App;

/**
 * ...
 * @author 
 */
class Text extends TextField 
{
	/**
	 * Create New App Text use InputText for selectable fields
	 */
	public function new(?xp:Int,?yp:Int,fieldWidth:Int,textString:String,size:Int,color:Int,align:TextFormatAlign) 
	{
	super();
	cacheAsBitmap = true;
	mouseEnabled = false;
	tabEnabled = false;
	selectable = false;
	wordWrap = true;
	mouseEnabled = false;
	x = xp;
	y = yp;
	if (fieldWidth == 0)
	{
	width = src.app.App.setWidth;
	}else{
	width = fieldWidth;
	multiline = true;
	}
	text = textString;
	defaultTextFormat = new TextFormat(Assets.getFont(src.app.App.textFormat).fontName, size, color, false, false, false, "", "", align);
	}
	
	override function __updateText(value:String):Void 
	{
		super.__updateText(value);
	}
	
}