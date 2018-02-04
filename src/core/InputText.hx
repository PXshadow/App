package core;

import core.InputText.NativeTextFieldKeyboardType;
import haxe.Utf8;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
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
import lime.text.UTF8String;
import openfl.events.FocusEvent;
#if mobile
import nativetext.*;
#end
/**
 * ...
 * @author 
 */

 enum NativeTextFieldKeyboardType 
{
    Default;
    Password;
    Decimal;
    Name;
    Email;
    Phone;
    URL;
}
enum NativeTextFieldReturnKeyType 
{
    Default;
    Go;
    Next;
    Search;
    Send;
    Done;
}

	
class InputText extends DisplayObjectContainer
{
	public var placeholderString:String;
	public var newColor:Int = 0;
	public var pColor:Int = 0;
	public var size:Int = 0;
	public var passwordBool:Bool = false;
	public var keyboardDis:Int = 0;
	public var oldX:Float = 0;
	public var oldY:Float = 0;
	/**
	 * Amount of Update checks for Native Text movement, If move cycle turns to 0 untill movment has stopped
	 */
	public var updateCycle:Int = 15;
	private var updateInt:Int =  0;
	#if mobile
	public var nativeText:NativeTextField;
	#else
	public var textfield:TextField;
	#end
	@:isVar public var text(get, set):String;
	@:isVar public var focus(get, set):Bool;
	
	function get_focus():Bool
	{
		#if mobile
		return nativeText.IsFocused();
		#else
		return focus;
		#end
	}
	function set_focus(value:Bool):Bool
	{
		#if mobile
		if (value)
		{
		nativeText.SetFocus();
		}else{
		nativeText.ClearFocus();
		}
		return value;
		#else
		if (value)
		{
		stage.focus = textfield;	
		}else{
		stage.focus = null;
		}
		return value;
		#end
	}
	function get_text():String
	{
		#if mobile
		return Utf8.decode(nativeText.GetText());
		#else
		return textfield.text; 
		#end
	}
	function set_text(value:String):String
	{
		#if mobile
		value = Utf8.encode(value);
		nativeText.SetText(value);
		return text = value;
		#else
		textfield.text = value;
		return text = value;
		#end
	}
	/**
	 *  Input TextField
	 * @param	sx x
	 * @param	sy y
	 * @param	placeString placholder string
	 * @param	fsize font size
	 * @param	fieldWidth 
	 * @param	pcolor placholder color
	 * @param	color  text color
	 * @param	password password mode boolean
	 * @param	_keyType
	 * @param	_returnType 
	 */
	#if mobile
	public function new(?sx:Float = 0, ?sy:Float = 0, placeString:String, fsize:Int = 24, fieldWidth:Int = 0, pcolor:Int = 0, color:Int = 0, password:Bool = false, _multiline:Bool = false, _keyType:NativeTextFieldKeyboardType = null, _returnType:NativeTextFieldReturnKeyType = null) 
	#else
	public function new(?sx:Float=0,?sy:Float=0,placeString:String,fsize:Int=24,fieldWidth:Int=0,pcolor:Int=0,color:Int=0,password:Bool=false,_multiline:Bool = false,_keyType:Dynamic = null, _returnType:Dynamic = null) 
	#end
	{
		super();
		#if mobile
		if (_keyType == null)_keyType = NativeTextFieldKeyboardType.Default;
		if (_returnType == null)_returnType = NativeTextFieldReturnKeyType.Default;
		nativeText = new NativeTextField({
		x:sx, 
		y:sy,
		width:fieldWidth,
		height:NativeTextField.AUTOSIZE,
		visible:true,
		enabled:true,
		placeholder:placeString,
		fontAsset:App.textFormat,
		fontSize:Math.round(fsize / App.scale),
		fontColor:color,
		textAlignment:NativeTextFieldAlignment.Left,
		keyboardType:_keyType,
		returnKeyType:_returnType,
		multiline:_multiline,
		placeholderColor:pcolor
		});
		#else
		textfield = new TextField();
		passwordBool = password;
		newColor = color;
		pColor = pcolor;
		size = fsize;
		placeholderString = placeString;
		textfield.selectable = true;
		textfield.type = TextFieldType.INPUT;
		textfield.defaultTextFormat = new TextFormat(Assets.getFont(App.textFormat).fontName, Math.floor(fsize), pcolor, false, false, false, "", "", TextFormatAlign.LEFT);
		textfield.restrict = "\u0020-\u007E";
		textfield.multiline = _multiline;
		if (fieldWidth > 0)
		{
			textfield.width = fieldWidth;
		}else{
		   width = App.main.stage.stageWidth;
		}
		textfield.text = placeholderString;
	this.x = sx;
	this.y = sy;
	addChild(textfield);
	textfield.addEventListener(openfl.events.TextEvent.TEXT_INPUT, __updateText);
	#end
	//events
	addEventListener(MouseEvent.MOUSE_DOWN, text_onMouseDown);
	addEventListener(FocusEvent.FOCUS_OUT, text_onFocusOut);
	addEventListener(Event.REMOVED, removed);
	}
	
	public function text_onMouseDown(event:MouseEvent):Void 
	{
		#if mobile
		
		#else
		if (textfield.text == placeholderString)
		{
			textfield.displayAsPassword = passwordBool;
			textfield.text = "";
			textfield.defaultTextFormat = new TextFormat(null, null, newColor);
		}
		if (App.mobile)
		{
		App.resizeBool = false;
		keyboardDis = Math.floor(y/2);
		App.state.y = -keyboardDis;
		}
		#end
	}
	
	public function text_onFocusOut(event:FocusEvent):Void 
	{
		#if mobile
		
		#else
		if (textfield.text == "")
		{
			textfield.text = placeholderString;
			textfield.displayAsPassword = false;
			textfield.defaultTextFormat = new TextFormat(null, null, pColor);
		}
		if (App.mobile)
		{
		App.resizeBool = true;
		App.state.y = 0;
		}
		#end
	}
	
public function __updateText(value:String):Void 
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
	}
	public function removed(_)
	{
	removeEventListener(MouseEvent.MOUSE_DOWN, text_onMouseDown);
	removeEventListener(FocusEvent.FOCUS_OUT, text_onFocusOut);
	#if mobile
	nativeText.Destroy();
	#else
	textfield.removeEventListener(openfl.events.TextEvent.TEXT_INPUT, __updateText);
	#end
	}
}