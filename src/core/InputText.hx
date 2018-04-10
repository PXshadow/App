package core;

import core.InputText.NativeTextFieldKeyboardType;
import haxe.Timer;
import haxe.Utf8;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.Assets;
import openfl.Lib;
import openfl.text.TextFormatAlign;
import core.App;
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
    Password; //use password bool to keep InputText Cross platform 
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
	public var posY:Int = -1;
	public var oldX:Float = 0;
	public var oldY:Float = 0;
	var isDrag:Bool = false;
	#if mobile
	public var nativeText:NativeTextField;
	#end
	public var textfield:TextField;
	public var button:Button;
	@:isVar public var text(get, set):String;
	@:isVar public var focus(get, set):Bool;
	@:isVar public var show(get, set):Bool;
	
	function get_show():Bool
	{
		#if mobile
		return false;
		#else
		return textfield.visible;
		#end
	}
	function set_show(value:Bool):Bool
	{
		#if mobile
		if(value == false)nativeText.Configure({enabled:value, visible:value});
		#end
		textfield.visible = value;
		return value;
	}
	
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
		if (value)
		{
		focusIn(null);
		}else{
		focusOut(null);
		}
		return value;
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
		textfield.defaultTextFormat = new TextFormat(null, null, newColor);
	    if (value == placeholderString) placeholderString = "";
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
	public function new(?sx:Float = 0, ?sy:Float = 0, placeString:String, fsize:Int = 24, fieldWidth:Int = 0, pcolor:Int = 0, color:Int = 0, password:Bool = false, _multiline:Bool = false,textfieldHeight:Int=0, _keyType:NativeTextFieldKeyboardType = null, _returnType:NativeTextFieldReturnKeyType = null,align:String=null) 
	{
		super();
		var fn = null;
		if (App.font != null) fn = Assets.getFont(App.font.format).fontName;
		
		newColor = color;
		pColor = pcolor;
		passwordBool = password;
		size = fsize;
		
		#if mobile
		if (_keyType == null)_keyType = NativeTextFieldKeyboardType.Default;
		if (_returnType == null)_returnType = NativeTextFieldReturnKeyType.Default;
		var nativeTextAlign = NativeTextFieldAlignment.Left;
		if (align == null) align = TextFormatAlign.LEFT;
		if (align == TextFormatAlign.CENTER) nativeTextAlign = NativeTextFieldAlignment.Center;
		if (align == TextFormatAlign.RIGHT) nativeTextAlign = NativeTextFieldAlignment.Right;
		if (passwordBool)_keyType = NativeTextFieldKeyboardType.Password;
		var setHeight:Dynamic;
		if (textfieldHeight > 0)
		{
		setHeight = textfieldHeight;
		}else{
		setHeight = NativeTextField.AUTOSIZE;
		}
		nativeText = new NativeTextField({
		x:0, 
		y:0,
		width:Math.round(fieldWidth * App.scale),
		height:setHeight,
		visible:false,
		enabled:false,
		placeholder:placeString,
		fontAsset:fn,
		fontSize:Math.round(fsize * App.scale),
		fontColor:color,
		textAlignment:nativeTextAlign,
		keyboardType:_keyType,
		returnKeyType:_returnType,
		multiline:_multiline,
		placeholderColor:pcolor
		});
		nativeText.addEventListener(nativetext.event.NativeTextEvent.FOCUS_OUT, focusOut);
		#end
		
	textfield = new TextField();
	//textfield.cacheAsBitmap = true;
	textfield.multiline = _multiline;
	textfield.wordWrap = !_multiline;
	if(textfieldHeight > 0)textfield.height = textfieldHeight;
	placeholderString = placeString;
	textfield.mouseEnabled = false;
	textfield.type = TextFieldType.DYNAMIC;
	textfield.defaultTextFormat = new TextFormat(fn, Math.floor(fsize), pcolor, false, false, false, "", "", align);
	textfield.multiline = _multiline;
	#if !mobile
	textfield.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
	#end
	if (_multiline) textfield.wordWrap = true;
	if (fieldWidth > 0)
	{
	textfield.width = fieldWidth;
	}else{
	width = App.main.stage.stageWidth;
	}
	//set textfield add to state and set posistion
	textfield.text = placeholderString;
	textfield.height = textfield.textHeight + 4;
	addChild(textfield);
	//button
	button = App.createInvisButton(0, 0, Math.floor(textfield.width),Math.floor(textfield.height));
	button.mouseOutBool = false;
	button.Up = focusIn;
	addChild(button);
	x = sx;
	y = sy;
	//events
	addEventListener(Event.REMOVED_FROM_STAGE, removed);
	}
	public function focusIn(_)
	{
		button.mouseEnabled = false;
		isDrag = App.dragBool;
		App.disableCameraMovment();
		#if mobile 
		textfield.visible = false;
		nativeText.Configure({x:Math.round(x * App.scale + App.state.x), y:Math.round(y * App.scale), enabled:true, visible:true});
		var tim = new Timer(10);
		tim.run = function()
		{
		nativeText.SetFocus();
		tim.stop();
		tim = null;
		}
		#else
		textfield.type = TextFieldType.INPUT;
		textfield.mouseEnabled = true;
		if (textfield.text == placeholderString)
		{
			textfield.displayAsPassword = passwordBool;
			textfield.text = "";
			textfield.defaultTextFormat = new TextFormat(null, null, newColor);
		}
		App.state.stage.focus = textfield;
		#end
	}
	
	public function focusOut(_)
	{
		button.mouseEnabled = true;
		App.dragBool = isDrag;
		#if mobile
		textfield.visible = true;
		if(Utf8.validate(nativeText.GetText()))textfield.text = Utf8.decode(nativeText.GetText());
		textfield.defaultTextFormat = new TextFormat(null, null, newColor);
		nativeText.Configure({visible:false, enabled:false});	
		#else
		textfield.type = TextFieldType.DYNAMIC;
		textfield.mouseEnabled = false;
		#end
	}
	
	public function removed(_)
	{
	removeEventListener(Event.REMOVED_FROM_STAGE, removed);
	#if mobile
	nativeText.Destroy();
	#else
	
	#end
	}
}