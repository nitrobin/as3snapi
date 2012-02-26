package com.api.forticom//.SignUtil 
{
import com.adobe.crypto.MD5;

/**
 * @author Erik <erya14@gmail.com>
 * @date 15/02/2010 16:57
 * @description ...
 */
public class SignUtil {
    public static var applicationKey:String;
    public static var sessionKey:String;
    public static var secretSessionKey:String;
    public static var secretKey:String;

    public static function signRequest(data:Object, exeption:Boolean = false, format:String = "XML"):Object {
        data["format"] = format;
        data["application_key"] = SignUtil.applicationKey;
        if (data['uid'] == undefined || exeption)
            data["session_key"] = SignUtil.sessionKey;

        var sig:String = '';
        var keys:Array = [], key:String;
        for (key in data) {
            keys.push(key);
        }
        keys.sort();
        var i:int = 0, l:int = keys.length;
        for (i; i < l; i++) {
            sig += keys[i] + "=" + data[keys[i]];
        }
        sig += (data['uid'] != undefined && !exeption) ? SignUtil.secretKey : SignUtil.secretSessionKey;

        data["sig"] = MD5.hash(sig).toLowerCase();
        return data;
    }

}

}