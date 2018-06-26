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
	public var light:String;
	//dynamic
	public var format:String;
	
	public function new(_name:String,defualt:String,_regular:String,_bold:String="",_italic:String="",_light:String="")
	{
		format = defualt;
		regular = _regular;
		if(_bold != "")bold = _bold;
		if(_italic != "")italic = _italic;
		if (_light != "") light = _light;
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
		cacheSet.light = light;
		format = regular;
		}else{
		key.set(name, cache.push({regular:regular, bold:bold, italic:italic, light:light}));
		format = regular;
		}
	}
	public function get(name:String)
	{
		var cacheGet = cache[key.get(name)];
		regular = cacheGet.regular;
		bold = cacheGet.bold;
		italic = cacheGet.italic;
		light = cacheGet.light;
	}
	public var cache:Array<{regular:String,bold:String,italic:String,light:String}> = [];
	public var key:Map<String,Int> = new Map<String,Int>();
}