package core;

import core.InputText.NativeTextFieldKeyboardType;
import haxe.Timer;
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
	public var keyboardDis:Int = 0;
	public var oldX:Float = 0;
	public var oldY:Float = 0;
	var isDrag:Bool = false;
	#if mobile
	public var nativeText:NativeTextField;
	#end
	#if html5
	public var htmlText:js.html.Element;
	#end
	public var textfield:TextField;
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
	public function new(?sx:Float = 0, ?sy:Float = 0, placeString:String, fsize:Int = 24, fieldWidth:Int = 0, pcolor:Int = 0, color:Int = 0, password:Bool = false, _multiline:Bool = false,textfieldHeight:Int=0, _keyType:NativeTextFieldKeyboardType = null, _returnType:NativeTextFieldReturnKeyType = null,align:String=null) 
	#else
	public function new(?sx:Float=0,?sy:Float=0,placeString:String,fsize:Int=24,fieldWidth:Int=0,pcolor:Int=0,color:Int=0,password:Bool=false,_multiline:Bool = false,textfieldHeight:Int=0,_keyType:Dynamic = null, _returnType:Dynamic = null,align:String=null) 
	#end
	{
		super();
		#if mobile
		if (_keyType == null)_keyType = NativeTextFieldKeyboardType.Default;
		if (_returnType == null)_returnType = NativeTextFieldReturnKeyType.Default;
		var nativeTextAlign = NativeTextFieldAlignment.Left;
		if (align == null) align = TextFormatAlign.LEFT;
		if (align == TextFormatAlign.CENTER) nativeTextAlign = NativeTextFieldAlignment.Center;
		if (align == TextFormatAlign.RIGHT) nativeTextAlign = NativeTextFieldAlignment.Right;
		
		if (password)_keyType = NativeTextFieldKeyboardType.Password;
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
		fontAsset:App.textFormat,
		fontSize:Math.round(fsize * App.scale),
		fontColor:color,
		textAlignment:nativeTextAlign,
		keyboardType:_keyType,
		returnKeyType:_returnType,
		multiline:_multiline,
		placeholderColor:pcolor
		});
		nativeText.addEventListener(nativetext.event.NativeTextEvent.FOCUS_OUT, function(_)
		{
		//if state scrolls turn scroll back on
		App.dragBool = isDrag;
		App.scrollBool = false;
		//change to placeholder text
		textfield.visible = true;
		if(Utf8.validate(nativeText.GetText()))textfield.text = Utf8.decode(nativeText.GetText());
		textfield.defaultTextFormat = new TextFormat(null, null, newColor);
		nativeText.Configure({visible:false, enabled:false});	
		});
		#end
		textfield = new TextField();
		textfield.multiline = _multiline;
		textfield.wordWrap = !_multiline;
		if(textfieldHeight > 0)textfield.height = textfieldHeight;
		passwordBool = password;
		newColor = color;
		pColor = pcolor;
		size = fsize;
		placeholderString = placeString;
		textfield.selectable = false;
		#if !mobile
		textfield.selectable = true;
		textfield.type = TextFieldType.INPUT;
		#end
		textfield.defaultTextFormat = new TextFormat(Assets.getFont(App.textFormat).fontName, Math.floor(fsize), pcolor, false, false, false, "", "", align);
		textfield.restrict = "\u0020-\u007E";
		textfield.multiline = _multiline;
		if (_multiline) textfield.wordWrap = true;
		if (fieldWidth > 0)
		{
			textfield.width = fieldWidth;
		}else{
		   width = App.main.stage.stageWidth;
		}
		textfield.text = placeholderString;
	addChild(textfield);
	#if html5
	if (_multiline)
	{
	htmlText = cast js.Browser.document.createElement("textArea");
	}else{
	htmlText = cast js.Browser.document.createElement("input");
	}
	htmlText.setAttribute("placeholder", placeholderString);
	htmlText.setAttribute("spellcheck", "false");
	htmlText.setAttribute("size", Std.string(Math.round(fieldWidth)));
	htmlText.style.setProperty("border","none");
    htmlText.style.setProperty("background","none");
    htmlText.style.setProperty("outline","none");
    htmlText.style.setProperty("resize", "none");
	if(password)htmlText.style.setProperty("type","password");
	htmlText.style.display = "none";
	js.Browser.document.body.insertBefore(htmlText,js.Browser.document.getElementById("openfl-content"));
	#end
	this.x = sx;
	this.y = sy;
	//events
	addEventListener(MouseEvent.MOUSE_DOWN, text_onMouseDown);
	addEventListener(FocusEvent.FOCUS_OUT, text_onFocusOut);
	addEventListener(Event.REMOVED_FROM_STAGE, removed);
	
	}
	
	public function text_onMouseDown(event:MouseEvent):Void 
	{
		#if mobile
		textfield.selectable = false;
		nativeText.Configure({enabled:true, visible:true, x:Math.round(x * App.scale), y:Math.round(y * App.scale)});
		textfield.visible = false;
		var tim = new Timer(50);
		tim.run = function()
		{
		nativeText.SetFocus();
		
		isDrag = App.dragBool;
		App.dragBool = false;
		App.disableCameraMovment();
		
		tim.stop();
		tim = null;
		}
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
		if (nativeText.GetText() == "")
		{
			textfield.text = placeholderString;
			textfield.displayAsPassword = false;
			textfield.defaultTextFormat = new TextFormat(null, null, pColor);
		}
		textfield.visible = true;
		textfield.selectable = true;
		nativeText.Configure({enabled:false, visible:false});
		trace("unfocus");
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
	
	public function removed(_)
	{
	removeEventListener(MouseEvent.MOUSE_DOWN, text_onMouseDown);
	removeEventListener(FocusEvent.FOCUS_OUT, text_onFocusOut);
	removeEventListener(Event.REMOVED_FROM_STAGE, removed);
	#if mobile
	nativeText.Destroy();
	#else
	#if html5
	
	#end
	#end
	}
}