package;
import core.App;
import core.Item.ToggleSlider;
import core.State;
import core.UrlState;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author 
 */
class Main extends Sprite
{
	
	public function new() 
	{
		super();
		new core.App();
		core.App.state = new Init();
		removeChild(this);
	}
}

class Init extends core.State
{
	var screen:Bitmap;
	public function new()
	{
		super();
		var toggleSlider:ToggleSlider = App.createToggleSlider(30, 30);
		toggleSlider.toggle = function(b:Bool)
		{
			trace("toggle " + b);
		}
		addChild(toggleSlider);
	}
	
	override public function keyDown(e:openfl.events.KeyboardEvent) 
	{
		super.keyDown(e);
		addChild(screenShot());
	}
	override public function mouseDown() 
	{
		super.mouseDown();
		if (screen != null)
		{
		screen.x = mouseX;
		screen.y = mouseY;
		}
	}
	override public function mouseUp() 
	{
		super.mouseUp();
	}
}