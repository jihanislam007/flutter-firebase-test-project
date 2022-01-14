import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class signUp extends StatelessWidget {

  TextEditingController username = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Email = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('signup');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'username': username.text, // John Doe
      'phone': Phone.text, // Stokes and Sons
      'email': Email.text // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'user name',
                  label: Text('User name')
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: Phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Phone',
                    label: Text('Phone')
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: Email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    label: Text('Email')
                ),
              ),
            ),

            TextButton(
              onPressed: (){addUser();},
              child: Text('Submit'),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)
                        )
                    )
                )
            )

          ],
        ),
      ),

    );
  }



}
