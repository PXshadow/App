package core;
import core.Button;
import core.State;
import core.Text;
import core.UrlState;
import core.Network;
import haxe.crypto.Base64;
import openfl.display.DisplayObjectContainer;

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
	public static var colorArray = [755381, 16761913, 11654726];
	//main
	public static var setWidth:Int = 0;
	public static var setHeight:Int =0;
	public static var scale:Float = 0;
	
	public static var state:State;
	public static var background:Bitmap;
	//old mouse postions
	public static var omX:Float = 0;
	public static var omY:Float = 0;
	
	public static var textFormat:String = "assets/data/proximanova-regular-webfont.ttf";
	//CameraScroll
	public var cameraMinY:Int = 0;
	public var cameraMaxY:Int = 0;
	public var cameraMinX:Int = 0;
	public var cameraMaxX:Int = 0;
	
	//if camera is scrolling used to have buttons not go off during
	public static var scrollPress:Bool = false;
	//start postion of scroll
	public static var dragBool:Bool = false;
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
	public var scrollInt:Int = 0;
	public var vectorY = new Vector(0);
	public var vectorX = new Vector(0);
	//debug
	/**
	 * Debug Text showing framerate elasped time,scale,memory,version,mobile bool
	 */
	public var info:InfoDebug;
	/**
	 * Set to False to Remove Info Bool
	 */
	public static var infoBool:Bool = true;
	/**
	 * color of Info Text Defualt Black = 0 white = 16777215
	 */
	public static var infoColor:Int = 0;
	//refrence self in static
	public static var main:App;
	//Performance Idler
	/**
	 *  Set FrameRate when App is De Activated 
	 */
	public var idle:Int = 5;
	private var oldFrameRate:Int = 0;
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
	 * mobile check for both html5 and native
	 */
	public static var mobile:Bool = false;
	/**
	 * lets stage be resized defualt true
	 */
	public static var resizeBool:Bool = true;
	/**
	 * 
	 * @param	sx Width of App
	 * @param	sy Height of App
	 */
	public function new(sx:Int=640,sy:Int=1136) 
	{
		super();
		oldFrameRate = Math.floor(Lib.current.stage.frameRate);
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
		//add background
		if (background != null) addChild(background);
		main = this;
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		//add self
		Lib.current.addChild(this);
		#if debug
		info = new InfoDebug(0);
		#end
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent)
		{
		if (state != null)
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
		});
		
#if !mobile
if (!mobile)
		{
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL,function(e:MouseEvent)
		{
			mouseDown = false;
		});
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			state.keyDown(e);
		});
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{
			state.keyUp(e);
		});
		}
