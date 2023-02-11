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
                    "you answered ${widget.correct} answers correctly and ${widget.incorrect} answeres incorrectly",
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Go to home",
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
