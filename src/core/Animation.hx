package core;

@:enum abstract Animation(Null<Int>) from Int to Int {
	
	//animations
	public var NONE:Int = 0;
	public var SLIDEUP:Int = 1;
	public var SLIDEDOWN:Int = 2;
	public var SLIDERIGHT:Int = 3;
	public var SLIDELEFT:Int = 4;
	public var FADEIN:Int = 5;
	public var FADEOUT:Int = 6;
	public var OVERLAYUP:Int = 7;
	public var OVERLAYDOWN:Int = 8;
	public var OVERLAYLEFT:Int = 9;
	public var OVERLAYRIGHT:Int = 10;
	
}