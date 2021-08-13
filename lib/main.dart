import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task 8',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db = FirebaseFirestore.instance;
  late String task;

  void showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Data'),
            content: Form(
              autovalidateMode: AutovalidateMode.always, child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:"Name",
                    ),
                    validator: (_val){
                      if(_val!.isEmpty){
                       return "Can't be Empty";
                      }
                      else {
                        return null;
                      }
                    },
              onChanged: (_val){
                task = _val;
              },
                  ),

            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed:(){
                    db.collection('tasks').add({'task': task});
                    Navigator.pop(context);
                  },
                child: Text('Add'),
                  ),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showMaterialDialog,
        child: Icon(Icons.add),
      ),
    body:
    StreamBuilder<QuerySnapshot>(
        stream: db.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Container(
                child: ListTile(
                  title: Text(
                    ds['task']
                  ),
                ),
              );
            },
          );

        }
        else if (snapshot.hasError) {
          return CircularProgressIndicator();
        }else {
          return CircularProgressIndicator();
        }
      }

    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

    );
  }
}
