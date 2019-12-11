import 'package:FTT/stackBuilder.dart';
import 'package:FTT/task.dart';
import 'package:flutter/material.dart';
import 'firestoreservice.dart';

class DataSearch extends SearchDelegate<String> {
  List<Task> _students = new List<Task>();
  String studentSelected = "";

  DataSearch(List<Task> students) {
    _students = students;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    FirestoreService fireServ = new FirestoreService();
    String wHere = (studentSelected.isEmpty) ? query : studentSelected;
    Task stud = _students.where((p) => p.taskname.startsWith(wHere)).first;

    return StackBuilder().buildStack(context, stud, fireServ);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? _students
        : _students.where((p) => p.taskname.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          studentSelected = suggestionList[index].taskname;
          showResults(context);
        },
        leading: Icon(Icons.person),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].taskname.substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].taskname.substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
