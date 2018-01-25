package core;

/**
 * ...
 * @author 
 */
class UrlState 
{
	public var name:String;
	public static var data:String;
	public var state:Class<State>;
	
	public function new(Name:String,stateObj:Dynamic)
	{
		name = Name;
		state = stateObj;
	}
	
}