package core;
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
	/**
	 * Create New App Text use InputText for selectable fields
	 */
	public function new(?xp:Int,?yp:Int,fieldWidth:Int,textString:String,size:Int,color:Int,align:TextFormatAlign) 
	{
	super();
	mouseEnabled = false;
	tabEnabled = false;
	selectable = false;
	wordWrap = true;
	x = xp;
	y = yp;
	if (fieldWidth == 0)
	{
	width = App.setWidth;
	}else{
	width = fieldWidth;
	multiline = true;
	}
	text = textString;
	defaultTextFormat = new TextFormat(Assets.getFont(App.textFormat).fontName, size, color, false, false, false, "", "", align);
	embedFonts = true;
	}
	
}