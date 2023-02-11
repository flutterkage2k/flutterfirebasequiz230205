import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/models/database_service.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion({required this.quizId});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };

      await databaseService
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                          decoration: InputDecoration(hintText: '문제'),
                          onChanged: (val) {
                            question = val;
                          },
                        ),
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '옵션1 (정답)'),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '옵션2'),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '옵션3'),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '옵션4'),
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: width / 3,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("저장 끝내기")),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: width / 3,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        uploadQuestionData();
                                      },
                                      child: Text("계속 입력")),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
