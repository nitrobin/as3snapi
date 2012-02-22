package as3snapi.utils {
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

/**
 * Вспомогательные функции для работы с ActionScript вариациями на тему перечислений (enum).
 *
 * Пример:
 *
 * public class MyEnum {
 *     public static const CODE0:int = 0;
 *     public static const CODE1:int = 1;
 *     public static const CODE2:int = 1;
 * }
 */
public class EnumUtils {
    /**
     * Получить имя константы определенной в классе enumClass и хранящей значение code
     * @param enumClass класс для поиска
     * @param code значение константы
     * @param shortCls использовать сокращенное имя класса, без пакета
     *
     * @return  Имя_класса + "." + имя_константы
     */
    public static function getName(enumClass:Class, code:*, shortCls:Boolean = true):String {
        var info:XML = describeType(enumClass);
        var typeName:String = info.@name;
        if (shortCls) {
            typeName = typeName.split("::")[1];
        }
        for each(var type:String in ['int', 'uint', 'Number', 'String']) {
            for each (var xml:XML in info.constant.(@type = type)) {
                var name:String = xml.@name;
                if (enumClass[name] == code) {
                    return typeName + '.' + name;
                }
            }
        }
        return null;
    }

    /**
     * Получить короткое имя класса
     * @param clazz
     * @return
     */
    public static function getShortClassName(clazz:Class):String {
        return getQualifiedClassName(clazz).split("::")[1];
    }
}
}
