package core;

/**
 * ...
 * @author 
 */
class Font
{
	public var name:String;
	//type
	public var regular:String;
	public var bold:String;
	public var italic:String;
	public var medium:String;
	public var semibold:String;
	//dynamic
	public var format:String;
	
	public function new(_name:String,defualt:String,_regular:String,_bold:String="",_italic:String="",_medium:String="",_semibold:String="")
	{
		format = defualt;
		regular = _regular;
		if(_bold != "")bold = _bold;
		if(_italic != "")italic = _italic;
		if (_medium != "") medium = _medium;
		if (_semibold != "") semibold = _semibold;
		set(_name);
	}
	
	public function set(name:String)
	{
		if (key.exists(name))
		{
		var cacheSet = cache[key.get("name")];
		cacheSet.regular = regular;
		cacheSet.bold = bold;
		cacheSet.italic = italic;
		cacheSet.medium = medium;
		format = regular;
		}else{
		key.set(name, cache.push({regular:regular, bold:bold, italic:italic, medium:medium,semi:semibold}));
		format = regular;
		}
	}
	public function get(name:String)
	{
		var cacheGet = cache[key.get(name)];
		regular = cacheGet.regular;
		bold = cacheGet.bold;
		italic = cacheGet.italic;
		medium = cacheGet.medium;
		semibold = cacheGet.semi;
	}
	public var cache:Array<{regular:String,bold:String,italic:String,medium:String,semi:String}> = [];
	public var key:Map<String,Int> = new Map<String,Int>();
}