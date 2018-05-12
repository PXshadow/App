package;


import lime.system.CFFI;
import lime.system.JNI;


class Statusbar {
	
	
	public static function set () {
		
		#if !android
		return sampleextension_sample_method();
		#end
		
		
	}
	
	
	private static var sampleextension_sample_method = CFFI.load ("Statusbar", "Main", 1);
	
	/*#if android
	private static var sampleextension_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.SampleExtension", "sampleMethod", "(I)I");
	#end*/
	
	
}