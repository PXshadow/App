package core;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
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
	
class InputText extends DisplayObjectContainer
{
	public var placeholderString:String;
	public var newColor:Int = 0;
	public var pColor:Int = 0;
	public var size:Int = 0;
	public var passwordBool:Bool = false;
	public var keyboardDis:Int = 0;
	#if mobile
	public var nativeText:NativeTextField;
	@:isVar public var keyboardType(get, set):NativeTextFieldKeyboardType;
	function get_keyboardType():NativeTextFieldKeyboardType
	{
		return keyboardType;
	}
	function set_keyboardType(value:NativeTextFieldKeyboardType):NativeTextFieldKeyboardType
	{
		return keyboardType = value;
	}
	@:isVar public var returnType(get, set):NativeTextFieldReturnKeyType;
	function get_returnType():NativeTextFieldReturnKeyType
	{
		return returnType;
	}
	function set_returnType(value:NativeTextFieldReturnKeyType):NativeTextFieldReturnKeyType
	{
		return returnType = value;
	}
	#else
	public var textfield:TextField;
	#end
	/**
	 *  Input Text For App 
	 */
	
	
	public function new(?sx:Float=0,?sy:Float=0,placeString:String,fsize:Int=24,fieldWidth:Int=0,pcolor:Int=0,color:Int=0,password:Bool=false,_keyType:Dynamic=null,_returnType:Dynamic=null) 
	{
		super();
		#if mobile
		if (_keyType != null && Std.is(_keyType,NativeTextFieldKeyboardType)) set_keyboardType(cast(_keyType, NativeTextFieldKeyboardType));
		if (_returnType != null && Std.is(_returnType, NativeTextFieldReturnKeyType)) set_returnType(cast(_returnType, NativeTextFieldReturnKeyType));
		nativeText = new NativeTextField({
		x:sx, 
		y:sy,
		width:fieldWidth,
		height:NativeTextField.AUTOSIZE,
		visible:true,
		enabled:true,
		placeholder:placeString,
		fontAsset:App.textFormat,
		fontSize:fsize,
		fontColor:color,
		textAlignment:NativeTextFieldAlignment.Left,
		keyboardType:NativeTextFieldKeyboardType.Default,
		returnKeyType:NativeTextFieldReturnKeyType.Default
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
	addEventListener(MouseEvent.MOUSE_DOWN, this_onMouseDown);
	addEventListener(FocusEvent.FOCUS_OUT, this_onFocusOut);
	addEventListener(openfl.events.Event.REMOVED, removed);
	}
	
	
	@:noCompletion public function this_onMouseDown(event:MouseEvent):Void 
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
	
	@:noCompletion public function this_onFocusOut(event:FocusEvent):Void 
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
	removeEventListener(MouseEvent.MOUSE_DOWN, this_onMouseDown);
	removeEventListener(FocusEvent.FOCUS_OUT, this_onFocusOut);
	#if mobile
	nativeText.Destroy();
	#else
	textfield.removeEventListener(openfl.events.TextEvent.TEXT_INPUT, __updateText);
	#end
	}
}