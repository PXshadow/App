package ;
import openfl.display.Sprite;
import core.App;
import core.Item.ScrollBar;
import core.Item.NavigationBar;
import core.State;
import openfl.display.Shape;


class Main extends Sprite
{
    public function new()
    {
        super();
        new App();
        App.state = new Menu();
    }
}

class Menu extends State
{
    var scrollBar:ScrollBar;
    var navBar:NavigationBar;

    public function new()
    {
        super();
        scrollBar = new ScrollBar(0,0);
        addChild(scrollBar);
        for(i in 0...10)
        {
            var shape = new Shape();
            shape.graphics.beginFill(0);
            shape.graphics.drawRect(0,0,10,10);
            shape.graphics.endFill();
            shape.y = i * 40 ;
            shape.x = App.setWidth/2;
            scrollBar.scrollView.push(shape);
            addChild(shape);
        }

        navBar = new NavigationBar(50,["Why","is","this","such","a","bad","talk"]);
        addChild(navBar);
    }
    override public function mouseDown()
    {
        super.mouseDown();
    }
    override public function mouseUp()
    {
        super.mouseUp();
    }

}