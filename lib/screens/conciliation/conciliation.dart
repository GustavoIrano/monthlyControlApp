import 'package:FTT/models/billstopay.dart';
import 'package:FTT/models/conciliation.dart';
import 'package:FTT/models/task.dart';
import 'package:FTT/services/billspayservice.dart';
import 'package:FTT/services/studentservice.dart';
import 'package:FTT/utils/conciliationutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Conciliation extends StatefulWidget {
  @override
  _ConciliationState createState() => _ConciliationState();
}

class _ConciliationState extends State<Conciliation> {
  double total = 0;
  StudentService fireServ = new StudentService();
  BillsPayService fireServBill = new BillsPayService();
  List<ConciliationModel> conciliation;

  @override
  void initState() {
    super.initState();

    fireServ.getTaskList().listen((QuerySnapshot snapshot) {
      final List<Task> tasks = snapshot.documents
          .map((documentSnapshot) =>
              Task.fromMap(documentSnapshot.data, documentSnapshot.documentID))
          .toList();

      setState(() {
        this.conciliation = ConciliationUtil.buildConciliation(tasks);
      });
    });

    fireServBill
        .getBillList(
            DateTime(DateTime.now().year, DateTime.now().month, 1).toString(),
            false)
        .listen((QuerySnapshot snapshot) {
      final List<BillsToPay> bills = snapshot.documents
          .map((documentSnapshot) => BillsToPay.fromMap(
              documentSnapshot.data, documentSnapshot.documentID))
          .toList();
      setState(() {
        this.conciliation =
            ConciliationUtil.buildConciliationBillsToPay(conciliation, bills);
        this.total = ConciliationUtil.returnTotal(conciliation);
      });
    });
  }

  Color colorTotal(double valueTotal) {
    double result = valueTotal;

    if (result < 0) {
      return Colors.red;
    }

    if (result > 0) {
      return Colors.blue;
    }

    return Colors.black;
  }

  Color colorPayment(double valueToPay, double valueToReceive) {
    double result = valueToPay - valueToReceive;

    if (result < 0) {
      return Colors.red;
    }

    if (result > 0) {
      return Colors.blue;
    }

    return Colors.black;
  }

  showAlertDialogBillsToPay(BuildContext context, String billsToPay, String title) {
    Widget cancelButton = FlatButton(
      child: Text("Fechar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: new RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(
                text: billsToPay,
              ),
            ]),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
              itemCount: conciliation.length,
              itemBuilder: (context, index) {
                return Stack(children: <Widget>[
                  Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.only(left: 4.5, top: 30.5, right: 4.5),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(10.0, 10.0),
                          blurRadius: 80.0,
                        )
                      ],
                    ),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showAlertDialogBillsToPay(
                                context, conciliation[index].billsToPay, "Contas à pagar");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new RichText(
                                text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: 'Á pagar: ',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          new TextSpan(
                                            text: "\nR\$ " +
                                                BillsToPay.formatPay(
                                                        conciliation[index]
                                                            .valueToPay
                                                            .toString())
                                                    .toString()
                                                    .replaceAll(".", ","),
                                            style: new TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAlertDialogBillsToPay(
                                context, conciliation[index].studentsToReceive, "Alunos à receber");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new RichText(
                                text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: 'Á receber: ',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          new TextSpan(
                                            text: "\nR\$ " +
                                                BillsToPay.formatPay(
                                                        conciliation[index]
                                                            .valueToReceive
                                                            .toString())
                                                    .toString()
                                                    .replaceAll(".", ","),
                                            style: new TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new RichText(
                              text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: 'Total: ',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        new TextSpan(
                                          text: "\nR\$ " +
                                              BillsToPay.formatPay((conciliation[
                                                                  index]
                                                              .valueToPay -
                                                          conciliation[index]
                                                              .valueToReceive)
                                                      .toString())
                                                  .toString()
                                                  .replaceAll(".", ","),
                                          style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: colorPayment(
                                                conciliation[index].valueToPay,
                                                conciliation[index]
                                                    .valueToReceive),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    margin: new EdgeInsets.only(
                        left: MediaQuery.of(context).size.width - 350,
                        right: MediaQuery.of(context).size.width - 40,
                        top: 7.0),
                    alignment: FractionalOffset.center,
                    child: new Text(
                      conciliation[index].day.toString(),
                      style: TextStyle(fontSize: 20),
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
                Text(
                  "R\$" +
                      BillsToPay.formatPay(total.toString())
                          .toString()
                          .replaceAll(".", ","),
                  style: TextStyle(
                    color: colorTotal(total),
                  ),
                ),
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
