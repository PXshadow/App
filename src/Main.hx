package;
import core.App;
import core.State;
import core.UrlState;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class Main extends Sprite
{
	
	public function new() 
	{
		super();
		core.App.urlArray = [new core.UrlState("init", Init)];
		App.infoBool = false;
		new core.App();
		core.App.state = new Init();
		removeChild(this);
		
	}
}

class Init extends core.State
{
	public function new()
	{
		super();
	}
}