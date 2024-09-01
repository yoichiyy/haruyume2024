import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/home_card_kakei.dart';
import 'package:myapp/settings/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class MonthlyBookCount {
  MonthlyBookCount({
    required this.monthlyHaruka,
    required this.monthlyYumeko,
    required this.haruROne,
    required this.haruRTwo,
    required this.haruRThree,
    required this.haruRFour,
    required this.yumeROne,
    required this.yumeRTwo,
    required this.yumeRThree,
    required this.yumeRFour,
    required this.haruGinko,
    required this.yumeGinko,
    required this.mamaROne,
    required this.mamaRTwo,
    required this.mamaRThree,
    required this.mamaRFour,
    required this.papaROne,
    required this.papaRTwo,
    required this.papaRThree,
    required this.papaRFour,
    required this.mamaGinko,
    required this.papaGinko,
  });
  final int monthlyHaruka;
  final int monthlyYumeko;
  final String haruROne;
  final String haruRTwo;
  final String haruRThree;
  final String haruRFour;
  final String yumeROne;
  final String yumeRTwo;
  final String yumeRThree;
  final String yumeRFour;
  final int haruGinko;
  final int yumeGinko;
  final String mamaROne;
  final String mamaRTwo;
  final String mamaRThree;
  final String mamaRFour;
  final String papaROne;
  final String papaRTwo;
  final String papaRThree;
  final String papaRFour;
  final int mamaGinko;
  final int papaGinko;
}

class HomePageState extends State<HomePage> {
  int harukaCounter = 0;
  int yumekoCounter = 0;
  int totalHaruka = 0;
  int totalYumeko = 0;
  int monthlyHaruka = 0;
  int monthlyYumeko = 0;
  String haruROne = "";
  String haruRTwo = "";
  String haruRThree = "";
  String haruRFour = "";
  String yumeROne = "";
  String yumeRTwo = "";
  String yumeRThree = "";
  String yumeRFour = "";
  int haruGinko = 0;
  int yumeGinko = 0;
  int haruBonus = 0;
  int yumeBonus = 0;
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
  final kakeiController = TextEditingController();
  final kakeiNoteController = TextEditingController();
  final haruBonusNoteController = TextEditingController();
  final yumeBonusNoteController = TextEditingController();
  final mamaBonusNoteController = TextEditingController();
  final papaBonusNoteController = TextEditingController();

  // final bool _isLoading = true; // データ取得中かどうかのフラグ

  void _checked(int index) {
    setState(() {
      checkedList.clear();
      checkedList.add(index);
    });
  }

  void _unchecked(int index) {
    setState(() {
      checkedList.remove(index);
    });
  }

  String category = "";
  final List<IconData> categoryIconList = [
    Icons.dining,
    Icons.coffee,
    Icons.fastfood,
    Icons.directions_run,
    Icons.local_hospital,
    Icons.sports_kabaddi,
    Icons.currency_rupee,
    Icons.menu_book,
    Icons.local_fire_department,
    Icons.train,
    Icons.pest_control_rodent,
    Icons.bedtime,
    Icons.cottage,
    Icons.electric_bolt,
    Icons.android,
  ];

  final List<String> categoryList = [
    "食事",
    "嗜好品",
    "外食",
    "健康",
    "医療",
    "衣服",
    "投資",
    "本",
    "GIVE",
    "交通",
    "日用品",
    "その他",
    "家",
    "水光熱",
    "子ども",
  ];

  int castId = 0;
  final List<int> checkedList = [];

  //confetti
  final _controllerHaru =
      ConfettiController(duration: const Duration(milliseconds: 500));
  final _controllerYume =
      ConfettiController(duration: const Duration(milliseconds: 500));
  void _confettiEventHaru() {
    setState(() {
      _controllerHaru.play();
    });
  }

  void _confettiEventYume() {
    setState(() {
      _controllerYume.play();
    });
  }

