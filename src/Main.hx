package ;
import core.*;
import openfl.display.Sprite;
class Main extends Sprite
{
public function new()
{
    super();
    new App();
    App.state = new Init();
    removeChild(this);
}
}
class Init extends State 
{
    var scrollBar:core.Item.ScrollBar;
    public function new()
    {
        super();
        scrollBar = new core.Item.ScrollBar();
        addChild(scrollBar);
    }

    override public function mouseDown()
    {
        super.mouseDown();
        
    }
    override public function keyDown(_)
    {
        super.keyDown(_);
       
    }

}