#end
	
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, function(e:Event)
		{
		//set old
		oldSSX= App.scrollSpeedX;
		oldSSY = App.scrollSpeedY;
		
		if (App.mouseDown && App.dragBool)
		{
		App.scrollSpeedY = App.state.mouseY - App.omY;
		App.scrollSpeedX = App.state.mouseX - App.omX;
		}else{
		if (scrollBool)
		{
		App.scrollSpeedY = vectorY[scrollInt];
		App.scrollSpeedX = vectorX[scrollInt];
		if (scrollInt == scrollDuration)
		{
		scrollBool = false;
		scrollSpeedY = 0;
		scrollSpeedX = 0;
		}
		scrollInt ++;
		}
		}
	
		
	//RESTRICT Y
	if (App.main.cameraMinY != App.main.cameraMaxY)
	{
	if (App.camY + App.scrollSpeedY > App.main.cameraMinY && App.scrollSpeedY >= 0)
	{
		App.scrollSpeedY = -App.camY + App.main.cameraMinY;
		scrollInt = scrollDuration;
	}
	if (App.camY + App.scrollSpeedY < App.main.cameraMaxY && App.scrollSpeedY <= 0)
	{
		App.scrollSpeedY = -App.camY + App.main.cameraMaxY;
		scrollInt = scrollDuration;
	}
	}
	//X
	if (App.main.cameraMinX != App.main.cameraMaxX)
	{
	if (App.camX + App.scrollSpeedX > App.main.cameraMinX && App.scrollSpeedX >= 0)
	{
		App.scrollSpeedX = -App.camX + App.main.cameraMinX;
		scrollInt = scrollDuration;
	}
	if (App.camX + App.scrollSpeedX < App.main.cameraMaxX && App.scrollSpeedX <= 0)
	{
		App.scrollSpeedX = -App.camX + App.main.cameraMaxX;
		scrollInt = scrollDuration;
	}
	}
	
	App.camY += App.scrollSpeedY;
	App.camX += App.scrollSpeedX;
			if (info != null) info.onEnter();
			if (state != null)
			{
			state.update();
			omX = App.state.mouseX;
			omY = App.state.mouseY;
			}
		//update networkings
		if(network != null)network.update();
		}); 
		
		Lib.current.stage.addEventListener (openfl.events.Event.ACTIVATE, function (_) {
			Lib.current.stage.frameRate = oldFrameRate;
			
		});
		
		Lib.current.stage.addEventListener (openfl.events.Event.DEACTIVATE, function (_) {
			scrollSpeedY = 0;
			oldFrameRate = Math.floor(Lib.current.stage.frameRate);
			Lib.current.stage.frameRate = idle;
		});
		
	}
	
		public static function scrollCamera()
			{
				
				if (Math.abs(spY - App.state.mouseY) < 10) scrollPress = true;
			mouseDown = false;
			var framerate = Lib.current.stage.frameRate;
			if (App.main.info != null) framerate = App.main.info.tL;
			scrollDuration = Math.floor(1950 / (1000 / framerate));
			App.main.vectorY = new Vector(scrollDuration);
			App.main.vectorX = new Vector(scrollDuration);
			
			for (i in 0...scrollDuration)
			{
				scrollSpeedY *= 0.95;
			   App.main.vectorY[i] = scrollSpeedY;
			}
				for (i in 0...scrollDuration)
			{
				scrollSpeedX *= 0.95;
			   App.main.vectorX[i] = scrollSpeedX;
			}
			App.main.scrollInt = 0;
			scrollDuration += -1;
			scrollBool = true;
			
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
				scrollDuration = Math.floor(Math.max(frameX, frameY));
				
				if (frameX > 0)
				{
				App.main.vectorX = new Vector(frameX + 1);
				var vX = disX / frameX;
				for (i in 0...frameX)
				{
					App.main.vectorX[i] = vX;
				}
				App.main.vectorX[frameX] = 0;
				}
				
				if (frameY > 0)
				{
				App.main.vectorY = new Vector(frameY + 1);
				var vY = disY / frameY;
				for (i in 0...frameY)
				{
					App.main.vectorY[i] = vY;
				}
				App.main.vectorY[frameY] = 0;
				}
				App.main.scrollInt = 0;
			    scrollBool = true;
			}
	
		public static function cutShapeFromBitmapData( bitmapData : BitmapData, shape : Shape ):BitmapData {
    // Copy the shape to a bitmap
    var shapeBitmapData : BitmapData = new BitmapData( bitmapData.width, bitmapData.height, true, 0x00000000 );
    shapeBitmapData.draw( shape, shape.transform.matrix, null, null, null, true );
    // Now keep the alpha channel, but copy all other channels from the source
    var p : Point = new Point(0, 0);
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.RED, BitmapDataChannel.RED );
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN );
    shapeBitmapData.copyChannel( bitmapData, bitmapData.rect, p, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE );
    // Tada!
    return shapeBitmapData;
}

public function getUrlParams()
	{
		#if html5
		var url = js.Browser.document.URL;
		var e:EReg = new EReg("\\?([" + Base64.CHARS + "]+)$", "");
		if (e.match(url)) {
		 var pos = url.indexOf("?", 0);
		 var pos2 = url.indexOf("/", pos);
		   var name = url.substring(pos + 1, pos2);
		   UrlState.data = url.substring(pos2, url.length);
	for (urlObj in urlArray)
	{
			if (urlObj.name == name)
			{
				var k = new Timer(5);
				k.run = function()
				{
				App.state.remove();
				App.state = Type.createInstance(urlObj.state, []);
				App.state.initResize = true;
				App.background.visible = false;
				k.stop();
				k = null;
				}
			}
	}

	}
		#end	
	}
	
	public function initalLoaded()
	{
		getUrlParams();
		inital = false;
	}

public static function toggleFullscreen() {
#if html5
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
		public static function createSprite(?x:Float = 0, ?y:Float = 0, path:String,w:Int=-1,h:Int=-1):Shape
	{
		var shape = new Shape();
		if (path.substring(path.length - 4, path.length) == ".png")
		{
		var bitmap = Assets.getBitmapData(path);
		shape.graphics.beginBitmapFill(bitmap,null,true,true);
		shape.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
		shape.graphics.endFill();
		}else{
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
		var nextButton = new Button(x, y);
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
	public static function createText (?textString:String = "", ?x:Int = 0, ?y:Int = 0, ?size:Int = 24, ?color:Int, ?align:TextFormatAlign = TextFormatAlign.LEFT, fieldWidth:Int = 0, scaleAddAuto:Bool = true):Text
	{
	return new Text(x, y, fieldWidth, textString, size, color, align);
	}
	/**
	 * triggered Resize event that deals with all of the App's resizing calls and Math
	 * @param	_
	 */
	public function resize(_)
	{
		if (state != null)
		{
		//resize bg 
		if (background != null)
		{
		background.width = stage.stageWidth;
		background.height = stage.stageHeight;
		}
		var tempX:Float = stage.stageWidth / setWidth;
		var tempY:Float = stage.stageHeight / setHeight;
		scale = Math.min(tempX, tempY);
		if (resizeBool)
		{
		App.state.resize(Math.floor((stage.stageWidth - setWidth * App.scale) / 2), 0, scale, scale);
	    if(info != null)info.resize();
		}
		
		}
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
