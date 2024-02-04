import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/screens/auth.dart';

class Home extends StatelessWidget {
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
              Navigator.popUntil(context, (ModalRoute.withName('/')));
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: NotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoteArea()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteArea extends StatefulWidget {
  @override
  State<NoteArea> createState() => _NoteAreaState();
}

class _NoteAreaState extends State<NoteArea> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> addNote() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userCollection = 'users/${currentUser.uid}/notes';

        await FirebaseFirestore.instance.collection(userCollection).add({
          'title': _titleController.text,
          'note': _noteController.text,
        });

        _titleController.clear();
        _noteController.clear();
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print('No user signed in.');
      }
    } on FirebaseException catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[50],
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueGrey[100],
          ),
          child: TextField(
            controller: _titleController,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter Title',
              hintStyle: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            thickness: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.blueGrey[50],
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
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
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addNote();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  backgroundColor: Colors.blueGrey[100],
                ),
                child: Text('Save Note',
                    style: TextStyle(fontSize: 16.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(child: Text('No user signed in.'));
    }

    String userCollection = 'users/${currentUser.uid}/notes';

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(userCollection).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DocumentSnapshot> notes = snapshot.data!.docs;

          if (notes.isEmpty) {
            return Center(child: Text('No notes available.'));
          }

          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(notes[index].id),
                  child: NoteContainer(
                    userCollection: userCollection,
                    id: notes[index].id,
                    title: notes[index]['title'],
                    note: notes[index]['note'],
                  ),
                  onDismissed: (direction) {
                    notes[index].reference.delete();
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete,
                        color: Color.fromARGB(255, 254, 254, 254), size: 30.0),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                  ),
                );
              });
        }
      },
    );
  }
}

class NoteContainer extends StatelessWidget {
  final String id;
  final String title;
  final String note;
  final String userCollection;
  NoteContainer(
      {super.key,
      required this.title,
      required this.note,
      required this.id,
      required this.userCollection});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditnoteScreen(
                    id: id,
                    initialNote: note,
                    initialTitle: title,
                    userCollection: userCollection)));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              note,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditnoteScreen extends StatefulWidget {
  const EditnoteScreen(
      {super.key,
      required this.id,
      required this.initialTitle,
      required this.initialNote,
      required this.userCollection});
  final String id;
  final String initialTitle;
  final String initialNote;
  final String userCollection;
  @override
  State<EditnoteScreen> createState() => _EditnoteScreenState();
}

class _EditnoteScreenState extends State<EditnoteScreen> {
  final TextEditingController _editedTitleController = TextEditingController();
  final TextEditingController _editedNoteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _editedTitleController.text = widget.initialTitle;
    _editedNoteController.text = widget.initialNote;
  }

  void saveEditedNote() async {
    try {
      String editedTitle = _editedTitleController.text;
      String editedNote = _editedNoteController.text;

      await FirebaseFirestore.instance
          .collection(widget.userCollection)
          .doc(widget.id)
          .update({
        'title': editedTitle,
        'note': editedNote,
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editedTitleController,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Title',
            hintStyle: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            thickness: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _editedNoteController,
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
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement saving edited note to Firestore
                  saveEditedNote();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  backgroundColor: Colors.blueGrey[100],
                ),
                child: Text('Save Changes',
                    style: TextStyle(fontSize: 16.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
