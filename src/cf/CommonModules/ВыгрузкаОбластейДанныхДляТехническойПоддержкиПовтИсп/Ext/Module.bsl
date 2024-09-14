﻿
#Область СлужебныйПрограммныйИнтерфейс

// Метаданные исключаемые из выгрузки в режиме для технической поддержки.
// 
// Возвращаемое значение: 
//  ФиксированныйМассив из ОбъектМетаданных
Функция МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки() Экспорт
	
	МетаданныеИсключаемыеИзВыгрузки = Новый Массив;
	
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииМетаданныхИсключаемыхИзВыгрузкиВРежимеДляТехническойПоддержки(МетаданныеИсключаемыеИзВыгрузки);
	
	МетаданныеОпределяемогоТипаПрисоединенныйФайл = Метаданные.ОпределяемыеТипы.Найти("ПрисоединенныйФайл");
	Если МетаданныеОпределяемогоТипаПрисоединенныйФайл <> Неопределено Тогда
		ТипыПрисоединенныхФайлов = МетаданныеОпределяемогоТипаПрисоединенныйФайл.Тип.Типы(); // Массив Из Тип
		Для Каждого ТипПрисоединенногоФайла Из ТипыПрисоединенныхФайлов Цикл
			МетаданныеПрисоединенногоФайла = Метаданные.НайтиПоТипу(ТипПрисоединенногоФайла);
			МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеПрисоединенногоФайла);
		КонецЦикла;		
	КонецЕсли;

	МетаданныеРегистраВерсииОбъектов = Метаданные.РегистрыСведений.Найти("ВерсииОбъектов");
	Если МетаданныеРегистраВерсииОбъектов <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраВерсииОбъектов);		
	КонецЕсли;
	
	МетаданныеРегистраДвоичныеДанныеФайлов = Метаданные.РегистрыСведений.Найти("ДвоичныеДанныеФайлов");
	Если МетаданныеРегистраДвоичныеДанныеФайлов <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраДвоичныеДанныеФайлов);		
	КонецЕсли;
	
	МетаданныеРегистраСведенияОФайлах = Метаданные.РегистрыСведений.Найти("СведенияОФайлах");
	Если МетаданныеРегистраСведенияОФайлах <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраСведенияОФайлах);		
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.СвернутьМассив(МетаданныеИсключаемыеИзВыгрузки);
	
	Возврат Новый ФиксированныйМассив(МетаданныеИсключаемыеИзВыгрузки);
	
КонецФункции

// Метаданные имеющие ссылки на исключаемые из выгрузки в режиме для технической поддержки.
// 
// Возвращаемое значение: 
//	ФиксированноеСоответствие - см. ВыгрузкаЗагрузкаДанныхСлужебный.СсылкиНаТипы
//
Функция МетаданныеИмеющиеСсылкиНаИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки() Экспорт
	
	МетаданныеИсключаемыеИзВыгрузки = ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки();
	Возврат ВыгрузкаЗагрузкаДанныхСлужебный.СсылкиНаОбъектыМетаданных(МетаданныеИсключаемыеИзВыгрузки);
	
КонецФункции

#КонецОбласти
