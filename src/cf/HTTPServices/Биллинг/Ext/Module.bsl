﻿#Область ОбработчикиСобытий

// Обработчик метода GET /version
//
Функция ВерсияПолучить(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Данные = Новый Структура;
	Данные.Вставить("version", ОплатаСервиса.ВерсияИнтерфейса());
	ОплатаСервиса.ДобавитьЗаголовкиДанных(Ответ);
	Ответ.УстановитьТелоИзСтроки(ОплатаСервиса.СтрокаJSON(Данные));
	
	ОплатаСервиса.ЛогироватьHTTPЗапрос(Запрос, Ответ);
	
	Возврат Ответ;
	
КонецФункции

// Обработчик метода POST /setup
//
// Параметры URL:
//  Версия - Строка - версия интерфейса в числовом виде
//
Функция УстановитьНастройкиДобавить(Запрос)

	Попытка
		
		Данные = ОплатаСервиса.ДанныеJSON(Запрос.ПолучитьТелоКакСтроку());
		
		ОбязательныеСвойства = СтрРазделить("version,url,login,password,subscriber",",");
		ОтсутствующиеСвойства = Новый Массив;
		Для Каждого Свойство Из ОбязательныеСвойства Цикл
			Если Не Данные.Свойство(Свойство) Тогда
				ОтсутствующиеСвойства.Добавить(Свойство);
			КонецЕсли;
		КонецЦикла;
		
		Если ОтсутствующиеСвойства.Количество() > 0 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Отсутствуют обязательные свойства: %1'"), 
				СтрСоединить(ОтсутствующиеСвойства, ", "));
			Ответ = ОтветОшибка(10400, ТекстОшибки);
			Возврат Ответ;
		КонецЕсли;
		
		ВерсияИнтерфейса = Данные.version;
		
		Если ВерсияИнтерфейса > ОплатаСервиса.ВерсияИнтерфейса() Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Версия интерфейса оплат %1 менеджера сервиса не поддерживается приложением.'"), ВерсияИнтерфейса); 
			Ответ = ОтветОшибка(10400, ТекстОшибки);
			Возврат Ответ;
		КонецЕсли; 
		
		Константы.АдресСервиса1СФреш.Установить(Данные.url);
		Константы.ИмяПользователяУчетнойСистемы.Установить(Данные.login);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ОплатаСервиса.ВладелецПароляАвторизацииВУчетнойСистеме(), Данные.password);
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		РегистрыСведений.АвторизацияВСервисе1СФреш.ДобавитьЗапись(
			ТекущийПользователь, Данные.login, Данные.password, Данные.subscriber);  
		
		Если ОплатаСервиса.ПоддерживаетсяЗагрузкаТарифов() Тогда
			ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка тарифов сервиса.'");
			ПараметрыВыполнения.ОжидатьЗавершение = 0;
			ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ОплатаСервиса.ЗагрузитьТарифыСервиса");
		КонецЕсли;
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтрШаблон(НСтр("ru='Не удалось прочитать данные по причине: %1'"), 
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Ответ = ОтветОшибка(10400,  ТекстОшибки);
		ОплатаСервиса.ЛогироватьHTTPЗапрос(Запрос, Ответ);
		
		ЗаписьЖурналаРегистрации(ОплатаСервиса.ИмяСобытия(НСтр("ru='Ошибка данных'")), 
			УровеньЖурналаРегистрации.Ошибка, Метаданные.HTTPСервисы.Биллинг, , 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)); 
		
		Возврат Ответ;
		
	КонецПопытки;
		
	Ответ = Новый HTTPСервисОтвет(200);
	ДанныеОтвета = ОплатаСервиса.ШаблонДанныхОтвета();
	ОплатаСервиса.ДобавитьЗаголовкиДанных(Ответ);
	Ответ.УстановитьТелоИзСтроки(ОплатаСервиса.СтрокаJSON(ДанныеОтвета));
	ОплатаСервиса.ЛогироватьHTTPЗапрос(Запрос, Ответ);
	
	Возврат Ответ;	
	
КонецФункции

// Обработчик метода POST /bill/{Версия}/*
//
// Параметры URL:
//  Версия - Строка - версия интерфейса в числовом виде
//
Функция СчетНаОплатуДобавить(Запрос)
	
	Возврат ОтветЗапросаСчетаНаОплату(Запрос);
	
КонецФункции

// Обработчик метода PUT /bill/{Версия}/*
//
// Параметры URL:
//  Версия - версия интерфейса.
//  
Функция СчетНаОплатуИзменить(Запрос)
	
	Возврат ОтветЗапросаСчетаНаОплату(Запрос);
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтветЗапросаСчетаНаОплату(Запрос)
	
	Попытка
		ДанныеЗапроса = ОплатаСервиса.ДанныеЗапросаСчетаНаОплату(Запрос);
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтрШаблон(НСтр("ru='Не удалось прочитать данные по причине: %1'"), 
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Ответ = ОтветОшибка(ОплатаСервиса.КодВозвратаОшибкаДанных(),  ТекстОшибки);
		ОплатаСервиса.ЛогироватьHTTPЗапрос(Запрос, Ответ);
		
		ЗаписьЖурналаРегистрации(ОплатаСервиса.ИмяСобытия(НСтр("ru='Ошибка данных'")), 
			УровеньЖурналаРегистрации.Ошибка, Метаданные.HTTPСервисы.Биллинг, , 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)); 
		
		Возврат Ответ;
		
	КонецПопытки;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ДанныеЗапроса.ИдентификаторСчета);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтрШаблон(
		НСтр("ru='Подготовка счета на оплату по запросу %1.'"), ДанныеЗапроса.ИдентификаторСчета);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ОплатаСервиса.ПодготовитьСчетНаОплату", ДанныеЗапроса);
	
	Ответ = Новый HTTPСервисОтвет(200);
	ДанныеОтвета = ОплатаСервиса.ШаблонДанныхОтвета();
	ОплатаСервиса.ДобавитьЗаголовкиДанных(Ответ);
	Ответ.УстановитьТелоИзСтроки(ОплатаСервиса.СтрокаJSON(ДанныеОтвета));
	ОплатаСервиса.ЛогироватьHTTPЗапрос(Запрос, Ответ);
	
	Возврат Ответ;	

КонецФункции

Функция ОтветОшибка(КодОшибки, ТекстОшибки)
	
	Ответ = Новый HTTPСервисОтвет(400);
	Данные = ОплатаСервиса.ШаблонДанныхОтвета(КодОшибки, ТекстОшибки);
	ОплатаСервиса.ДобавитьЗаголовкиДанных(Ответ);
	Ответ.УстановитьТелоИзСтроки(ОплатаСервиса.СтрокаJSON(Данные));
	Возврат Ответ;
	
КонецФункции
  
#КонецОбласти 

