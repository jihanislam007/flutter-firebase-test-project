import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_v1/viewData.dart';

import 'SignUp.dart';
import 'contacts.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Future getFirebaseData() async {
    var firestore = FirebaseFirestore.instance.collection('signup').snapshots();
    //QuerySnapshot qn = await firestore.collection('').getD;
    return firestore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          
          /*StreamBuilder(
              stream: FirebaseFirestore.instance.collection('productList').snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapShot){
                if(!snapShot.hasData){
                  return Center(
                    child: Text("No data found !"),
                  );
                }
                return ListView.builder(
                  itemCount: 2,
                    itemBuilder: (_,i){
                     //var mydata = snapShot.data!.docs.map(to)
                     return ListTile(
                       title: Text('snapShot.data'),
                     );
                    });
              }),*/

          ElevatedButton(onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddUser('jihan 122', 'jewel 002', 200)));
        }, child: Text('Add data')),

          ElevatedButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetUserName('myname')));
          }, child: Text('Read Data')),

          ElevatedButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => signUp()));
          }, child: Text('SignUp')),

          ElevatedButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => viewData()));
          }, child: Text('View Data'))


        ],
      )),
    );
  }
}

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _textField = TextEditingController();
  final _todoUpdate = TextEditingController();

  Future<void> _addtodo() async {
    if (_textField.text.length <= 0) {
      return;
    }

    final collucrion = FirebaseFirestore.instance.collection('todo');

    await collucrion.add({
      "title": _textField.text,
    });

    _textField.text = '';
    Navigator.of(context).pop();
  }

  Future<void> delateTodo(String id) async {
    try {
      final collucrion = FirebaseFirestore.instance.collection('todo').doc(id);
      await collucrion.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatetod(String id) async {
    String updateText = _todoUpdate.text;
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('todo').doc(id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.get(documentReference);
        transaction.update(documentReference, {
          'title': updateText,
        });
      });
      Navigator.of(context).pop();
      _todoUpdate.text = '';
    } catch (e) {}
  }

  Future<void> editButton(String id) async {
    final collucrion = FirebaseFirestore.instance.collection('todo').doc(id);
    await collucrion.get().then((value) {
      //_todoUpdate.text = value.data()['title'];
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Todo"),
          content: TextField(
            controller: _todoUpdate,
            decoration: InputDecoration(
              hintText: "Update a Todo",
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            RaisedButton(
              onPressed: () {
                _updatetod(id);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("todo").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("NO Data Found!"),
            );
          }
          return ListView(
            /*children: snapshot.data!.docs
                .map(
                  (todoData) => SingleTodo(
                todo: todoData.data()['title'],
                id: todoData.id,
                delFunction: delateTodo,
                editFunction: editButton,
              ),
            )
                .toList(),*/
          );
        },
        // builder: ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Todo"),
                content: TextField(
                  controller: _textField,
                  decoration: InputDecoration(
                    hintText: "Add a Todo",
                  ),
                ),
                actions: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _addtodo();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class SingleTodo extends StatelessWidget {
  final String todo;
  final String id;
  final Function delFunction;
  final Function editFunction;
  SingleTodo({
    required this.todo,
    required this.id,
    required this.delFunction,
    required this.editFunction,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                todo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  editFunction(id);
                },
                icon: Icon(
                  Icons.edit,
                  size: 25,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  delFunction(id);
                },
                icon: Icon(
                  Icons.delete,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: Center(
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('data')
                .add({'text': 'data added through app'});
          },
        ),
      ),
    );
  }
}

class ReadData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('data').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: Center(child: Text(document['text'])),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
