package core;
import core.Button;
import core.State;
import core.Text;
import core.UrlState;
import core.Network;
import haxe.crypto.Base64;
import lime.ui.KeyCode;
import openfl.display.DisplayObjectContainer;
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
	//old mouse postions
	public static var omX:Float = 0;
	public static var omY:Float = 0;
	//CameraScroll
	public var cameraMinY:Int = 0;
	public var cameraMaxY:Int = 0;
	public var cameraMinX:Int = 0;
	public var cameraMaxX:Int = 0;
	public var maxEventY:Void->Bool;
	public var maxEventX:Void->Bool;
	public var minEventX:Void->Bool;
	public var minEventY:Void->Bool;
	private var restrictInt:Int = 0;
	
	//if camera is scrolling used to have buttons not go off during
	public static var scrollPress:Bool = false;
	//start postion of scroll
	public static var dragBool:Bool = false;
	public static var dragRect:Rectangle;
	public static var spX:Float = 0;
	public static var spY:Float = 0;
	public static var mouseDown:Bool = false;
	public static var camY:Float = 0;
	public static var camX:Float = 0;
	public static var scrollSpeedY:Float = 0;
	public static var scrollSpeedX:Float = 0;
	var oldSSX:Float = 0;
	var oldSSY:Float = 0;
	public static var scrollDuration:Int = 0;
	public static var scrollBool:Bool = false;
	public var moveBool:Bool = false;
	public var scrollInt:Int = 0;
	public var vectorY:Vector<Int> = new Vector<Int>(0);
	public var vectorX:Vector<Int> = new Vector<Int>(0);
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
	public static var main:App;
	//Performance Idler
	/**
	 *  Set FrameRate when App is De Activated 
	 */
	public var idle:Int = 5;
	/**
	 *  Set Url's to Diffrent States
	 */
	public static var urlArray:Array<UrlState> = new Array<UrlState>();
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
	 * When Exit or android Back button are pressed
	 */
	public var onBack:Dynamic->Void;
	/**
	* When Mouse is up
	**/
	public var onMouseUp:Dynamic->Void;
	/**
	 * 
	 * @param	sx Width of App
	 * @param	sy Height of App
	 */
	
	/**
	 * false = User not on application / minimized
	 */
	public var active:Bool = true;
	
	public function new(sx:Int=640,sy:Int=1136,_font:Font) 
	{
		super();
		font = _font;
		Lib.current.mouseEnabled = false;
		//set mobile 
		#if mobile
		mobile = true;
		#end
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
		#end
		#if mobile
		nativetext.NativeText.Initialize();
		#end
		
		setWidth = sx;
		setHeight = sy;
		mouseEnabled = false;
		main = this;
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		//add self
		Lib.current.addChild(this);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent)
		{
		if (state != null && pointRect(App.state.mouseX, App.state.mouseY, dragRect))
		{
		spX = App.state.mouseX;
		spY = App.state.mouseY;
		omX = spX;
		omY = spY;
		scrollPress = false;
		mouseDown = true;
		state.mouseDown();
		}
		});
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent)
		{
			mouseDown = false;
			if (state != null)
			{
			state.mouseUp();
			}
			if(onMouseUp != null)onMouseUp(e);
		});
		#if ! mobile
		if (!mobile)
		{
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL,function(e:MouseEvent)
		{
			mouseDown = false;
		});
		Lib.current.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			state.keyDown(e);
		});
		}
		#end
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{
			#if !mobile
			if(!mobile)state.keyUp(e);
			#end
			if (!backExit && e.keyCode == KeyCode.APP_CONTROL_BACK)
			{
			e.preventDefault();
			state.back(e);
			}
		});
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
		//set old
		oldSSX= App.scrollSpeedX;
		oldSSY = App.scrollSpeedY;
		
	if (App.dragBool && App.mouseDown)
	{
	App.scrollSpeedY = Math.round(App.state.mouseY - App.omY);
	App.scrollSpeedX = Math.round(App.state.mouseX - App.omX);
	}
		if (scrollBool && !App.mouseDown || moveBool)
		{
		App.scrollSpeedY = vectorY[scrollInt];
		App.scrollSpeedX = vectorX[scrollInt];
		if (scrollInt >= scrollDuration)
		{
		scrollBool = false;
		moveBool = false;
		scrollSpeedY = 0;
		scrollSpeedX = 0;
		}
		scrollInt ++;
		}
		//SEND OUT restrict events
		if (restrictInt > 0)
		{
			switch(restrictInt)
			{
				case 1:
				if(minEventY != null)minEventY();
				case 2:
				if(maxEventY != null)maxEventY();
				case 3:
				if(minEventX != null)minEventX();
				case 4:
				if(maxEventX != null)maxEventX();
			}
			restrictInt = 0;
		}
		//RESTRICT Y
	   if (App.main.cameraMinY != App.main.cameraMaxY)
	   {
		if (App.camY + App.scrollSpeedY > App.main.cameraMinY && App.scrollSpeedY >= 0)
		{
		App.scrollSpeedY = -App.camY + App.main.cameraMinY;
		scrollInt = scrollDuration + 1;
		if (minEventY != null) restrictInt = 1;
		}
		if (App.camY + App.scrollSpeedY < App.main.cameraMaxY && App.scrollSpeedY <= 0)
		{
		App.scrollSpeedY = -App.camY + App.main.cameraMaxY;
		scrollInt = scrollDuration + 1;
		if (maxEventY != null) restrictInt = 2;
		}
		//Speed
		App.camY += App.scrollSpeedY;
	   }
		//X
	   if (App.main.cameraMinX != App.main.cameraMaxX)
	   {
		if (App.camX + App.scrollSpeedX > App.main.cameraMinX && App.scrollSpeedX >= 0)
		{
		App.scrollSpeedX = -App.camX + App.main.cameraMinX;
		scrollInt = scrollDuration + 1;
		if (minEventX != null) restrictInt = 3;
		}
		if (App.camX + App.scrollSpeedX < App.main.cameraMaxX && App.scrollSpeedX <= 0)
		{
		App.scrollSpeedX = -App.camX + App.main.cameraMaxX;
		scrollInt = scrollDuration + 1;
		if (maxEventX != null) restrictInt = 4;
		}
		//speed 
		App.camX += App.scrollSpeedX;
		//infinite scroll
	   }
	   
			if (state != null)
			{
			state.update();
			omX = App.state.mouseX;
			omY = App.state.mouseY;
			}
		//update networkings
		if (network != null) network.update();
		}); 
		
		Lib.current.stage.addEventListener (openfl.events.Event.ACTIVATE, function (_) {
		Lib.current.stage.frameRate = 60;
		active = true;
		});
		
		Lib.current.stage.addEventListener (openfl.events.Event.DEACTIVATE, function (_) {
			scrollSpeedY = 0;
			active = false;
			Lib.current.stage.frameRate = 5;
		});
	}
	
		public static function scrollCamera()
		{
			//1950 / (1000 / 60) = 117;
			if (dragBool && !App.main.moveBool)
			{
			if (Math.abs(spY - App.state.mouseY) < 10) scrollPress = true;
			mouseDown = false;
			scrollDuration = 117;
			if (Math.abs(scrollSpeedY) > 0 && Math.abs(scrollSpeedY) < 70 || Math.abs(scrollSpeedX) > 0 && Math.abs(scrollSpeedX) < 70) scrollDuration = 80;
			//speed limiter
			var limit = 140;
			if (scrollSpeedY > limit) scrollSpeedY = limit;
			if (scrollSpeedY < -limit) scrollSpeedY = -limit;
			if (scrollSpeedX > limit) scrollSpeedX = limit;
			if (scrollSpeedX < limit) scrollSpeedX = -limit;
			
			App.main.vectorY = new Vector<Int>(scrollDuration);
			App.main.vectorX = new Vector<Int>(scrollDuration);
			
			for (i in 0...scrollDuration)
			{
				scrollSpeedY *= 0.95;
			   App.main.vectorY[i] = Math.round(scrollSpeedY);
			}
				for (i in 0...scrollDuration)
			{
				scrollSpeedX *= 0.95;
			   App.main.vectorX[i] = Math.round(scrollSpeedX);
			}
			App.main.scrollInt = 0;
			scrollDuration += -1;
			scrollBool = true;
			}
		}
			
			public static function enableCameraMovement()
			{
				scrollBool = true;
				dragBool = true;
			}
			public static function disableCameraMovment()
			{
				scrollBool = false;
				dragBool = false;
				scrollDuration = 0;
				scrollSpeedX = 0;
				scrollSpeedY = 0;
			}
			
			public static function moveCamera(dx:Float =0, dy:Float =0,frameX:Int=0,frameY:Int=0)
			{
				var disX:Float = 0;
				var disY:Float = 0;
				disX = dx;
				disY = dy;
				mouseDown = false;
				App.main.moveBool = true;
				scrollDuration = Math.floor(Math.max(frameX, frameY));
				
				App.main.vectorX = new Vector(frameX + 1);
				var vX:Int = Math.round(disX / frameX);
				for (i in 0...frameX)
				{
					App.main.vectorX[i] = vX;
				}
				App.main.vectorX[frameX] = 0;
				
				App.main.vectorY = new Vector(frameY + 1);
				var vY:Int = Math.round(disY / frameY);
				for (i in 0...frameY)
				{
					App.main.vectorY[i] = vY;
				}
				App.main.vectorY[frameY] = 0;
				
				App.main.scrollInt = 0;
			    scrollBool = true;
			}
	
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

