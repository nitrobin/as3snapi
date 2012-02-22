package as3snapi.feautures.core.javascript {

/**
 * Вспомогательный класс работы с JavaScript-функциями требующими callback функции в качестве параметров.
 * Реализует механизм передачи обычные функции ActionScript качестве параметров.
 * Автоматически генерирует вспомогательный код для обратного вызова.
 */
public class JavaScriptUtils {
    private var javaScript:IFeatureJavaScript;
    private var objectId:String;

    private var name:String;
    private var callbacks:Object = {};
    private var nextCbid:int = 1;

    public function JavaScriptUtils(javaScript:IFeatureJavaScript, objectId:String = null) {
        this.javaScript = javaScript;
        this.objectId = objectId;
        this.name = "callback" + int(Math.random() * 1000000);
        javaScript.addCallback(name, callback);
    }

    private function getObjectId():String {
        return objectId || javaScript.getObjectId();
    }

    /**
     * Колбек для вызова из js
     * @param cbid
     * @param argsIn
     */
    private function callback(cbid:int, argsIn:Object):void {
        // Если argsIn задать как Array , то будет Type Coercion Error Object to Array
        // Поэтому извращаемся с перепаковкой в Array
        var args:Array = [];
        for (var i:String in argsIn) {
            args[int(i)] = argsIn[i];
        }
        var f:Function = callbacks[cbid] as Function;
        if (f != null) {
            f.apply(null, args);
        }
    }


    /**
     * Вернуть строку js функции для вызова флэшного коллбека
     * @param cbid
     * @return
     */
    private function makeClosureCode(cbid:int):String {
        // Без Array.prototype.slice.call может передавать пустой объект в некоторых браузерах
        return "(function(){document.getElementById('%flashId%').%name%(%cbid%, Array.prototype.slice.call(arguments))})"
                .replace("%flashId%", getObjectId())
                .replace("%name%", name)
                .replace("%cbid%", cbid);
    }

    private function bindCall(callback:Function):int {
        var cbid:int = nextCbid++;
        callbacks[cbid] = callback;
        return cbid;
    }

    private function unbindCall(cbid:int):void {
        delete callbacks[cbid];
    }

    /**
     * Забиндить вечный вызов
     * @param callback
     * @return
     */
    public function createClosure(callback:Function):String {
        var cbid:int = bindCall(callback);
        return makeClosureCode(cbid);
    }

    /**
     * Забиндить одноразовый вызов
     * @param callback
     * @return
     */
    public function createOneShotClosure(callback:Function):String {
        var cbid:int = bindCall(disposeCallback);

        function disposeCallback(...args):void {
            callback.apply(null, args);
            unbindCall(cbid)
        }

        return makeClosureCode(cbid);
    }

    /**
     * Вызвать js функцию с параметрами rest.
     * В качестве параметров поддерживаются ссылки на функции внутри флэш приложения, например замыкания.
     * @param functionName
     * @param rest
     */
    public function callSmart(functionName:String, ...rest):void {
        //TODO Добавить тесты на производительность
        var values:Array = [];
        var valuesNames:Array = [];
        var callArgs:Array = [];
        for (var i:int = 0; i < rest.length; i++) {
            var value:* = rest[i];
            if (value is Function) {
                callArgs.push(createOneShotClosure(value));
            } else if (value is OnceCall) {
                callArgs.push(createOneShotClosure(OnceCall(value).callback));
            } else if (value is PermanentCall) {
                callArgs.push(createClosure(PermanentCall(value).callback));
            } else {
                var argName:String = "a" + i;
                callArgs.push(argName);
                valuesNames.push(argName);
                values.push(value);
            }
        }
        var js:String = "function(" + valuesNames.join(",") + "){" + functionName + "(" + callArgs.join(",") + ")}";
        javaScript.call.apply(null, [js].concat(values));
    }

    public function once(callback:Function):* {
        return new OnceCall(callback);
    }

    public function permanent(callback:Function):* {
        return new PermanentCall(callback);
    }
}
}

internal class OnceCall {
    public var callback:Function;

    public function OnceCall(callback:Function) {
        this.callback = callback;
    }
}

internal class PermanentCall {
    public var callback:Function;

    public function PermanentCall(callback:Function) {
        this.callback = callback;
    }
}
