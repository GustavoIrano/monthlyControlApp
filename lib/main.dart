import 'dart:async';
import 'package:FTT/screens/billspay/billspay.dart';
import 'package:FTT/utils/DataSearch.dart';
import 'package:FTT/utils/stackBuilder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'services/studentservice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/students/taskscreen.dart';
import 'models/task.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FTT APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff543B7A),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR')
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> items;
  StudentService fireServ = new StudentService();
  StreamSubscription<QuerySnapshot> todoTasks;

  @override
  void initState() {
    super.initState();

    items = new List();

    todoTasks?.cancel();
    todoTasks = fireServ.getTaskList().listen((QuerySnapshot snapshot) {
      final List<Task> tasks = snapshot.documents
          .map((documentSnapshot) =>
              Task.fromMap(documentSnapshot.data, documentSnapshot.documentID))
          .toList();

      setState(() {
        this.items = tasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(context),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return StackBuilder()
                      .buildStack(context, items[index], fireServ);
                }),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print("Open Dial"),
        onClose: () => print("Close Dial"),
        tooltip: "Speed dial",
        heroTag: "Speed-dial-hero-tag",
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.person_add, color: Colors.black),
            backgroundColor: Colors.deepOrangeAccent,
            label: "Novo Aluno",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskScreen(Task('', '', '', '', '')),
                    fullscreenDialog: true),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.moneyCheckAlt, color: Colors.black),
            backgroundColor: Colors.deepOrangeAccent,
            label: "Contas à pagar",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BillsPay(),
                    fullscreenDialog: true),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.solidMoneyBillAlt, color: Colors.black),
            backgroundColor: Colors.deepOrangeAccent,
            label: "Contas à receber",
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){},
          ),
        ],
      ),
    );
  }

  Widget _myAppBar(context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xFFFA7397),
              const Color(0xFFFDDE42),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 15,
              child: Container(
                child: Text(
                  'Alunos',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: DataSearch(this.items));
                    }),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
