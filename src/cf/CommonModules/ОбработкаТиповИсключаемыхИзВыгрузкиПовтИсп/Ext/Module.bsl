﻿
#Область СлужебныйПрограммныйИнтерфейс

// Возвращаемое значение: 
//	ФиксированноеСоответствие из КлючИЗначение:
//	 * Ключ - ОбъектМетаданных
//	 * Действие - Строка
Функция ДействияПриОбнаруженииСсылокНаТипыИсключаемыеИзВыгрузки() Экспорт

 	ДействияПриОбнаруженииСсылок = Новый Соответствие();
	ОписанияТипов = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ОписанияТиповИсключаемыхИзВыгрузкиЗагрузки();
	
	ТипФиксированнаяСтруктура = Тип("ФиксированнаяСтруктура");
	ТипСтруктура = Тип("Структура");	
		
	Для Каждого Описание Из ОписанияТипов Цикл
		ТипОписания = ТипЗнч(Описание);
		Если Не (ТипОписания = ТипФиксированнаяСтруктура Или ТипОписания = ТипСтруктура) Тогда
			Продолжить;
		КонецЕсли;

		ДействияПриОбнаруженииСсылок.Вставить(Описание.Тип, Описание.Действие);		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ДействияПриОбнаруженииСсылок);
	
КонецФункции

// Возвращаемое значение: 
//	см. ВыгрузкаЗагрузкаДанныхСлужебный.СсылкиНаТипы
//
Функция МетаданныеИмеющиеСсылкиНаТипыИсключаемыеИзВыгрузкиИТребующиеОбработки() Экспорт
	
	ДействияПриОбнаруженииСсылок = ОбработкаТиповИсключаемыхИзВыгрузкиПовтИсп.ДействияПриОбнаруженииСсылокНаТипыИсключаемыеИзВыгрузки();
	
	ОбъектыМетаданныхТребующиеОбработки = Новый Массив();
	
	Для Каждого КлючЗначение Из ДействияПриОбнаруженииСсылок Цикл
		
		Если КлючЗначение.Значение = ВыгрузкаЗагрузкаДанных.ДействиеСоСсылкамиНеИзменять() Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектыМетаданныхТребующиеОбработки.Добавить(КлючЗначение.Ключ);
			
	КонецЦикла;
					
	ТипыИсключаемыеИзВыгрузкиЗагрузки =	ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	ПолныеИменаТиповИсключаемыхИзВыгрузкиЗагрузки = Новый Соответствие();
	Для Каждого ТипИсключаемыйИзВыгрузкиЗагрузки Из ТипыИсключаемыеИзВыгрузкиЗагрузки Цикл
		ПолныеИменаТиповИсключаемыхИзВыгрузкиЗагрузки.Вставить(
			ТипИсключаемыйИзВыгрузкиЗагрузки.ПолноеИмя(),
			Истина);
	КонецЦикла;
	
	СсылкиНаОбъектыМетаданных = ВыгрузкаЗагрузкаДанныхСлужебный.СсылкиНаОбъектыМетаданных(ОбъектыМетаданныхТребующиеОбработки);		
	СсылкиНаОбъектыМетаданныхТребующиеОбработки = Новый Соответствие();
		
	Для Каждого КлючЗначение Из СсылкиНаОбъектыМетаданных Цикл
		
		ПолноеИмяОбъектаМетаданных = КлючЗначение.Ключ;
				
		Если ПолныеИменаТиповИсключаемыхИзВыгрузкиЗагрузки.Получить(ПолноеИмяОбъектаМетаданных) = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		СсылкиНаОбъектыМетаданныхТребующиеОбработки.Вставить(
			ПолноеИмяОбъектаМетаданных,
			КлючЗначение.Значение);
			
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СсылкиНаОбъектыМетаданныхТребующиеОбработки);
	
КонецФункции

#КонецОбласти
