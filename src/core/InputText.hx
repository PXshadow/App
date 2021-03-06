package core;

import core.InputText.NativeTextFieldKeyboardType;
import haxe.Timer;
import haxe.Utf8;
import haxe.io.Input;
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
	public var textWidth:Float = 0;
	var isDrag:Bool = true;
	#if mobile
	public var nativeText:NativeTextField;
	public static var focusInput:InputText;
	#end
	public var out:Void->Void;
	
	public var textfield:TextField;
	public var button:Button;
	@:isVar public var text(get, set):String;
	@:isVar public var focus(get, set):Bool;
	@:isVar public var show(get, set):Bool;
	public var desktopChange:Dynamic->Void;
	
	function get_show():Bool
	{
		#if mobile
		return nativeText.IsFocused();
		#else
		return textfield.visible;
		#end
	}
	function set_show(value:Bool):Bool
	{
		#if mobile
		if (value == false)
		{
			if (nativeText.IsFocused()) nativeText.ClearFocus();
			nativeText.Configure({enabled:false, visible:false});
		}
		#end
		textfield.visible = value;
		button.mouseEnabled = value;
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
		focusOut();
		}
		return value;
	}
	function get_text():String
	{
		#if mobile
		//if(Utf8.validate(nativeText.GetText())) return nativeText.GetText();
		return nativeText.GetText();
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
	public function new(?sx:Float = 0, ?sy:Float = 0, placeString:String, fsize:Int = 24, fieldWidth:Int = 0, pcolor:Int = 9805216, color:Int = 0, password:Bool = false, _multiline:Bool = false,textfieldHeight:Int=0, _keyType:NativeTextFieldKeyboardType = null, _returnType:NativeTextFieldReturnKeyType = null,align:String=null) 
	{
		super();
		
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
		
		nativeText = new NativeTextField({
		x:0, 
		y:0,
		width:Std.int(fieldWidth * App.scale),
		height:(textfieldHeight == 0 ? NativeTextField.AUTOSIZE : Std.int(textfieldHeight * App.scale)),
		visible:false,
		enabled:false,
		placeholder:placeString,
		fontAsset:App.font.format,
		fontSize: Std.int(fsize * App.scale),
		fontColor:color,
		textAlignment:nativeTextAlign,
		keyboardType:_keyType,
		returnKeyType:_returnType,
		multiline:_multiline,
		placeholderColor:pColor
		});
		#end
		
	textfield = new TextField();
	//textfield.cacheAsBitmap = true;
	textfield.multiline = _multiline;
	textfield.wordWrap = !_multiline;
	if(textfieldHeight > 0)textfield.height = textfieldHeight;
	placeholderString = placeString;
	textfield.mouseEnabled = false;
	textfield.type = TextFieldType.DYNAMIC;
	textfield.defaultTextFormat = new TextFormat(Assets.getFont(App.font.format).fontName, Math.floor(fsize), pColor, false, false, false, "", "", align);
	textfield.multiline = _multiline;
	#if !mobile
	textfield.addEventListener(FocusEvent.FOCUS_OUT, focusOutFalseMobile);
	textfield.wordWrap = true;
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
	#if html5
		
	#end
	//button
	button = App.createInvisButton(0, 0, Math.floor(textfield.width), Math.floor(textfield.height));
	button.Click = focusIn;
	addChild(button);
	x = sx;
	y = sy;
	//events
	addEventListener(Event.REMOVED_FROM_STAGE, removed);
	}
	public function toggleNative(bool:Bool)
	{
		#if mobile
		if (bool) 
		{
		nativeText.Configure({x:Math.round(x * App.scale + App.screen.x), y:Math.round(y * App.scale + App.screen.y), enabled:true, visible:true});
		}else{
		nativeText.Configure({visible:false, enabled:false});
		}
		textfield.visible = !bool;
		button.mouseEnabled = !bool;
		#end
	}
	public function focusIn(_)
	{
		#if mobile
		if (focusInput != null) focusInput.focusOut();
		focusInput = this;
		toggleNative(true);
		var tim = new Timer(10);
		tim.run = function()
		{
		nativeText.SetFocus();
		NativeTextField.focusOut = focusOut;
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
		textfield.addEventListener(TextEvent.TEXT_INPUT, desktopChange);
		#end
		isDrag = App.state.dragBool;
		App.state.disableCameraMovment();
	}
	#if !mobile
	public function focusOutFalseMobile(_)
	{
		focusOut();
	}
	#end
	public function focusOut()
	{
		App.state.dragBool = isDrag;
		#if mobile
		textfield.visible = true;
		textfield.displayAsPassword = passwordBool;
		
			var string = text;
			if (string == "")
			{
			textfield.text = placeholderString;
			textfield.defaultTextFormat = new TextFormat(null, null, pColor);
			}else{
			textfield.text = string;
			textfield.defaultTextFormat = new TextFormat(null, null,newColor);
			}
			
		nativeText.ClearFocus();
		toggleNative(false);
		NativeTextField.focusOut = null;
		NativeTextField.change = null;
		#else
		textfield.type = TextFieldType.DYNAMIC;
		textfield.mouseEnabled = false;
		#end
		if (out != null) out();
	}
	
	public function update(_)
	{
		
	}
	
	public function removed(_)
	{
	removeEventListener(Event.REMOVED_FROM_STAGE, removed);
	#if mobile
	if (focusInput == this)
	{
	focusOut();
	focusInput = null;
	}
	nativeText.Destroy();
	#else
	removeEventListener(Event.ENTER_FRAME, update);
	#end
	}
}