import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/models/database_service.dart';
import 'package:flutterfirebasequiz230205/screens/add_question.dart';
import 'package:random_string/random_string.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String quizImageUrl, quizTitle, quizDescription, quizId;
  DatabaseService dataBaseService = new DatabaseService();

  bool _isLoading = false;

  createQuizOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDescription
      };

      await dataBaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestion(
                        quizId: quizId,
                      )));
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
        title: Text('Create Quiz'),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '아미지 Url'),
                        onChanged: (val) {
                          quizImageUrl = val;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '문제 제목'),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      SizedBox(height: 6),
                      TextFormField(
                        validator: (val) => val!.isEmpty ? "빈칸을 채우세요" : null,
                        decoration: InputDecoration(hintText: '문제 설명'),
                        onChanged: (val) {
                          quizDescription = val;
                        },
                      ),
                      Spacer(),
                      SizedBox(
                        width: width * 0.7,
                        child: ElevatedButton(
                            onPressed: () {
                              createQuizOnline();
                            },
                            child: Text("저장")),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
