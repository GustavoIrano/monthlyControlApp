import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'firestoreservice.dart';

class PaymentHistory extends StatefulWidget {
  final String idStudent;

  PaymentHistory(this.idStudent);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<dynamic> payments;
  FirestoreService fireServ = new FirestoreService();

  @override
  void initState() {
    super.initState();

    fireServ
        .getPaymentsList(widget.idStudent)
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        payments = snapshot['taskpagamentos'];
        payments.sort((a,b) => b.toString().compareTo(a.toString()));
      });
    });
  }

  showAlertDialog(BuildContext context, String datePayment) {

    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );


    Widget payButton = FlatButton(
      child: Text("Confirmar exclusão?"),
      onPressed: () async{
        fireServ.deletePayment(datePayment, widget.idStudent);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentHistory(widget.idStudent)),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Exclusão pagamento"),
      content: new RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              new TextSpan(
                  text: 'Data para exclusão: ',
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              new TextSpan(text: DateFormat("dd/MM/yyyy")
                  .format(DateTime.parse(datePayment))),
            ]),
      ),
      actions: [
        cancelButton,
        payButton,
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
          height: MediaQuery.of(context).size.height - 80,
          child: ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80.0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                payments[index].toString())),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.solidTrashAlt,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          showAlertDialog(context, payments[index].toString());
                                        },
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              );
            },
          ),
        ),
      ]),
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
                  'Histórico de Pagamentos',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.solidCalendarPlus,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(containerHeight: 210.0),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2040, 12, 31), onConfirm: (date) {
                      print('Date: $date');

                      fireServ.addPayDate(date.toString(), widget.idStudent);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentHistory(widget.idStudent)),
                      );

                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.pt);
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
