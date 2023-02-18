import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  const Results(
      {super.key,
      required this.incorrect,
      required this.total,
      required this.correct,
      required this.notattempted});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.correct}/ ${widget.total}",
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "당신이 선택한 ${widget.correct} 개(갯수)는 정답입니다. \n그리고 ${widget.incorrect} 개(갯수)는 오답입니다.",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "다른 문제를 풀어볼까요?",
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                ),
                Container(child: Text("문제는 계속 업데이트 됩니다."))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
