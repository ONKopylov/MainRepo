#Использовать v8runner
#Использовать fs

Функция ПараметрыПодключения()
	
	мПарам = Новый Структура();
	мПарам.Вставить("Кластер", "DESKTOP-ISTU69K");
	мПарам.Вставить("ИмяБазы", "erp_tx_dev08_home");
	мПарам.Вставить("Пользователь", "Администратор");
	мПарам.Вставить("Пароль", "78951");
	мПарам.Вставить("ОбновитьКонфигурацию", Истина);

	//Загрузка Дт
	мПарам.Вставить("ЗагрузитьДТ", Ложь);
	мПарам.Вставить("ПапкаОбмена", "D:\Temp");
	мПарам.Вставить("ИмяФайлаДТ", "\1Cv8_20220501.dt");
	
	//Работа с хранилищем
	мПарам.Вставить("ПодключитьсяКХранилищу", Ложь);
	мПарам.Вставить("СтрокаСоединенияСХранилищем", "\\1cerp\Share\Storage\S7IT_MainConfig_2.5.7");
	мПарам.Вставить("ПользовательХранилища", "S7_Kopylov_2");
	мПарам.Вставить("ПарольХранилища","kisadm01");
	
	Возврат мПарам;
КонецФункции
Функция СформироватьСтрокуПодключения(мПарам)
	Рез = "/IBConnectionString""" + "Srvr=" + мПарам.Кластер + "; " + "Ref='" + мПарам.ИмяБазы + "'""";
	Возврат Рез;
КонецФункции

Конфигуратор = Новый УправлениеКонфигуратором();
мПарам = ПараметрыПодключения();
мСтрока = СформироватьСтрокуПодключения(мПарам);
Конфигуратор.УстановитьКонтекст(мСтрока, мПарам.Пользователь, мПарам.Пароль);

//Загрузка ДТ
Если мПарам.ЗагрузитьДТ Тогда
	ПутьДоФайлаДТ = мПарам.ПапкаОбмена + мПарам.ИмяФайлаДТ;
	ФайлДТ = Новый Файл(ПутьДоФайлаДТ);
	Если ФайлДТ.Существует() И ФайлДТ.ЭтоФайл() Тогда
		Попытка
			Конфигуратор.ЗагрузитьКонфигурациюИзФайла(ПутьДоФайлаДТ);
			Сообщить("Конфигурация загружена!");
		Исключение
			Сообщить("Ошибка при загрузки конфигурации: " + ОписаниеОшибки());
		КонецПопытки;
	Иначе
		Сообщить("Не найден файл для загрузки дт!");
	КонецЕсли;
КонецЕсли;

//Подключение к хранилищу
//Конфигуратор.ОтключитьсяОтХранилища();
Если мПарам.ПодключитьсяКХранилищу Тогда
	Попытка
		Сообщить("Начало подключения к хранилищу" + ТекущаяДата());
		Конфигуратор.ПодключитьсяКХранилищу(мПарам.СтрокаСоединенияСХранилищем, мПарам.ПользовательХранилища, мПарам.ПарольХранилища);
		Сообщить("Подключение к хранилищу выполнено успешно: " + ТекущаяДата());	
	Исключение
		Сообщить("Ошибка при подключении к хранилищу: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецЕсли;

Если мПарам.ОбновитьКонфигурацию Тогда
	Попытка
		Сообщить("Начало обновления конфигурации: " + ТекущаяДата());
		Конфигуратор.ОбновитьКонфигурациюБазыДанных();
		Сообщить("Обновление конфигурации БД выполнено успешно: " + ТекущаяДата());	
	Исключение
		Сообщить("Ошибка при подключении к хранилищу: " + ОписаниеОшибки());
	КонецПопытки;

КонецЕсли;