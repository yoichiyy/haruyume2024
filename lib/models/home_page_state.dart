import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/monthly_book_count.dart';
import 'package:myapp/services/api.dart';

class HomePageStateData {
  // カウンター関連
  int harukaCounter = 0;
  int yumekoCounter = 0;
  int totalHaruka = 0;
  int totalYumeko = 0;
  int monthlyHaruka = 0;
  int monthlyYumeko = 0;

  // Haruka/Yumeko Ginko関連
  int haruGinko = 0;
  int yumeGinko = 0;
  int haruBonus = 0;
  int yumeBonus = 0;

  // RoutineS
  String haruROne = "";
  String haruRTwo = "";
  String haruRThree = "";
  String haruRFour = "";
  String yumeROne = "";
  String yumeRTwo = "";
  String yumeRThree = "";
  String yumeRFour = "";
  String mamaROne = "";
  String mamaRTwo = "";
  String mamaRThree = "";
  String mamaRFour = "";
  String papaROne = "";
  String papaRTwo = "";
  String papaRThree = "";
  String papaRFour = "";
  int mamaGinko = 0;
  int papaGinko = 0;
  int mamaBonus = 0;
  int papaBonus = 0;

  // ValueNotifier
  late ValueNotifier<String> currentHaruOne;
  late ValueNotifier<String> currentHaruTwo;
  late ValueNotifier<String> currentHaruThree;
  late ValueNotifier<String> currentHaruFour;
  late ValueNotifier<String> currentYumeOne;
  late ValueNotifier<String> currentYumeTwo;
  late ValueNotifier<String> currentYumeThree;
  late ValueNotifier<String> currentYumeFour;
  late ValueNotifier<String> currentMamaOne;
  late ValueNotifier<String> currentMamaTwo;
  late ValueNotifier<String> currentMamaThree;
  late ValueNotifier<String> currentMamaFour;
  late ValueNotifier<String> currentPapaOne;
  late ValueNotifier<String> currentPapaTwo;
  late ValueNotifier<String> currentPapaThree;
  late ValueNotifier<String> currentPapaFour;

  // 家計簿管理部分で使用される変数
  final TextEditingController kakeiController = TextEditingController();
  final TextEditingController kakeiNoteController = TextEditingController();
  final TextEditingController haruBonusNoteController = TextEditingController();
  final TextEditingController yumeBonusNoteController = TextEditingController();
  final TextEditingController mamaBonusNoteController = TextEditingController();
  final TextEditingController papaBonusNoteController = TextEditingController();

  HomePageStateData() {
    // ValueNotifierの初期化
    currentHaruOne = ValueNotifier<String>("");
    currentHaruTwo = ValueNotifier<String>("");
    currentHaruThree = ValueNotifier<String>("");
    currentHaruFour = ValueNotifier<String>("");
    currentYumeOne = ValueNotifier<String>("");
    currentYumeTwo = ValueNotifier<String>("");
    currentYumeThree = ValueNotifier<String>("");
    currentYumeFour = ValueNotifier<String>("");
    currentMamaOne = ValueNotifier<String>("");
    currentMamaTwo = ValueNotifier<String>("");
    currentMamaThree = ValueNotifier<String>("");
    currentMamaFour = ValueNotifier<String>("");
    currentPapaOne = ValueNotifier<String>("");
    currentPapaTwo = ValueNotifier<String>("");
    currentPapaThree = ValueNotifier<String>("");
    currentPapaFour = ValueNotifier<String>("");
  }

