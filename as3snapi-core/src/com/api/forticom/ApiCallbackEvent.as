package com.api.forticom//.ApiCallbackEvent
{

import flash.events.Event;

/**
 * This class does not have any description yet
 *
 * @author erik.podrez
 * @date Jun 10, 2010 3:48:31 PM
 */

public class ApiCallbackEvent extends Event {
    public static const CALL_BACK:String = "call_back_event";

    protected var _method:String;
    protected var _result:String;
    protected var _data:String;

    public function ApiCallbackEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false, $method:String = "null", $result:String = "", $data:String = "") {
        super($type, $bubbles, $cancelable);

        this._method = $method;
        this._result = $result;
        this._data = $data;
    }

    public function get method():String {
        return this._method;
    }

    public function get result():String {
        return this._result;
    }

    public function get data():String {
        return this._data;
    }

    override public function clone():Event {
        return new ApiCallbackEvent(this.type, this.bubbles, this.cancelable, this.method, this.result, this.data);
    }

}

}