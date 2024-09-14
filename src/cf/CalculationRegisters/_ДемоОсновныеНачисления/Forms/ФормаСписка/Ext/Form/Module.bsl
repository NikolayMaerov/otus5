﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Параметры.Отбор.Свойство("Организация", ОтборОрганизация);
	УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", ОтборОрганизация);
	
	Параметры.Отбор.Свойство("Регистратор", ОтборРегистратор);
	УстановитьЭлементОтбораДинамическогоСписка(Список, "Регистратор", ОтборРегистратор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", ОтборОрганизация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРегистраторПриИзменении(Элемент)
	
	УстановитьЭлементОтбораДинамическогоСписка(Список, "Регистратор", ОтборРегистратор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереключитьАктивностьДвижений(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.Регистратор) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбран документ'"));
		Возврат;
	КонецЕсли;
	
	ПереключитьАктивностьДвиженийСервер(ТекущиеДанные.Регистратор);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();

	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сторно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьАктивностьДвиженийСервер(Документ)
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрРасчета._ДемоОсновныеНачисления.НаборЗаписей");
		ЭлементБлокировкиДанных.УстановитьЗначение("Регистратор", Документ);
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Документ.Метаданные().ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Документ);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
		БлокировкаДанных.Заблокировать();
		
		ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ПометкаУдаления");
		
		Если ПометкаУдаления <> Неопределено И Не ПометкаУдаления Тогда
			
			Движения = РегистрыРасчета._ДемоОсновныеНачисления.СоздатьНаборЗаписей();
			Движения.Отбор.Регистратор.Установить(Документ);
			Движения.Прочитать();
			
			Если Движения.Количество() > 0 Тогда
				Движения.УстановитьАктивность(Не Движения[0].Активность);
				Движения.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЭлементОтбораДинамическогоСписка(Знач ДинамическийСписок, Знач ИмяПоля, Знач ПравоеЗначение, Знач ВидСравнения = Неопределено)
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ДинамическийСписок.Отбор, ИмяПоля, ПравоеЗначение, ВидСравнения, ,
		ЗначениеЗаполнено(ПравоеЗначение), РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

#КонецОбласти
