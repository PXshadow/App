
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
- Input text with Placeholder
- Easy Asset creation
- Custom Scaling Engine with setting Object Headers (No streching or black bars)
- Info section at bottom with Fps counter, memory , scaling, version , and Mobile bool

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

## Usage

add a new extended State Class [Inital State]
```
new App();
App.state = new [Inital State]();
removeChild(this);
```

## TODO

- Add Api docs page
- Comment everything
