package as3snapi.networks.mailru.features {
/**
 * Специфичное для mail.ru UI API
 */
public interface IFeatureMailruApiUi {
    /**
     * Показывает пользователю диалог оплаты.
     * http://api.mail.ru/docs/reference/js/payments.showDialog/
     *
     * @param service_id
     *     Идентификатор услуги (число), выбираемый по вашему усмотрению
     *     Этот идентификатор понадобится вам в момент оказания услуги для определения
     *     Для каждой конкретной услуги должен быть постоянным и не 0.
     * @param service_name
     *     Название услуги в именительном падеже (не более 40 символов).
     *     Для каждой услуги нужно определить постоянное название, например:
     *     "5 золотых", "бутылка вина", "Кожаная броня 2-ого уровня".
     *     В окне оплаты услуги заголовок будет: "Купить: service_name".
     *     Название приложения включать в название услуги не нужно.
     * @param mailiki_price
     *     Стоимость услуги в мэйликах.
     *     Минимальное значение 1 мэйлик
     */
    function paymentsShowDialog(service_id:int, service_name:String, mailiki_price:int):void;
}
}
