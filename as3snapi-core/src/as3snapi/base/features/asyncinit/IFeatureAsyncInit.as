package as3snapi.base.features.asyncinit {

/**
 * Вспомогательная фича, для сетей требующих асинхронной инициализации api
 */
public interface IFeatureAsyncInit {
    function init(handler:IAsyncInitHandler):void
}
}
