﻿#language: ru

@tree

Функционал: <описание фичи>

Как <Роль> я хочу
<описание функционала> 
чтобы <бизнес-эффект> 

Сценарий: <описание сценария> 



	И В командном интерфейсе я выбираю 'Справочники' 'Демо: Контрагенты'
	Тогда открылось окно 'Демо: Контрагенты'
	И я нажимаю на кнопку с именем 'ФормаСоздать'
	Тогда открылось окно 'Демо: Контрагент (создание)'
	И в поле с именем 'Наименование' я ввожу текст 'ТестовыйКА'
	И в поле с именем 'НаименованиеПолное' я ввожу текст '12345'
	И В панели открытых я выбираю 'Демо: Контрагенты'
	Тогда открылось окно 'Демо: Контрагенты'
	И В панели открытых я выбираю 'Демо: Контрагент (создание) *'
	Тогда открылось окно 'Демо: Контрагент (создание) *'
	И я нажимаю на кнопку с именем 'ФормаЗаписатьИЗакрыть'
	И я жду закрытия окна 'Демо: Контрагент (создание) *' в течение 20 секунд

