import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/models/database_service.dart';
import 'package:flutterfirebasequiz230205/models/question_model.dart';
import 'package:flutterfirebasequiz230205/screens/result_screen.dart';
import 'package:flutterfirebasequiz230205/widgets/quiz_play_widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  const PlayQuiz({
    Key? key,
    required this.quizId,
  }) : super(key: key);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notattempted = 0;

StreamController infoStream = StreamController();

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = DatabaseService();
  QuerySnapshot? questionSnapshot;

  bool isLoading = true;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();

    questionModel.question = questionSnapshot["question"];

    /// shuffling the options
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;

    // print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void initState() {
    databaseService.getQuizData1(widget.quizId).then((value) {
      questionSnapshot = value;
      _notattempted = questionSnapshot!.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnapshot!.docs.length;
      setState(() {});
    });

    // infoStream ??= Stream<List<int>>.periodic(const Duration(milliseconds: 100), (x) {
    //     print("this is x $x");
    //     return [_correct, _incorrect];
    //   }) as StreamController;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: const Text(
                            "빨간색은 틀렸습니다. 녹색은 정답입니다.",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      /* 문제 추가 할때 활성화 해서 사용할 수 있는 부분 */
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => AddQuestion(
                      //           quizId: widget.quizId,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: const Icon(Icons.add),
                      // )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        questionSnapshot == null ||
                                questionSnapshot!.docs.isEmpty
                            ? Container(
                                child: const Center(
                                  child: Text("No Data"),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: questionSnapshot!.docs.length,
                                itemBuilder: (context, index) {
                                  return QuizPlayTile(
                                    questionModel:
                                        getQuestionModelFromDatasnapshot(
                                            questionSnapshot!.docs[index]),
                                    index: index,
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Results(
                    incorrect: _incorrect,
                    total: total,
                    correct: _correct,
                    notattempted: _notattempted),
              ),
            );
          },
        ),
      ),
    );
  }
}
//
// class InfoHeader extends StatefulWidget {
//   final int length;
//
//   const InfoHeader({super.key, required this.length});
//
//   @override
//   _InfoHeaderState createState() => _InfoHeaderState();
// }
//
// class _InfoHeaderState extends State<InfoHeader> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: infoStream.stream,
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ? Container(
//                   height: 40,
//                   margin: const EdgeInsets.only(left: 14),
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     children: <Widget>[
//                       NoOfQuestionTile(
//                         text: "Total",
//                         number: widget.length,
//                       ),
//                       NoOfQuestionTile(
//                         text: "Correct",
//                         number: _correct,
//                       ),
//                       NoOfQuestionTile(
//                         text: "Incorrect",
//                         number: _incorrect,
//                       ),
//                       NoOfQuestionTile(
//                         text: "NotAttempted",
//                         number: _notattempted,
//                       ),
//                     ],
//                   ),
//                 )
//               : Container();
//         });
//   }
// }

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuizPlayTile(
      {super.key, required this.questionModel, required this.index});

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Q${widget.index + 1} . ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notattempted = _notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notattempted = _notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notattempted = _notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notattempted = _notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notattempted = _notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notattempted = _notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notattempted = _notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notattempted = _notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
