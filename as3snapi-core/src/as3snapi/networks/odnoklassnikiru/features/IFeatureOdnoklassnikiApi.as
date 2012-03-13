package as3snapi.networks.odnoklassnikiru.features {
public interface IFeatureOdnoklassnikiApi {
    function apiRequest(method:String, params:Object, onSuccess:Function, onFail:Function, exeption:Boolean = false):void ;
}
}
