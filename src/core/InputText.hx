package core;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.Assets;
import openfl.Lib;
import openfl.text.TextFormatAlign;
import core.App;
/**
 * ...
 * @author 
 */
class InputText extends TextField 
{
	public var placeholderString:String;
	public var newColor:Int = 0;
	public var pColor:Int = 0;
	public var size:Int = 0;
	public var passwordBool:Bool = false;
	public var keyboardDis:Int = 0;
	/**
	 *  Input Text For App 
	 */
	public function new(?sx:Float=0,?sy:Float=0,placeString:String,fsize:Int=24,fieldWidth:Int=0,pcolor:Int=0,color:Int=0,password:Bool=false,tabBool:Bool=true) 
	{
		super();
		#if (neko || cpp)
		tabEnabled = tabBool;
		#end
		passwordBool = password;
		newColor = color;
		pColor = pcolor;
		size = fsize;
	placeholderString = placeString;
		selectable = true;
		type = TextFieldType.INPUT;
		defaultTextFormat = new TextFormat(Assets.getFont(App.textFormat).fontName, Math.floor(fsize), pcolor, false, false, false, "", "", TextFormatAlign.LEFT);
		restrict = "\u0020-\u007E";
		if (fieldWidth > 0)
		{
			width = fieldWidth;
		}else{
		   width = App.main.stage.stageWidth;
		}
		text = placeholderString;
	this.x = sx;
	this.y = sy;
	
	}
	
	override function this_onMouseDown(event:MouseEvent):Void 
	{
		super.this_onMouseDown(event);
		if (text == placeholderString)
		{
			displayAsPassword = passwordBool;
			text = "";
			defaultTextFormat = new TextFormat(null, null, newColor);
		}
		if (App.mobile)
		{
		App.resizeBool = false;
		keyboardDis = Math.floor(y/2);
		App.state.y = -keyboardDis;
		}
	}
	
	override function this_onFocusOut(event:FocusEvent):Void 
	{
		super.this_onFocusOut(event);
		if (text == "")
		{
			text = placeholderString;
			displayAsPassword = false;
			defaultTextFormat = new TextFormat(null, null, pColor);
		}
		if (App.mobile)
		{
		App.resizeBool = true;
		App.state.y = 0;
		}
	}
	
	override function __updateText(value:String):Void 
	{
		#if html5
if (App.mobile)
{
	if (value != placeholderString)
	{
		var word:String = "";
		var par:String = "";
		if (value.length - 1 > text.length)
		{
		par = text.substring(text.lastIndexOf(" ") + 1, text.length);
		word = value.substring(text.length, value.length);
		value = value.substring(0, text.lastIndexOf(" ") + 1) + word;
		
		}
	}
}
		#end
		super.__updateText(value);
	}
	
	
}