  void updateData(MonthlyBookCount initialData) {
    currentHaruOne.value = initialData.haruROne;
    currentHaruTwo.value = initialData.haruRTwo;
    currentHaruThree.value = initialData.haruRThree;
    currentHaruFour.value = initialData.haruRFour;
    currentYumeOne.value = initialData.yumeROne;
    currentYumeTwo.value = initialData.yumeRTwo;
    currentYumeThree.value = initialData.yumeRThree;
    currentYumeFour.value = initialData.yumeRFour;
    currentMamaOne.value = initialData.mamaROne;
    currentMamaTwo.value = initialData.mamaRTwo;
    currentMamaThree.value = initialData.mamaRThree;
    currentMamaFour.value = initialData.mamaRFour;
    currentPapaOne.value = initialData.papaROne;
    currentPapaTwo.value = initialData.papaRTwo;
    currentPapaThree.value = initialData.papaRThree;
    currentPapaFour.value = initialData.papaRFour;
    monthlyHaruka = initialData.monthlyHaruka;
    monthlyYumeko = initialData.monthlyYumeko;
    haruROne = initialData.haruROne;
    haruRTwo = initialData.haruRTwo;
    haruRThree = initialData.haruRThree;
    haruRFour = initialData.haruRFour;
    yumeROne = initialData.yumeROne;
    yumeRTwo = initialData.yumeRTwo;
    yumeRThree = initialData.yumeRThree;
    yumeRFour = initialData.yumeRFour;
    haruGinko = initialData.haruGinko;
    yumeGinko = initialData.yumeGinko;
    mamaROne = initialData.mamaROne;
    mamaRTwo = initialData.mamaRTwo;
    mamaRThree = initialData.mamaRThree;
    mamaRFour = initialData.mamaRFour;
    papaROne = initialData.papaROne;
    papaRTwo = initialData.papaRTwo;
    papaRThree = initialData.papaRThree;
    papaRFour = initialData.papaRFour;
    mamaGinko = initialData.mamaGinko;
    papaGinko = initialData.papaGinko;
  }

  void dispose() {
    currentHaruOne.dispose();
    currentHaruTwo.dispose();
    currentHaruThree.dispose();
    currentHaruFour.dispose();
    currentYumeOne.dispose();
    currentYumeTwo.dispose();
    currentYumeThree.dispose();
    currentYumeFour.dispose();
    currentMamaOne.dispose();
    currentMamaTwo.dispose();
    currentMamaThree.dispose();
    currentMamaFour.dispose();
    currentPapaOne.dispose();
    currentPapaTwo.dispose();
    currentPapaThree.dispose();
    currentPapaFour.dispose();
  }
}

Future<MonthlyBookCount> fetchInitialData() async {
  // try {
  final url = GoogleApiSettings.getGoogleBookSheet();
  final res = await http.get(Uri.parse(url));
  //中身のチェック
  final Map<String, dynamic> cellValues = json.decode(res.body);
  final List<dynamic> row3 = cellValues['values'][2];
  // debugPrint("■■■${row3.toString()}");

  if (row3.length >= 2) {
    final monthlyHaruka = int.tryParse(row3[1].toString()) ?? 0;
    final monthlyYumeko = int.tryParse(row3[2].toString()) ?? 0;
    final haruROne = row3[6].toString();
    final haruRTwo = row3[7].toString();
    final haruRThree = row3[8].toString();
    final haruRFour = row3[9].toString();
    final yumeROne = row3[10].toString();
    final yumeRTwo = row3[11].toString();
    final yumeRThree = row3[12].toString();
    final yumeRFour = row3[13].toString();
    final haruGinko = int.tryParse(row3[14].toString()) ?? 0;
    final yumeGinko = int.tryParse(row3[16].toString()) ?? 0;
    final mamaROne = row3[18].toString();
    final mamaRTwo = row3[19].toString();
    final mamaRThree = row3[20].toString();
    final mamaRFour = row3[21].toString();
    final papaROne = row3[22].toString();
    final papaRTwo = row3[23].toString();
    final papaRThree = row3[24].toString();
    final papaRFour = row3[25].toString();
    final mamaGinko = int.tryParse(row3[26].toString()) ?? 0;
    final papaGinko = int.tryParse(row3[28].toString()) ?? 0;

    return MonthlyBookCount(
      monthlyHaruka: monthlyHaruka,
      monthlyYumeko: monthlyYumeko,
      haruROne: haruROne,
      haruRTwo: haruRTwo,
      haruRThree: haruRThree,
      haruRFour: haruRFour,
      yumeROne: yumeROne,
      yumeRTwo: yumeRTwo,
      yumeRThree: yumeRThree,
      yumeRFour: yumeRFour,
      haruGinko: haruGinko,
      yumeGinko: yumeGinko,
      mamaROne: mamaROne,
      mamaRTwo: mamaRTwo,
      mamaRThree: mamaRThree,
      mamaRFour: mamaRFour,
      papaROne: papaROne,
      papaRTwo: papaRTwo,
      papaRThree: papaRThree,
      papaRFour: papaRFour,
      mamaGinko: mamaGinko,
      papaGinko: papaGinko,
    );
  } else {
    throw ('Invalid data format in B3 and C3 cells.');
  }
} //fetchInitData


