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
		
		
	}
}

class Init extends core.State
{
	var text:InputText;
	public function new()
	{
		super();

		var profile = new ProfileIcon(0,0,"assets/data/1.png");
		addChild(profile);
		
		text = new InputText(100, 100, "Hello world", 20, 200, 0);
		addChild(text);

	}
	

}