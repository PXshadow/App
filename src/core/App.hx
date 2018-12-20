package core;
import core.App;
import core.Button;
import core.State;
import core.Text;
import core.Network;
import lime.ui.KeyCode;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.IGraphicsData;
import openfl.display.StageScaleMode;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

import format.SVG;
import haxe.Timer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.DisplayObject;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageAlign;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.text.TextFormatAlign;
import haxe.ds.Vector;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author 
 */
class App extends DisplayObjectContainer
{
	//colors
	public static var colorArray = [755381, 16761913, 11654726];
	//main
	public static var setWidth:Int = 0;
	public static var setHeight:Int =0;
	public static var scale:Float = 0;
	public static var state:State;
	/**
	 * Enabled let's android back button leave app
	 */
	public var backExit:Bool = false;
	//debug
	/**
	 * Set to False to Remove Info Bool
	 */
	public static var infoBool:Bool = true;
	/**
	 * color of Info Text Defualt Black = 0 white = 16777215
	 */
	public static var infoColor:Int = 0;
	/**
	* info Text size
	**/
	public static var infoSize:Int = 12;
	//refrence self in static
	public static var main:DisplayObjectContainer;
	public static var screen:App;
	//Performance Idler
	/**
	 *  Set FrameRate when App is De Activated 
	 */
	public var idle:Int = 5;
	/**
	 *  Set Url's to Diffrent States
	 */
	public static var inital:Bool = true;
	/**
	 * Networking for App
	 */
	public static var network:Network;
	/**
	 * Font Libary for App
	 */
	public static var font:Font;
	/**
	 * mobile check for both html5 and native
	 */
	public static var mobile:Bool = false;
	/**
	 * lets stage be resized defualt true
	 */
	public static var resizeBool:Bool = true;
	/**
	* Resize that is called when Resize
	**/
	public var onResize:Dynamic->Void;
	/**
	 * 
	 * When Exit or android Back button are pressed
	 */
	public var onBack:Dynamic->Void;
	 /*
	 * @param	sx Width of App
	 * @param	sy Height of App
	 */
	 /**
	  * active and deactive screen events
	  */
	public var activeEvent:Void->Void;
	public var unActiveEvent:Void->Void;
	
	/**
	 * false = User not on application / minimized
	 */
	public var active:Bool = true;
	
