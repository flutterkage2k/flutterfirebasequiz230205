import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/models/database_service.dart';
import 'package:flutterfirebasequiz230205/models/question_model.dart';
import 'package:flutterfirebasequiz230205/screens/result_screen.dart';
import 'package:flutterfirebasequiz230205/widgets/quiz_play_widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  PlayQuiz({Key? key, required this.quizId}) : super(key: key);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notattempted = 0;

StreamController infoStream = StreamController();

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  late QuerySnapshot? questionSnapshot;

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

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        print("this is x $x");
        return [_correct, _incorrect];
      }) as StreamController;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Play Start"),
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Row(
              //   children: [Text(questionSnapshot!.docs.length.toString())],
              // ),
              // InfoHeader(length: questionSnapshot!.docs.length.toString()),
              SizedBox(
                height: 10,
              ),
              questionSnapshot == null || questionSnapshot!.docs.length == 0
                  ? Container(
                      child: Center(
                        child: Text("No Data"),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionSnapshot!.docs.length,
                      itemBuilder: (context, index) {
                        return QuizPlayTile(
                          questionModel: getQuestionModelFromDatasnapshot(
                              questionSnapshot!.docs[index]),
                          index: index,
                        );
                      },
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
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
    );
  }
}

class InfoHeader extends StatefulWidget {
  final String length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "Correct",
                        number: _correct.toString(),
                      ),
                      NoOfQuestionTile(
                        text: "Incorrect",
                        number: _incorrect.toString(),
                      ),
                      NoOfQuestionTile(
                        text: "NotAttempted",
                        number: _notattempted.toString(),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({required this.questionModel, required this.index});

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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Q${widget.index + 1} " +
                  "." +
                  " ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
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
              description: "${widget.questionModel.option1}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
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
              description: "${widget.questionModel.option2}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
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
              description: "${widget.questionModel.option3}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
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
              description: "${widget.questionModel.option4}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
