package;
import core.*;
import openfl.display.Sprite;

class Main extends Sprite
{
    public function new()
    {
        super();
        //set width and height
        new App(640,480);
        App.state = new Menu();
        //Configure
        /*
        //Boolean to enable InfoDebugText Only works in DebugMode, infoDebugText in Release is never rendered.
        App.infoBool = true;
        //InfoText color as an int 
        App.infoColor = 16777215;
        //InfoTextfield size
        App.infoSize = 15;
        //set bitmap background
        App.background = new openfl.display.Bitmap(new openfl.display.BitmapData(App.setWidth,App.setHeight,false,0));
        //creates a tcp socket on Native/Neko and WebSocket on html5, boolean controls if the same message can be sent again. 
        App.network = new Network("127.0.0.1",200,false);
        //array of Integer colors to be used throughout the App, defualt is a blue, yellow and green for ThinQbator.
        App.colorArray = [0,16777215];
        //toggle full screen, can Also use openfl.Lib.application.window.fullscreen = true;
        App.toggleFullscreen();
        //UrlArray sub directories to the html5 page used to direct to States. Contact me if you would like to use this, It also needs code on every State and is not extremly automated yet.
        //App.urlArray = ["Menu",Menu]; 
        */
        removeChild(this);
    }
}

class Menu extends State
{
    public function new()
    {
        super();
        addChild(new Item.ScrollBar(0,App.setHeight,40,false));
        //addChild(new Item.ScrollBar(0,0,40,true));
    }
}