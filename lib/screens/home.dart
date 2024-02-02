import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[50],
        title: Text(
          'Notes',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: FirstNote(),
    );
  }
}

class FirstNote extends StatefulWidget {
  const FirstNote({super.key});

  @override
  State<FirstNote> createState() => _FirstNoteState();
}

class _FirstNoteState extends State<FirstNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Create your first note',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoteArea()));
              },
              child: Icon(
                Icons.add,
                size: 30,
              )),
        ],
      ),
    );
  }
}

class NoteArea extends StatefulWidget {
  const NoteArea({super.key});

  @override
  State<NoteArea> createState() => _NoteAreaState();
}

class _NoteAreaState extends State<NoteArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter Title',
              hintStyle: TextStyle(fontWeight: FontWeight.w700)),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              thickness: 3,
            )),
      ),
      body: Column(
        children: [
          TextField(
            cursorColor: Colors.black,
            maxLines: null,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                height: 1.5,
              ),
              border: InputBorder.none,
              hintText: 'Write your note Here  ................',
            ),
          ),
        ],
      ),
    );
  }
}

class NotesExist extends StatefulWidget {
  const NotesExist({super.key});

  @override
  State<NotesExist> createState() => _NotesExistState();
}

class _NotesExistState extends State<NotesExist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
