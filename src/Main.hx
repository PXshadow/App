package;
import core.App;
import core.Item.ToggleSlider;
import core.Network;
import core.State;
import core.UrlState;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.KeyboardEvent;
import core.App;

/**
 * ...
 * @author 
 */
class Main extends Sprite
{
	
	public function new() 
	{
		super();
		new App();
		App.state = new Init();
		removeChild(this);
		App.network = new Network("174.66.172.96", 9696);
		
		
	}
}

class Init extends core.State
{
	public function new()
	{
		super();
		var time = new Timer(200);
		time.run = function()
		{
		App.network.onMessage = message;
		time.stop();
		}
	}
	
	public function message(data:Dynamic)
	{
		trace("data " + data);
	}
	
	override public function keyDown(e:openfl.events.KeyboardEvent) 
	{
		super.keyDown(e);
		App.network.send({v:0, u:"hey", p:"hi"});
	}
}