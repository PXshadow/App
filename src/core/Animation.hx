package core;

@:enum abstract Animation(Null<Int>) from Int to Int {
	
	//animations
	public var NONE:Int = 0;
	public var SLIDEUP:Int = 1;
	public var SLIDEDOWN:Int = 2;
	public var SLIDERIGHT:Int = 3;
	public var SLIDELEFT:Int = 4;
	public var SLIDEINLEFT:Int = 5;
	public var SLIDEINRIGHT:Int = 6;
	public var SLIDEINUP:Int = 7;
	public var SLIDEINDOWN:Int = 8;
	public var FADEIN:Int = 9;
	public var OVERLAYUP:Int = 10;
	public var OVERLAYDOWN:Int = 11;
	public var OVERLAYLEFT:Int = 12;
	public var OVERLAYRIGHT:Int = 13;
	
}