// widgets/home_card_child_bank.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/home_page_state.dart';
import 'package:myapp/services/api.dart';

class HomeCardChildBank extends StatelessWidget {
  final HomePageStateData stateData;
  final VoidCallback onIncrementYumeBonus;
  final VoidCallback onIncrementMamaBonus;
  final VoidCallback onIncrementPapaBonus;
  final VoidCallback onIncrementHaruGinko;
  final VoidCallback onIncrementYumeGinko;
  final VoidCallback onIncrementHaruBonus;
  final VoidCallback onIncrementMamaGinko;
  final VoidCallback onIncrementPapaGinko;
  final bool isAdult; 

  const HomeCardChildBank(
      {required this.stateData,
      required this.onIncrementHaruBonus,
      required this.onIncrementYumeBonus,
      required this.onIncrementMamaBonus,
      required this.onIncrementPapaBonus,
      required this.onIncrementHaruGinko,
      required this.onIncrementYumeGinko,
      required this.onIncrementMamaGinko,
      required this.onIncrementPapaGinko,
      required this.isAdult, 
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左列 はるか銀行
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('はるか  ${stateData.haruGinko}',
                    style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 8),
                _buildRoutineButton(context, stateData.currentHaruOne,
                    stateData.haruROne, "B4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentHaruTwo,
                    stateData.haruRTwo, "C4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentHaruThree,
                    stateData.haruRThree, "D4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentHaruFour,
                    stateData.haruRFour, "E4"),
                const SizedBox(height: 60),
                _buildBonusRow(
                  context: context,
                  onTap: onIncrementHaruBonus,
                  image: 'assets/yumekawa_animal_unicorn.png',
                  bonus: stateData.haruBonus,
                  controller: stateData.haruBonusNoteController,
                  sheetName: "haruBonus",
                ),
              ],
            ),
            // 中央列
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                _buildImage('assets/osara_color.png'),
                _buildImage('assets/syufu_otetsudai.png'),
                _buildImage('assets/shoes_kutsu_soroeru.png'),
                _buildImage('assets/hamster_sleeping_golden.png'),
              ],
            ),
            // 右列 夢子銀行
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ゆめこ  ${stateData.yumeGinko}',
                    style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 8),
                _buildRoutineButton(context, stateData.currentYumeOne,
                    stateData.yumeROne, "F4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentYumeTwo,
                    stateData.yumeRTwo, "G4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentYumeThree,
                    stateData.yumeRThree, "H4"),
                const SizedBox(height: 27),
                _buildRoutineButton(context, stateData.currentYumeFour,
                    stateData.yumeRFour, "I4"),
                const SizedBox(height: 60),
                _buildBonusRow(
                  context: context,
                  onTap: onIncrementYumeBonus,
                  image: 'assets/animal_happa_tanuki.png',
                  bonus: stateData.yumeBonus,
                  controller: stateData.yumeBonusNoteController,
                  sheetName: "yumeBonus",
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoutineButton(
      BuildContext context,
      ValueNotifier<String> currentTextNotifier,
      String originalText,
      String cell) {
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

  Widget _buildImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Image.asset(imagePath, width: 56, height: 56),
    );
  }

  Widget _buildBonusRow({
    required BuildContext context,
    required VoidCallback onTap,
    required String image,
    required int bonus,
    required TextEditingController controller,
    required String sheetName,
  }) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: onTap,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            Text('$bonus', style: const TextStyle(fontSize: 30)),
          ],
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: "note"),
          ),
        ),
        const SizedBox(width: 10, height: 10),
        MaterialButton(
          color: Colors.lightBlue.shade900,
          onPressed: () {
            HapticFeedback.mediumImpact();
            FocusScope.of(context).unfocus();
            if (controller.text.isEmpty) {
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
              APIS.addBonusToSheet(sheetName, bonus, controller.text);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('おめでとうございます。'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(milliseconds: 400),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 2 - 50),
              ),
            );
            controller.clear();
          },
          child: const Text(
            "Bonus",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10, height: 10),
      ],
    );
  }

  // Helper method to cycle button text
  String _cycleButtonText(
      String currentText, String originalText, String cell) {
    if (currentText != "◯" && currentText != "／") {
      if (cell == 'F4' || cell == 'G4' || cell == 'H4' || cell == 'I4') {
        onIncrementHaruGinko!();
      } else {
        onIncrementYumeGinko!();
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
}
