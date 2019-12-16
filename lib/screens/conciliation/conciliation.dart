import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Conciliation extends StatefulWidget {
  @override
  _ConciliationState createState() => _ConciliationState();
}

class _ConciliationState extends State<Conciliation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        _myAppBar(context),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 125,
          child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return Stack(children: <Widget>[
                  Container(
                    height: 40.0,
                    margin:
                        const EdgeInsets.only(left: 50.0, top: 6.5, right: 3.5),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(0.0, 10.0),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 35.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    margin: new EdgeInsets.only(left: 5.0, right: MediaQuery.of(context).size.width - 40, top: 15.0),
                    alignment: FractionalOffset.center,
                    child: new Text(
                      "1",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ]);
              }),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Total: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                ),
                Text("R\$" + "150,00"),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _myAppBar(context) {
    return Container(
      height: 90.0,
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
        padding: const EdgeInsets.only(top: 30.0),
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
                  'Contas: pagar X receber',
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
