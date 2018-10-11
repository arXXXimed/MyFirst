//Белпа мед
Процедура ВыгрузитьБелпаМед(ТаблицаЗаказа, НастройкаЗагрузкиПрайсов, Аптека)
	
	Перем ИмяFTPСервера, ИмяКаталогаСервера, Соединение;
	
	//создадим файлик
	ИмяКаталога = КаталогВременныхФайлов();
	
	Если НастройкаЗагрузкиПрайсов.ФайловыйКаталог <> "" Тогда
		ИмяКаталога = НастройкаЗагрузкиПрайсов.ФайловыйКаталог;
	КонецЕсли;
	
	ИмяФайла 	= СтрЗаменить(СокрЛП(Аптека.Код), " ", "_") + "_" + Формат(ТекущаяДата(), "ДФ=ddMM"); //Наименование

	Контрагент 	=  НастройкаЗагрузкиПрайсов.Контрагент;
	
	ДобавитьКИмениФайлаДневнойКод(ИмяФайла, Контрагент, Аптека);
	
	ТабДок = новый ТабличныйДокумент;
	Макет  = Справочники.НастройкиЗагрузкиПрайсов.ПолучитьМакет("БелпаМед");
	ОблШапки = Макет.ПолучитьОбласть("Шапка");	
	ПозицияРазделителя = Найти(Строка(Аптека.Наименование), "№");
	НомерАпт = Сред(Строка(Аптека.Наименование), ПозицияРазделителя);
	ОблШапки.Параметры.Аптека = "" + Аптека.Организация	+ ", аптека " + НомерАпт;
	ОблШапки.Параметры.Адрес  = Аптека.АдресДоставки;
	ОблШапки.Параметры.Дата = ТекущаяДата();
	ОблШапки.Параметры.Позиций = ТаблицаЗаказа.Количество();
	
	СУммаЗак = 0;
	Для Каждого СтрокаТ Из ТаблицаЗаказа Цикл
		СУммаЗак = СУммаЗак + Окр(СтрокаТ.ЦенаПоставщика*СтрокаТ.Количество, 2);	
	КонецЦикла;	
	ОблШапки.Параметры.Сумма = СУммаЗак;
	
	ТабДок.Вывести(ОблШапки);
	Сч = 1;
	ИтогоКол = 0;
	
	Для Каждого СтрЗаказа Из ТаблицаЗаказа Цикл
		
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
		НаименованиеПрепаратаПоставщика = СтрЗаказа.НаименованиеПрепаратаПоставщика;
		ОбластьСтроки.Параметры.Номер = Сч;
		ОбластьСтроки.Параметры.ШК = СтрЗаказа.Штрихкод;
		ОбластьСтроки.Параметры.Наименование = НаименованиеПрепаратаПоставщика;
		ОбластьСтроки.Параметры.Производитель = СтрЗаказа.Производитель;
		ОбластьСтроки.Параметры.Цена = СтрЗаказа.ЦенаПоставщика; 
		ОбластьСтроки.Параметры.Количество = СтрЗаказа.Количество; 
		ОбластьСтроки.Параметры.Сумма = Окр(СтрЗаказа.ЦенаПоставщика*СтрЗаказа.Количество, 2); 
		ТабДок.Вывести(ОбластьСтроки);
		Сч = Сч + 1;
		ИтогоКол = ИтогоКол + СтрЗаказа.Количество;
		
	КонецЦикла;	
