package core.display;

/**
 * ...
 * @author 
 */
class NavigationBar extends Button
{
    public var pressedSelection:Int->Void;
    public var selections:Array<String> = new Array<String>();
    public var color:Int;
    public var lineColor:Int;
    public var textColor:Int;
    var barWidth:Int;
    var barHeight:Int;
    public function new(sy:Int=0,selectArray:Array<String>,setBarWidth:Int=160,setBarHeight:Int=80,setColor:Int=16777215,setLineColor:Int=0,setTextColor:Int=0)
    {
        super();
        y = sy;
        barWidth = setBarWidth;
        barHeight = setBarHeight;
        color = setColor;
        lineColor = setLineColor;
        textColor = setLineColor;
        selections = selectArray;
        create();
        //check if maxed scale
        if(width > App.setWidth)
        {
            var dif = scaleX/scaleY;
            scaleX = 1/width * App.setWidth;
            scaleY = scaleX * dif;
        }
        //center
    }
    public function create()
    {
        graphics.beginFill(color);
        graphics.lineStyle(lineColor);

         for(i in 0...selections.length)
        {
        var px = i * barWidth;
        graphics.drawRoundRect(i * barWidth,0,barWidth,barHeight,50,50);
        var text = App.createText(selections[i],px,Math.floor(barHeight/4),Math.floor(barHeight/2),0,openfl.text.TextFormatAlign.CENTER,barWidth);
        addChild(text);
        }
    }
    override public function mouseDown(_)
    {

    }
    override public function mouseUp(_)
    {

    }
}
