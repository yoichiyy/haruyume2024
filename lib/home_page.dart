import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/home_card_kakei.dart';
import 'package:myapp/models/home_page_state.dart';
import 'package:myapp/services/api.dart';
import 'package:myapp/widgets/home_card_child_bank.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late HomePageStateData stateData;

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
    stateData = HomePageStateData();

    //データ取得
    fetchInitialData().then((initialData) {
      setState(() {
        stateData.updateData(initialData);
      });
    }).catchError((error) {
      // エラーハンドリング
      debugPrint('Error fetching initial data: $error');
    });
  }

  @override
  void dispose() {
    stateData.dispose();
    super.dispose();
  }

  Future<void> _addToSheetInBackground() async {
    //家計簿用
    await APIS.addKakeiboToSheet(stateData.kakeiController.text, category,
        stateData.kakeiNoteController.text);
  }

  // Increment methods
  void _incrementHaruka() {
    setState(() {
      stateData.harukaCounter++;
      stateData.monthlyHaruka++;
    });
  }

  void _incrementYumeko() {
    setState(() {
      stateData.yumekoCounter++;
      stateData.monthlyYumeko++;
    });
  }

  void _incrementMama() {
    setState(() {
      stateData.harukaCounter++;
      stateData.monthlyHaruka++;
    });
  }

  void _incrementPapa() {
    setState(() {
      stateData.yumekoCounter++;
      stateData.monthlyYumeko++;
    });
  }

  void _incrementHaruGinko() {
    setState(() {
      stateData.haruGinko++;
    });
  }

  void _incrementYumeGinko() {
    setState(() {
      stateData.yumeGinko++;
    });
  }

  void _incrementMamaGinko() {
    setState(() {
      stateData.mamaGinko++;
    });
  }

  void _incrementPapaGinko() {
    setState(() {
      stateData.papaGinko++;
    });
  }

  void _incrementHaruBonus() {
    setState(() {
      stateData.haruBonus++;
    });
  }

  void _incrementYumeBonus() {
    setState(() {
      stateData.yumeBonus++;
    });
  }

  void _incrementMamaBonus() {
    setState(() {
      stateData.haruBonus++;
    });
  }

  void _incrementPapaBonus() {
    setState(() {
      stateData.yumeBonus++;
    });
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
              // 家計簿
              HomeCardWidget(
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
                            controller: stateData.kakeiController,
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
                            controller: stateData.kakeiNoteController,
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
                        if (stateData.kakeiController.text.isEmpty ||
                            category.isEmpty) {
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
                          stateData.kakeiController.clear();
                          stateData.kakeiNoteController.clear();
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
              ), //card widget
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
                                  text:
                                      '$stateData.monthlyHaruka', // この部分だけフォントサイズ20に変更
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
                                  text:
                                      '$stateData.harukaCounter', // この部分だけフォントサイズ20に変更
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
                                  text:
                                      '$stateData.monthlyYumeko', // この部分だけフォントサイズ20に変更
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
                                  text:
                                      '$stateData.yumekoCounter', // この部分だけフォントサイズ20に変更
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
                  APIS.addBookToSheet(
                      stateData.harukaCounter, stateData.yumekoCounter);
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
                    stateData.harukaCounter = 0;
                    stateData.yumekoCounter = 0;
                  });
                },
                child: const Text('リセット'),
              ),
              const SizedBox(height: 20),
              //子ども銀行
              HomeCardWidget(
                title: "子ども",
                color: const Color(0xFF00C0FF),
                child: HomeCardChildBank(
                  stateData: stateData,
                  onIncrementHaruBonus: _incrementHaruBonus,
                  onIncrementYumeBonus: _incrementYumeBonus,
                  onIncrementHaruGinko: _incrementHaruGinko,
                  onIncrementYumeGinko: _incrementYumeGinko,
                  onIncrementMamaBonus: _incrementMamaBonus,
                  onIncrementPapaBonus: _incrementPapaBonus,
                  onIncrementMamaGinko: _incrementMamaGinko,
                  onIncrementPapaGinko: _incrementPapaGinko,
                  isAdult: false,
                ),
              ),
              //おとな
              HomeCardWidget(
                title: "おとな",
                color: const Color.fromARGB(255, 216, 207, 154),
                child: HomeCardChildBank(
                  stateData: stateData,
                  onIncrementHaruBonus: _incrementHaruBonus,
                  onIncrementYumeBonus: _incrementYumeBonus,
                  onIncrementHaruGinko: _incrementHaruGinko,
                  onIncrementYumeGinko: _incrementYumeGinko,
                  onIncrementMamaBonus: _incrementMamaBonus,
                  onIncrementPapaBonus: _incrementPapaBonus,
                  onIncrementMamaGinko: _incrementMamaGinko,
                  onIncrementPapaGinko: _incrementPapaGinko,
                  isAdult: true,
                ),
              ),
            ],
          ),
        ), //SingleChildScrollView
      ), //GestureDetector
    ); //Scaffold
  }
}
