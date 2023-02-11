import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/screens/create_screen.dart';
import 'package:flutterfirebasequiz230205/screens/play_quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference quizStream1 =
      FirebaseFirestore.instance.collection("Quiz");

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream1.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return streamSnapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return QuizTile(
                      imgUrl: documentSnapshot['quizImgUrl'],
                      title: documentSnapshot['quizTitle'],
                      desc: documentSnapshot['quizDesc'],
                      quizId: documentSnapshot['quizId'],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: quizList(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  QuizTile(
      {Key? key,
      required this.imgUrl,
      required this.title,
      required this.desc,
      required this.quizId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayQuiz(
              quizId: quizId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 9),
        height: MediaQuery.of(context).size.height / 4.7,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Opacity(
                opacity: 0.6,
                child: Image.network(
                  imgUrl,
                  width: MediaQuery.of(context).size.width - 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
