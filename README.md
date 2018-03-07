
# App, is an openFl UI libary devolped for ThinQbator production use.
- [Getting Started](https://github.com/PXshadow/App/wiki/Getting-Started)
- [Contact me](https://github.com/PXshadow/App/wiki/Contact)
- [Haxelib](https://lib.haxe.org/p/app)
![icon](https://static.wixstatic.com/media/070b20_d1d024bcce924b86b555be7c8f1f21a4~mv2_d_1732_2812_s_2.png/v1/fill/w_196,h_319,al_c,usm_0.66_1.00_0.01/070b20_d1d024bcce924b86b555be7c8f1f21a4~mv2_d_1732_2812_s_2.png)
[ThinQbator](https://www.thinqbator.net/)
## Features
States
- Mobile Native Scrolling mimiced to be IOS
- Web Socket Client Networking
- Url States
- Camera Restrictions
- Buttons
- Input text with Placeholder and NativeText implementation for ios and android.
- Easy Asset creation
- Custom Scaling Engine with setting Object Headers (No streching or black bars)

## Installation

Add the library to your `project.xml`:

```xml
<haxelib name="app" />
```

And use `haxelib` to install it:

Github Version
```shell
haxelib git app https://github.com/PXshadow/App
```
Haxelib Version 
```shell
haxelib install app
```

## Inital Setup 
Main.hx File 
```
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
        
    }
}
```

## TODO
- Create more Widgets and get feedback.
- Optomization 
- Demo Projects
