package core.display;
import core.Button;
/**
 * ...
 * @author 
 */
class Option extends Button
{
    public var type:Int = 0;
    public var list:Array<String> = new Array<String>();
    public var vertical:Bool;
    /**
    * Type 0 = Check box single select, Type 1 = Check box multi select , Type 2 = option single select, Type 3 = option multi select.
    **/
    public function new(setType:Int=0,?sx:Int=0,?sy:Int=0,array:Array<String>,setVertical:Bool=true)
    {
        type = setType;
        list = array;
        vertical = setVertical;
        super(sx,sy);
        switch(type)
        {
            case 0:
            for(i in 0...list.length)
            {
                
            }
        }
    }
    override public function mouseDown(_)
    {

    }
    override public function mouseUp(_)
    {

    }
}