package as3snapi.base.features.javascript {
public interface IFeatureJavaScript {

    function isAvailable():Boolean;

    function getObjectId():String;

    function call(functionName:String, ...rest):*;

    function addCallback(functionName:String, closure:Function):void;

}
}
