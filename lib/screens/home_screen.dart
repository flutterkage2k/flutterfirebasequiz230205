import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/screens/create_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final CollectionReference _questions_new =
  FirebaseFirestore.instance.collection('questions_new');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context,MaterialPageRoute(builder:(context) => CreateScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: _questions_new.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {

                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => FirebaseHomeScreen(
                      //             id: documentSnapshot.id,
                      //
                      //           ),),);
                      // },
                    },
                    child: Card(
                      margin: const EdgeInsets.all(7),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            '문제수 :' + documentSnapshot['count'].toString()),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );

  }
}
