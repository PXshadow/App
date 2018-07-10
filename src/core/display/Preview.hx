package core.display;

/**
 * ...
 * @author 
 */
class Preview extends Window
{
    public function new(asset:String="assets/openfl.png",live:Int=0,windowWidth:Int=600,windowHeight:Int=300)
    {
        super();
        Lib.application.createWindow(this);
        borderless = true;
        width = windowWidth;
        height = windowHeight;
        focus();
        x = Math.floor(Lib.current.stage.fullScreenWidth/2 - width/2);
        y = Math.floor(Lib.current.stage.fullScreenHeight/2 - height/2);
        if(live > 0)
        {
        var timer = new haxe.Timer(live);
        timer.run = function()
        {
            close();
            timer.stop();
            timer = null;
        }
        }

    Assets.loadBitmapData(asset).onComplete(function(data:BitmapData)
    {
    var bitmap = new Bitmap(data);
    bitmap.x = width/2 - bitmap.width/2;
    bitmap.y = height/2 - bitmap.height/2;

    var text = new TextField();
    text.selectable = false;text.mouseEnabled = false;
    text.y = bitmap.y + bitmap.height + 1;
    text.defaultTextFormat = new openfl.text.TextFormat(null,24,0,false,false,false,null,null,openfl.text.TextFormatAlign.CENTER);
    text.width = width;
    text.text = "Version " + application.config.version;
    stage.addChild(text);
    stage.addChild(bitmap);
    });

    }
}