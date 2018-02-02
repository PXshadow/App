package;
import core.App;
import core.InputText;
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
import core.Item.ProfileIcon;

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
		//App.network = new Network("localhost", 9696);
		//App.network = new Network("174.66.172.96", 9696,false);
		
		
	}
}

class Init extends core.State
{
	public function new()
	{
		super();

		var profile = new ProfileIcon(0,0,"assets/data/1.png");
		addChild(profile);
		
		var text = new InputText(100, 100, "Hello world", 20, 200);
		addChild(text);

	}
	
	override public function keyDown(e:openfl.events.KeyboardEvent) 
	{
		super.keyDown(e);
		
	}
}