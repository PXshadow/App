package;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import src.app.State;
import src.app.App;
import src.app.UrlState;
import src.app.Networking;

/**
 * ...
 * @author 
 */
class Main extends Sprite
{
	
	public function new() 
	{
		super();
		App.urlArray = [new UrlState("init", Init)];
		new App();
		App.state = new Init();
		removeChild(this);
		
	}
}

class Init extends State
{
	public function new()
	{
		super();
	}
}