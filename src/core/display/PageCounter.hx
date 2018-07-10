package core.display;
import openfl.display.Shape;

class PageCounter extends Shape
{
    public var color:Int = 0;
    public var activeColor:Int = 0;
    public var size:Int = 20;
    public var spacing:Int = 10;
   @:isVar public var page(get,set):Int=0;
   function get_page():Int
   {
       return page;
   }
   function set_page(value:Int):Int
   {
       if(value < amount && value >= 0)
       {
       page = value;
       create();
       }
       return page;
   }
    public var amount:Int=0;
    public var transparency:Float = 1;

    public function new(?sx:Int=0,?sy:Int=0,pages:Int=3,setSie:Int=19,setSpacing:Int=17,setColor:Int=14675188,setAlpha=1,setActiveColor:Int=4236519,startPage:Int=0)
    {
        super();
        x = sx + Math.floor(size/2);y = sy;
        color = setColor;
        activeColor = setActiveColor;
        size = setSie;
        amount = pages;
        page = startPage;
        transparency = setAlpha;
        spacing = setSpacing;
    }
    private function create()
    {
        graphics.clear();
        for(i in 0...amount)
        {
        if(page == i)
        {
        graphics.beginFill(activeColor);
        graphics.drawCircle((size + spacing) * i,size/2,size/2);
        graphics.endFill();
        }else{
        graphics.beginFill(color,transparency);
        graphics.drawCircle((size + spacing) * i,size/2,size/2);
        graphics.endFill();
		} 
		}
	}
}