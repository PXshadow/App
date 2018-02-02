package nativetext;
    
    
typedef NativeTextFieldConfig = {
    ?x : Float,
    ?y : Float,
    ?width : Float,
    ?height : Float,
    ?visible : Bool,
    ?enabled : Bool,
    ?isPassword : Bool,
    ?placeholder : String,
    ?fontAsset : String,
    ?fontSize : Int,
    ?fontColor : Int,
    ?textAlignment : NativeTextFieldAlignment,
    ?keyboardType : NativeTextFieldKeyboardType,
    ?returnKeyType : NativeTextFieldReturnKeyType,
    ?multiline: Bool, // It works only during creating
	?placeholderColor:Int,
	?backgroundColor:Int
};