	public function new(sx:Int=640,sy:Int=1136,_font:Font=null) 
	{
		super();
		if (_font != null) font = _font;
		Lib.current.mouseEnabled = false;
		#if html5
	var browserAgent : String = js.Browser.navigator.userAgent;
	if (browserAgent != null) 
	{
	if	(	browserAgent.indexOf("Android") >= 0
	    ||	browserAgent.indexOf("BlackBerry") >= 0
		||	browserAgent.indexOf("iPhone") >= 0
		||	browserAgent.indexOf("iPad") >= 0
		||	browserAgent.indexOf("iPod") >= 0
		||	browserAgent.indexOf("Opera Mini") >= 0
		||	browserAgent.indexOf("IEMobile") >= 0
			)mobile = true;
		    
	}
	//scroll into view
	/*var timer = new Timer(200);
	timer.run = function()
	{
	js.Browser.document.body.scrollIntoView();//force the view to move below the adress bar => fix issue 1
	js.Browser.document.body.style.height = js.Browser.window.innerHeight + "px";
	timer.stop();
	timer = null;
	}*/
		#end
		#if mobile
		nativetext.NativeText.Initialize();
		#end
		
		setWidth = sx;
		setHeight = sy;
		mouseEnabled = false;
		
		screen = this;
		main = new DisplayObjectContainer();
		var shape = new Shape();
		shape.graphics.beginFill(0);
		shape.graphics.drawRect(0, 0, 300, 300);
		//main.addChild(shape);
		//addChild(shape);
		addChild(main);
		State.pastBitmap = new Bitmap();
		addChild(State.pastBitmap);
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		//add self
		Lib.current.addChild(screen);
		//events
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent)
		{
		if(!state.stateAnimation)state.mouseDown();
		});
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent)
		{
		if(!state.stateAnimation)state.mouseUp();
		});
		
		#if !mobile
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL,function(e:MouseEvent)
		{
			if (state != null && !state.stateAnimation) state.mouseWheel(e);
		});
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			if(state != null && !state.stateAnimation)state.keyDown(e);
		});
		Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, function(e:MouseEvent)
		{
			state.mouseWheelDown(e);
		});
		Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, function(e:MouseEvent)
		{
			state.mouseWheelUp(e);
		});
		Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent)
		{
			state.mouseRightDown(e);
		});
		Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent)
		{
			state.mouseRightUp(e);
		});
		#end
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{
			#if !mobile
			if(!mobile)state.keyUp(e);
			#end
			#if android
			if (!backExit && e.keyCode == KeyCode.APP_CONTROL_BACK)
			{
			e.preventDefault();
			state.back(e);
			}
			#end
		});
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
		if (App.network != null) App.network.update();
		if (state != null && !state.stateAnimation)state.loop();
		}); 
		
		Lib.current.stage.addEventListener (openfl.events.Event.ACTIVATE, function (_) {
		Lib.current.stage.frameRate = 60;
		active = true;
		if (activeEvent != null) activeEvent();
		});
		
		Lib.current.stage.addEventListener (openfl.events.Event.DEACTIVATE, function (_) {
			state.scrollSpeed = 0;
			active = false;
			Lib.current.stage.frameRate = 5;
			if (unActiveEvent != null) unActiveEvent();
		});
	}
			
			
	//http://pixelthis.games/blog/?p=131
	public static function cutShapeFromBitmapData( bitmapData : BitmapData, shape : Shape ):BitmapData 
	{
    // Copy the shape to a bitmap
    var shapeBitmapData : BitmapData = new BitmapData( bitmapData.width, bitmapData.height, true, 0x00000000 );
    shapeBitmapData.draw( shape, shape.transform.matrix, null, null, null, true );
    // Now keep the alpha channel, but copy all other channels from the source
    var p : Point = new Point(0, 0);
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.RED, BitmapDataChannel.RED );
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN );
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE );
    return shapeBitmapData;
	}
	public static function pointRect(pX:Float, pY:Float, rect:Rectangle):Bool
	{
		//y
		if (pY < rect.y) return false;
		if (pY > rect.y + rect.height) return false;
		//x
		if (pX < rect.x) return false;
		if (pX > rect.x + rect.width) return false;
		return true;
	}
	/**
	 * 
	 * @param	original bitmap
	 * @param	axis x or y
	 * @return
	 */
	//https://stackoverflow.com/questions/7773488/flipping-a-bitmap-horizontally#7773649
	public static function flipBitmapData(original:BitmapData, axis:String = "x"):BitmapData
	{
	 var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
     var matrix:Matrix;
     if(axis == "x"){
          matrix = new Matrix( -1, 0, 0, 1, original.width, 0);
     } else {
          matrix = new Matrix( 1, 0, 0, -1, 0, original.height);
     }
     flipped.draw(original, matrix, null, null, null, true);
     return flipped;
	 
	}
	/**
	 * 
	 * @param	x
	 * @param	y
	 * @param	path to either a png or a svg, PNG for sprite is experimental right now
	 * @param	w width
	 * @param	h height
	 * @return
	 */
		public static function createSprite(?x:Float = 0, ?y:Float = 0, path:String,w:Int=-1,h:Int=-1,oval:Bool=false,localX:Float=0,localY:Float=0):Shape
	{
		var shape = new Shape();
		var sub = path.substring(path.length - 4, path.length);
		if (sub == ".png" || sub == ".jpg")
		{
	Assets.loadBitmapData(path).onComplete(function(bmd:BitmapData)
	{
	var mat = new Matrix();
	var sx:Float = 1;
	var sy:Float = 1;
	if(w > 0) sx = 1 / bmd.width * w;
	if(h > 0) sy = 1 / bmd.height * h;
	mat.scale(sx, sy);
	mat.translate(localX, localY);
	shape.graphics.beginBitmapFill(bmd, mat, false, true);
	if (oval)
	{
	shape.graphics.drawEllipse(localX, localY, sx * bmd.width, sy * bmd.height);	
	}else{
	shape.graphics.drawRect(localX, localY, sx * bmd.width, sy * bmd.height);
	}
	});
		}else{
		if (oval) trace("vector graphic does not support Oval");
		Assets.loadText(path).onComplete(function(string:String)
		{
		new SVG(string).render(shape.graphics, 0, 0, w, h);
		});
		}
		shape.x = x;
		shape.y = y;
		shape.cacheAsBitmap = true;
		return shape;
	}
	/**
	 *  Create A rectangle Shape
	 * @param	sx x
	 * @param	sy y
	 * @param	width
	 * @param	height
	 * @param	color
	 * @return
	 */
	public static function createRect(?sx:Float = 0, ?sy:Float = 0, ?width:Float, ?height:Float,color:Int=16777215):Shape
	{
		var sprite = new Shape();
		sprite.graphics.beginFill(color);
		sprite.graphics.drawRect(0, 0, width, height);
		sprite.graphics.endFill();
		sprite.x = sx;
		sprite.y = sy;
		sprite.cacheAsBitmap = true;
		return sprite;
		
	}
	/**
	 *  Create a Rectangle button with 0 alpha
	 * @param	x
	 * @param	y
	 * @param	width
	 * @param	height
	 * @return
	 */
	public static function createInvisButton(?x:Int=0, ?y:Int=0, ?width:Int=-1, ?height:Int=-1):Button
	{
		return new Button(x, y, "",width,height);
	}
	/**
	 * Create a button, no path means rectangle, otherwise path can be for either svg or png
	 * @param	x
	 * @param	y
	 * @param	path
	 * @param	sWidth
	 * @param	sHeight
	 * @return
	 */
	public static function createButton(?x:Int, ?y:Int, ?path:String,?sWidth:Int=-1,?sHeight:Int=-1):Button
	{
		return new Button(x,y,path,sWidth,sHeight);
	}
	/**
	 * ThinQbator custom exit Button
	 * @param	x
	 * @param	y
	 * @param	color
	 * @return
	 */
	public static function createExit(?x:Int = 0, ?y:Int = 0,color:Int=16777215):Button
	{
		var exit = new Button(x,y);
		exit.graphics.beginFill(0,0);
		exit.graphics.drawRect(-80, 0, 60 + 80 * 2, 80);
		exit.graphics.lineStyle(4,color);
		exit.graphics.moveTo(0, 25);
		exit.graphics.lineTo(30, 25 + 30);
		exit.graphics.moveTo(0, 25 + 30);
		exit.graphics.lineTo(30, 25);
		return exit;
	}
	/**
	 * ThinQbator custom Next Circle Button
	 * @param	x
	 * @param	y
	 * @param	color
	 * @param	radius
	 * @return
	 */
	public static function createNextCircle(?x:Int = 0, ?y:Int, color:Int = 0, radius:Int = 40):Button
	{
		var nextButton = new Button(x, y);
		var thick:Int = 4;
		nextButton.graphics.beginFill(0,0);
		nextButton.graphics.drawRect(-radius,-radius, radius * 2, radius * 2);
		nextButton.graphics.endFill();
		nextButton.graphics.lineStyle(thick, color);
		nextButton.graphics.drawCircle(0, 0, radius);
		nextButton.graphics.moveTo( -radius / 2, thick / 2);
		nextButton.graphics.lineTo(radius / 2, thick / 4);
		nextButton.graphics.lineTo( -radius / 2, thick/2);
		nextButton.graphics.lineTo(0, Math.floor(-radius / 3));
		nextButton.graphics.moveTo( -radius / 2, thick/2);
		nextButton.graphics.lineTo(0, Math.floor(radius / 3) + thick);
		nextButton.graphics.endFill();
		return nextButton;
	}
	/**
	 * ThinQbator Custom Next Button no Circle
	 * @param	x
	 * @param	y
	 * @param	color
	 * @return
	 */
	public static function createBack(color:Int = 0):Button
	{
		var nextButton = new Button(50,40);
		var thick:Int = 4;
		var radius:Int = 33;
		nextButton.graphics.lineStyle(thick, color);
		nextButton.graphics.moveTo( -radius / 2, thick / 2);
		nextButton.graphics.lineTo(radius / 2, thick / 4);
		nextButton.graphics.lineTo( -radius / 2, thick / 2);
		nextButton.graphics.lineTo(0, Math.floor(-radius / 3));
		nextButton.graphics.moveTo( -radius / 2, thick/2);
		nextButton.graphics.lineTo(0, Math.floor(radius / 3) + thick);
		nextButton.graphics.endFill();
		//rect
		nextButton.graphics.endFill();
		nextButton.graphics.beginFill(0, 0);
		nextButton.graphics.drawRect( -80, -60, 80, 80);
		return nextButton;
	}
	/**
	 * Modified Text using App.textFormat string to get font name
	 * @param	textString
	 * @param	x
	 * @param	y
	 * @param	size
	 * @param	color
	 * @param	align
	 * @param	fieldWidth
	 * @param	scaleAddAuto
	 * @return
	 */
	public static function createText (?textString:String = "", ?x:Int = 0, ?y:Int = 0, ?size:Int = 24, ?color:Int, ?align:TextFormatAlign = TextFormatAlign.LEFT, fieldWidth:Int = 0,indent:Null<Int>=null):Text
	{
	return new Text(x, y, fieldWidth, textString, size, color, align,indent);
	}
	/**
	 * triggered Resize event that deals with all of the App's resizing calls and Math
	 * @param	_
	 */
	public function resize(e:Event)
	{
		//safe NEP
		if (state != null)
		{
		var tempX:Float = stage.stageWidth/ setWidth;
		var tempY:Float = stage.stageHeight/ setHeight;
		scale = Math.min(tempX, tempY);
		State.px = Math.floor((stage.stageWidth - setWidth * App.scale) / 2);
		State.py = 0;
		State.sx = scale;
		State.sy = scale;
		//set resize
		x = State.px; 
		y = State.py;
		scaleX = State.sx; 
		scaleY = State.sy;
		state.resize();
		}
		//call on resize
		if (onResize != null) onResize(e);
	}
	

}