  @override
  void initState() {
    super.initState();
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

    //データ取得
    _fetchInitialData().then((initialData) {
      setState(() {
        // データ取得後に ValueNotifier を更新
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
      });
    }).catchError((error) {
      // エラーハンドリング
      debugPrint('Error fetching initial data: $error');
    });
  }

  @override
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

    super.dispose();
  }

  //スプレッドシートからデータを取得
  static Future<MonthlyBookCount> _fetchInitialData() async {
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

  Future<void> _addToSheetInBackground() async {
    //家計簿用
    await APIS.addKakeiboToSheet(
        kakeiController.text, category, kakeiNoteController.text);
  }

  // Increment methods
  void _incrementHaruka() {
    setState(() {
      harukaCounter++;
      monthlyHaruka++;
    });
  }

  void _incrementYumeko() {
    setState(() {
      yumekoCounter++;
      monthlyYumeko++;
    });
  }

  void _incrementMama() {
    setState(() {
      harukaCounter++;
      monthlyHaruka++;
    });
  }

  void _incrementPapa() {
    setState(() {
      yumekoCounter++;
      monthlyYumeko++;
    });
  }

  void _incrementHaruGinko() {
    setState(() {
      haruGinko++;
    });
  }

  void _incrementYumeGinko() {
    setState(() {
      yumeGinko++;
    });
  }

  void _incrementMamaGinko() {
    setState(() {
      mamaGinko++;
    });
  }

  void _incrementPapaGinko() {
    setState(() {
      papaGinko++;
    });
  }

  void _incrementHaruBonus() {
    setState(() {
      haruBonus++;
    });
  }

  void _incrementYumeBonus() {
    setState(() {
      yumeBonus++;
    });
  }

  void _incrementMamaBonus() {
    setState(() {
      haruBonus++;
    });
  }

  void _incrementPapaBonus() {
    setState(() {
      yumeBonus++;
    });
  }

  // Helper method to cycle button text
  String _cycleButtonText(
      String currentText, String originalText, String cell) {
    if (currentText != "◯" && currentText != "／") {
      if (cell == 'F4' || cell == 'G4' || cell == 'H4' || cell == 'I4') {
        _incrementHaruGinko();
      } else {
        _incrementYumeGinko();
      }
      return "◯";
    } else if (currentText == "◯") {
      return "／";
    } else if (currentText == "／") {
      return "☓";
    } else {
      return originalText;
    }
  }

  // Helper widget for Haru buttons
  Widget _buildRoutineButton(
      ValueNotifier<String> currentTextNotifier, String originalText, cell) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ValueListenableBuilder<String>(
        valueListenable: currentTextNotifier,
        builder: (context, currentText, _) {
          return ElevatedButton(
            onPressed: () {
              currentTextNotifier.value =
                  _cycleButtonText(currentText, originalText, cell);
              APIS.addRoutineToSheet(currentTextNotifier.value, cell);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: currentText == "◯" ? Colors.pink[100] : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(currentText),
          );
        },
      ),
    );
  }

  //描画部分
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('はるゆめ絵本'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //晴加ボタン
                  Column(
                    children: [
                      // Row(
                      // children: [
                      // SizedBox(
                      //   width: 60,
                      //   height: 60,
                      //   child: Image.asset(
                      //     'assets/yumekawa_animal_unicorn.png',
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          child: const Text("はるか"),
                          onPressed: () {
                            _incrementHaruka();
                            // HapticFeedback.mediumImpact();
                            _confettiEventHaru();
                          },
                        ),
                      ),
                      // ],
                      // ),
                      ConfettiWidget(
                        confettiController: _controllerHaru,
                        blastDirectionality: BlastDirectionality.explosive,
                        blastDirection: pi / 2,
                        // 紙吹雪を出す方向(この場合画面上に向けて発射)
                        emissionFrequency: 0.9, // 発射頻度(数が小さいほど紙と紙の間隔が狭くなる)
                        minBlastForce: 5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
                        maxBlastForce:
                            10, // 紙吹雪の出る瞬間の5フレーム分の速度の最大(数が大きほど紙吹雪は遠くに飛んでいきます。)
                        numberOfParticles: 7, // 1秒あたりの紙の枚数
                        gravity: 0.5, // 紙の落ちる速さ(0~1で0だとちょーゆっくり)
                        colors: const <Color>[
                          // 紙吹雪の色指定
                          Colors.red,
                          Colors.blue,
                          //最初Colorsでなく、Constants、となっていた。
                          Colors.green,
                        ],
                      ),
                      //ボタン下スペース
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '今月: ', // この部分はデフォルトのスタイルを適用
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$monthlyHaruka', // この部分だけフォントサイズ20に変更
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'カウンター: ', // この部分はデフォルトのスタイルを適用
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$harukaCounter', // この部分だけフォントサイズ20に変更
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 50),
                  //夢子ボタン
                  Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          child: const Text("ゆめこ"),
                          onPressed: () {
                            // HapticFeedback.mediumImpact();
                            _incrementYumeko();
                            _confettiEventYume();
                            debugPrint("confetti実行");
                          },
                        ),
                      ),
                      // ],
                      // ),
                      ConfettiWidget(
                        confettiController: _controllerYume,
                        blastDirectionality: BlastDirectionality.explosive,
                        blastDirection: pi / 2,
                        // 紙吹雪を出す方向(この場合画面上に向けて発射)
                        emissionFrequency: 0.9, // 発射頻度(数が小さいほど紙と紙の間隔が狭くなる)
                        minBlastForce: 5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
                        maxBlastForce:
                            10, // 紙吹雪の出る瞬間の5フレーム分の速度の最大(数が大きほど紙吹雪は遠くに飛んでいきます。)
                        numberOfParticles: 7, // 1秒あたりの紙の枚数
                        gravity: 0.5, // 紙の落ちる速さ(0~1で0だとちょーゆっくり)
                        colors: const <Color>[
                          // 紙吹雪の色指定
                          Colors.red,
                          Colors.blue,
                          //最初Colorsでなく、Constants、となっていた。
                          Colors.green,
                        ],
                      ),
                      //ボタン下スペース
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '今月: ', // この部分はデフォルトのスタイルを適用
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$monthlyYumeko', // この部分だけフォントサイズ20に変更
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'カウンター: ', // この部分はデフォルトのスタイルを適用
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$yumekoCounter', // この部分だけフォントサイズ20に変更
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  APIS.addBookToSheet(harukaCounter, yumekoCounter);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('おめでとうございます。'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(milliseconds: 400),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 2 - 50),
                    ),
                  );
                },
                child: const Text('送信'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    harukaCounter = 0;
                    yumekoCounter = 0;
                  });
                },
                child: const Text('リセット'),
              ),
              const SizedBox(height: 20),

              //子ども銀行
              HomeCardWidgetKakei(
                  title: "子ども",
                  color: const Color(0xFF00C0FF),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              //左列　はるか銀行R
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'はるか  $haruGinko',
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 8),
                                _buildRoutineButton(
                                    currentHaruOne, haruROne, "B4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentHaruTwo, haruRTwo, "C4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentHaruThree, haruRThree, "D4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentHaruFour, haruRFour, "E4"),
                                const SizedBox(height: 60),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                            onTap: () {
                                              _incrementHaruBonus();
                                            },
                                            child: Image.asset(
                                              'assets/yumekawa_animal_unicorn.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$haruBonus',
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: haruBonusNoteController,
                                        decoration: const InputDecoration(
                                            hintText: "note"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.lightBlue.shade900,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        FocusScope.of(context).unfocus();
                                        if (haruBonusNoteController
                                            .text.isEmpty) {
                                          showDialog<AlertDialog>(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                title: Text("Oops"),
                                                content: Text("ちゃんと書きなさい"),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          APIS.addBonusToSheet(
                                              "haruBonus",
                                              haruBonus,
                                              haruBonusNoteController.text);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('おめでとうございます。'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2 -
                                                    50),
                                          ),
                                        );
                                        setState(() {
                                          haruBonusNoteController.clear();
                                          haruBonus = 0;
                                        });
                                      },
                                      child: const Text(
                                        "Bonus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              //中央列の絵
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50),
                                Image.asset(
                                  'assets/osara_color.png',
                                  width: 56,
                                  height: 56,
                                ),
                                const SizedBox(height: 4),
                                Image.asset(
                                  'assets/syufu_otetsudai.png',
                                  width: 56,
                                  height: 56,
                                ),
                                const SizedBox(height: 4),
                                Image.asset(
                                  'assets/shoes_kutsu_soroeru.png',
                                  width: 56,
                                  height: 56,
                                ),
                                const SizedBox(height: 4),
                                Image.asset(
                                  'assets/hamster_sleeping_golden.png',
                                  width: 56,
                                  height: 56,
                                ),
                              ],
                            ),
                            Column(
                              // 右列夢子銀行 Column
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ゆめこ  $yumeGinko',
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 8),
                                _buildRoutineButton(
                                    currentYumeOne, yumeROne, "F4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentYumeTwo, yumeRTwo, "G4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentYumeThree, yumeRThree, "H4"),
                                const SizedBox(height: 27),
                                _buildRoutineButton(
                                    currentYumeFour, yumeRFour, "I4"),
                                const SizedBox(height: 60),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                            onTap: () {
                                              _incrementYumeBonus();
                                            },
                                            child: Image.asset(
                                              'assets/animal_happa_tanuki.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$yumeBonus',
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: yumeBonusNoteController,
                                        decoration: const InputDecoration(
                                            hintText: "note"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.lightBlue.shade900,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        FocusScope.of(context).unfocus();
                                        if (yumeBonusNoteController
                                            .text.isEmpty) {
                                          showDialog<AlertDialog>(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                title: Text("Oops"),
                                                content: Text("ちゃんと書きなさい"),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          APIS.addBonusToSheet(
                                              "yumeBonus",
                                              yumeBonus,
                                              yumeBonusNoteController.text);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('おめでとうございます。'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2 -
                                                    50),
                                          ),
                                        );
                                        setState(() {
                                          yumeBonusNoteController.clear();
                                          yumeBonus = 0;
                                        });
                                      },
                                      child: const Text(
                                        "Bonus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ], //ゆめはるRボタン(children)
                        ), //Row
                      ), //Center
                    ], //Children
                  ) //Column
                  ), //card widget
              //おとな
              HomeCardWidgetKakei(
                  title: "おとな",
                  color: const Color.fromARGB(255, 216, 207, 154),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //左列まま銀行R
                            Column(
                              children: [
                                Text(
                                  'まま  $mamaGinko',
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildRoutineButton(
                                        currentMamaOne, mamaROne, "J4"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildRoutineButton(
                                        currentMamaTwo, mamaRTwo, "K4"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildRoutineButton(
                                        currentMamaThree, mamaRThree, "L4"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    _buildRoutineButton(
                                        currentMamaFour, mamaRFour, "M4"),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                            onTap: () {
                                              _incrementMamaBonus();
                                            },
                                            child: Image.asset(
                                              'assets/yumekawa_animal_unicorn.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$mamaBonus',
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: mamaBonusNoteController,
                                        decoration: const InputDecoration(
                                            hintText: "note"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.lightBlue.shade900,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        FocusScope.of(context).unfocus();
                                        if (mamaBonusNoteController
                                            .text.isEmpty) {
                                          showDialog<AlertDialog>(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                title: Text("Oops"),
                                                content: Text("ちゃんと書きなさい"),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          APIS.addBonusToSheet(
                                              "mamaBonus",
                                              mamaBonus,
                                              mamaBonusNoteController.text);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('おめでとうございます。'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2 -
                                                    50),
                                          ),
                                        );
                                        setState(() {
                                          mamaBonusNoteController.clear();
                                          mamaBonus = 0;
                                        });
                                      },
                                      child: const Text(
                                        "Bonus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // 右列papa銀行 Column
                            Column(
                              children: [
                                Text(
                                  'ぱぱ  $papaGinko',
                                  style: const TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 8),
                                //ぱぱRボタンリスト開始
                                _buildRoutineButton(
                                    currentPapaOne, papaROne, "N4"),
                                _buildRoutineButton(
                                    currentPapaTwo, papaRTwo, "O4"),
                                _buildRoutineButton(
                                    currentPapaThree, papaRThree, "P4"),
                                _buildRoutineButton(
                                    currentPapaFour, papaRFour, "Q4"),
                                const SizedBox(height: 50),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                            onTap: () {
                                              _incrementPapaBonus();
                                            },
                                            child: Image.asset(
                                              'assets/animal_happa_tanuki.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$papaBonus',
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: papaBonusNoteController,
                                        decoration: const InputDecoration(
                                            hintText: "note"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.lightBlue.shade900,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        FocusScope.of(context).unfocus();
                                        if (papaBonusNoteController
                                            .text.isEmpty) {
                                          showDialog<AlertDialog>(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                title: Text("Oops"),
                                                content: Text("ちゃんと書きなさい"),
                                              );
                                            },
                                          );
                                          return;
                                        } else {
                                          APIS.addBonusToSheet(
                                              "papaBonus",
                                              papaBonus,
                                              papaBonusNoteController.text);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('おめでとうございます。'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2 -
                                                    50),
                                          ),
                                        );
                                        setState(() {
                                          papaBonusNoteController.clear();
                                          papaBonus = 0;
                                        });
                                      },
                                      child: const Text(
                                        "Bonus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ], //おとなRボタン(children)
                        ), //Row
                      ), //Center
                    ], //Children
                  ) //Column
                  ),
              // 家計簿
              HomeCardWidgetKakei(
                title: "おこづかい",
                color: Colors.green[100]!,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: kakeiController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(hintText: "金額"),
                          ),
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          TextFormField(
                            controller: kakeiNoteController,
                            decoration: const InputDecoration(hintText: "メモ"),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3,
                      ),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        final bool checked = checkedList.contains(index);
                        return InkWell(
                          child: checked == false
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    categoryList[index],
                                    style: const TextStyle(
                                        color: Colors.black45, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[200],
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    categoryIconList[index],
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                          onTap: () {
                            castId = index;
                            if (checked) {
                              _unchecked(index);
                              category = "";
                            } else {
                              _checked(index);
                              setState(() => category = categoryList[index]);
                            }
                          },
                        );
                      },
                      shrinkWrap: true,
                    ),
                    const SizedBox(
                      width: 60,
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.lightBlue.shade900,
                      minWidth: 120,
                      height: 50,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        FocusScope.of(context).unfocus();
                        if (kakeiController.text.isEmpty || category.isEmpty) {
                          showDialog<AlertDialog>(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Oops"),
                                content: Text("ちゃんと書きなさい"),
                              );
                            },
                          );
                          return;
                        } else {
                          _addToSheetInBackground();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('おめでとうございます。'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 400),
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 2 -
                                    50),
                          ),
                        );
                        setState(() {
                          kakeiController.clear();
                          kakeiNoteController.clear();
                          checkedList.clear();
                        });
                      },
                      child: const Text(
                        "  登録  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 10,
                    ),
                  ],
                ),
              ) //card widget
            ],
          ),
        ), //SingleChildScrollView
      ), //GestureDetector
    ); //Scaffold
  }
}