public function getUrlParams(setName:String="")
	{
		#if html5
		var url = js.Browser.document.URL;
		var e:EReg = new EReg("\\?([" + Base64.CHARS + "]+)$", "");
		if (e.match(url)) {
		 var pos = url.indexOf("?", 0);
		 var pos2 = url.indexOf("/", pos);
		 var name = url.substring(pos + 1, pos2);
		 UrlState.data = url.substring(pos2 + 1, url.length);
		 trace("URL name " + name + " data " + UrlState.data);  
		 #else
		 UrlState.data = "0";
		 var name = setName;
		 #end
	for (urlObj in urlArray)
	{
			if (urlObj.name == name)
			{
				//timer to be able to remove state
				var k = new Timer(5);
				k.run = function()
				{
				App.state.remove();
				App.state = Type.createInstance(urlObj.state, []);
				k.stop();
				k = null;
				}
			}
	}
	#if html5
	}
	#end
	}

public static function toggleFullscreen() {
#if html5
trace("Toggle Full screen for html5 does not work yet :(");
            var isInFullScreen = untyped __js__("(document.fullscreenElement && document.fullscreenElement !== null) ||
            (document.webkitFullscreenElement && document.webkitFullscreenElement !== null) ||
            (document.mozFullScreenElement && document.mozFullScreenElement !== null) ||
            (document.msFullscreenElement && document.msFullscreenElement !== null);");
            if (isInFullScreen) {
                if (untyped __js__("document.exitFullscreen")) {
                    untyped __js__("document.exitFullscreen()");
                } else if (untyped __js__("document.webkitExitFullscreen")) {
                    untyped __js__("document.webkitExitFullscreen();");
                } else if (untyped __js__("document.mozCancelFullScreen")) {
                    untyped __js__("document.mozCancelFullScreen();");
                } else if (untyped __js__("document.msExitFullscreen")) {
                    untyped __js__("document.msExitFullscreen();");
                }
            }
            else {

                if (untyped __js__('document.getElementById("openfl-content").requestFullscreen')) {
                    untyped __js__('document.getElementById("openfl-content").requestFullscreen()');
                } else if (untyped __js__('document.getElementById("openfl-content").mozRequestFullScreen')) {
                    untyped __js__('document.getElementById("openfl-content").mozRequestFullScreen()');
                } else if (untyped __js__('document.getElementById("openfl-content").webkitRequestFullscreen')) {
                    untyped __js__('document.getElementById("openfl-content").webkitRequestFullscreen()');
                } else if (untyped __js__('document.getElementById("openfl-content").msRequestFullscreen')) {
                    untyped __js__('document.getElementById("openfl-content").msRequestFullscreen()');
                }
            }
#else
Lib.application.window.fullscreen = !Lib.application.window.fullscreen;
#end
        }
	/**
	 * 
	 * @param	original bitmap
	 * @param	axis x or y
	 * @return
	 */
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
		public static function createSprite(?x:Float = 0, ?y:Float = 0, path:String,w:Int=-1,h:Int=-1,oval:Bool=false):Shape
	{
		var shape = new Shape();
		var sub = path.substring(path.length - 4, path.length);
		if (sub == ".png" || sub == ".jpg")
		{
		var bmd = Assets.getBitmapData(path);
	var mat = new Matrix();
	var sx:Float = 1;
	var sy:Float = 1;
	if(w > 0) sx = 1 / bmd.width * w;
	if(h > 0) sy = 1 / bmd.height * h;
	mat.scale(sx, sy);
	shape.graphics.beginBitmapFill(bmd, mat, false, true);
	if (oval)
	{
	shape.graphics.drawEllipse(0, 0, sx * bmd.width, sy * bmd.height);	
	}else{
	shape.graphics.drawRect(0, 0, sx * bmd.width, sy * bmd.height);
	}
		}else{
		if (oval) trace("vector graphic does not support Oval");
		new SVG(Assets.getText(path)).render(shape.graphics, 0, 0, w, h);
		}
		shape.x = x;
		shape.y = y;
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

	public static function createToggleSlider(?x:Int, ?y:Int, size:Int = 80):core.Item.ToggleSlider
	{
		return new core.Item.ToggleSlider(x,y,size);
	}
	/**
	 * A custom ThinQbator round rectangle that's meant for our TextBubble Ui in code alternative.
	 * @param	x
	 * @param	y
	 * @param	width
	 * @param	height
	 * @param	curve
	 * @return
	 */
	public static function createTextBubble(?x:Int, ?y:Int, width:Int, height:Int,curve:Int=50):Shape
	{
		var txtBox = new Shape();
		txtBox.graphics.beginGradientFill(GradientType.RADIAL, [11193343, 16777215], [0.2, 0.8], [0, 255]);
		txtBox.graphics.drawRoundRect(0, 0, width, height, curve, curve);
		txtBox.graphics.endFill();
		txtBox.x = x;
		txtBox.y = y;
		return txtBox;
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
		exit.graphics.beginFill(0, 0);
		exit.graphics.drawRect(0, 0, 60, 80);
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
	public static function createNextCircle(?x:Int = 0, ?y:Int, color:Int = 16777215, radius:Int = 40):Button
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
	public static function createNext(?x:Int = 0, ?y:Int = 0, color:Int = 16777215):Button
	{
		var nextButton = new Button(x + 28, y + 22);
		var thick:Int = 4;
		var radius:Int = 40;
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
		nextButton.graphics.drawRect( -40, -40, 80, 80);
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
		var tempX:Float = stage.stageWidth / setWidth;
		var tempY:Float = stage.stageHeight / setHeight;
		scale = Math.min(tempX, tempY);
		if (resizeBool)
		{
		App.state.resize(Math.floor((stage.stageWidth - setWidth * App.scale) / 2), 0, scale, scale);
		}
		}
		//call on resize
		if(onResize != null)onResize(e);
	}
/**
 * A way to set a bottom bar a header etc. Make's it so it can strech to the edges of the screen or be at absoulte postion x r
 * @param	obj
 * @param	widthBool
 */
		public static function setHeader(obj:DisplayObject,widthBool:Bool=true)
	{
		obj.x = -State.px * 1/App.scale;
		if(widthBool)obj.width = Lib.current.stage.stageWidth * 1/App.scale;
	}

}
