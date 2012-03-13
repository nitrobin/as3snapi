package as3snapi.base.features.requester {
public interface IFeatureHttpRequester {
    function doRequest(url:String, params:Object, method:String, dataFormat:String, onSuccess:Function, onFail:Function):void

    function doRequestJson(url:String, params:Object, method:String, onSuccess:Function, onFail:Function):void
}
}
