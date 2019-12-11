import 'dart:io';
import 'package:flutter/material.dart';
import 'package:FTT/firestoreservice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firestoreservice.dart';
import 'task.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';


class TaskScreen extends StatefulWidget {
  final Task task;

  TaskScreen(this.task);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  FirestoreService fireServ = new FirestoreService();

  TextEditingController _taskNameController;
  TextEditingController _taskPhoneController;
  TextEditingController _taskDateController;
  TextEditingController _taskDateInsertController;
  TextEditingController _taskImageController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;

  @override
  void initState() {
    super.initState();

    _taskNameController = new TextEditingController(text: widget.task.taskname);
    _taskPhoneController =
        new TextEditingController(text: widget.task.taskphone);
    _taskDateController = new TextEditingController(text: widget.task.taskdate);
    _taskDateInsertController =
        new TextEditingController(text: widget.task.taskDateInsert);
    _taskImageController =  new TextEditingController(text: widget.task.taskImage);
  }

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("Getting Image");
      });
    }

    Future uploadPic() async{
        String fileName = basename(_image.path);
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

        var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        _taskImageController.text = downUrl.toString();
        print(_taskImageController.text);
    }

    void save() {
      print('Task image URL in save' + _taskImageController.text);
      _taskDateInsertController.text =
          new DateTime.now().toString();
      fireServ
          .createTODOTask(
          _taskNameController.text,
          _taskPhoneController.text,
          _taskDateController.text,
          _taskDateInsertController.text,
          _taskImageController.text)
          .then((_) {
        Navigator.pop(context);
      });
    }

    int _numberDay = ((_taskDateController.text != "") ? int.parse( _taskDateController.text ) : 0);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(context),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(labelText: "Nome: "),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _taskPhoneController,
                    decoration: InputDecoration(labelText: "Telefone: "),
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: _taskDateController,
                    decoration: InputDecoration(
                      labelText: "Dia de pagamento (Mensalidade): ",
                      errorText: ( _numberDay > 30) ? "Digite um dia menor do que 30" : null,
                    ),
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.deepOrangeAccent,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 180.0,
                                  height: 180.0,
                                  child: (_image != null)
                                      ? Image.file(_image, fit: BoxFit.fill)
                                      : new Text('Foto'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 60.0),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 30.0,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        color: Color(0xFFFA7397),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Color(0xFFFDDE42)),
                        )),
                    // This button results in adding the contact to the database
                    RaisedButton(
                        color: Color(0xFFFA7397),
                        onPressed: () async {
                          _scaffoldKey.currentState.showSnackBar(
                              new SnackBar(content: Text("Salvando..."), backgroundColor: Colors.deepOrangeAccent));
                          var lock = Lock();
                          if (_image != null) {
                            lock.synchronized(uploadPic);
                          }
                          lock.synchronized(save);
                        },
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(color: Color(0xFFFDDE42)),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _myAppBar(BuildContext context) {
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
              child: Container(
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                child: Text(
                  'Novo Aluno',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
