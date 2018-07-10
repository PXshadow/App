package core.display;
import openfl.events.Event;
/**
 * ...
 * @author 
 */
class ScrollBar extends Button
{
    public var downBool:Bool = false;
    public var moveDistance:Float = 0;
    public var scrollView:Array<openfl.display.DisplayObject> = [];
    private var sx:Int = 0;
    private var sy:Int = 0;

     public function new(?x:Int=0,?y:Int=0,dem:Int = 40)
 {
     sx = x;sy = y;
     super(sx,sy);
     create(Math.floor(dem/2));
     addEventListener(Event.ENTER_FRAME,update);
     scaleX = 0.7;
     scaleY = 0.9;
 }
 private function create(rad:Int)
 {
    var color:Int = 14474460;
     //add circles to both side
     graphics.beginFill(color);
     graphics.drawCircle(rad + 1,rad,rad + 2);
     graphics.beginFill(color);
     graphics.drawCircle(rad + 1,-2 + rad * 5,rad + 2);
     //rect
     graphics.beginFill(color);
     graphics.drawRect(0,rad,rad * 2 + 2,rad * 4 + 4);
     //create line
    graphics.lineStyle(4,color);
    graphics.moveTo(2,rad);graphics.lineTo(rad * 2,rad);
    graphics.lineStyle(4,color);
    graphics.moveTo(2,rad * 5 + 4);graphics.lineTo(rad * 2,rad * 5 + 4);
    App.main.onResize = resize;
 }
 override public function mouseDown(_)
 {
     super.mouseDown(_);
     trace("mouseOut " + mouseOut);
     downBool = true;
     App.state.dragBool = true;
 }
 public function setRelease(_)
 {
     downBool = false;
     App.state.scrollCamera();
 }
  public function update(_)
  {
    //move all Objects in Scroll View
    if(Math.abs(App.state.scrollSpeed) > 0)
    {
    for(obj in scrollView)
    {
        obj.y += App.state.scrollSpeed;
    }
    y += App.state.scrollSpeed;
    if(y < -height/2)y = App.setHeight - height/2;
    if(y > App.setHeight - height/2)y = -height/2;
    }else{
    if(!downBool)App.state.dragBool = false;
    }
  }
  override public function removeFromStage(_)
 {
     super.removeFromStage(_);
     removeEventListener(Event.ENTER_FRAME,update);
 }
 public function resize(_)
 {
     this.x = (-State.px + openfl.Lib.current.stage.stageWidth) * 1/App.scale - width;
     
 }
}
