package as3snapi.feautures.core.requester {
public interface IFeatureHttpRequester {
    function doRequest(url:String, params:Object, method:String, dataFormat:String, onSuccess:Function, onFail:Function):void

    function doRequestJson(url:String, params:Object, method:String, onSuccess:Function, onFail:Function):void

    function doRequest2(url:String, params:Object, method:String, dataFormat:String, handler:IHttpResponseHandler):void

    function doRequestJson2(url:String, params:Object, method:String, handler:IHttpResponseJsonHandler):void
}
}
