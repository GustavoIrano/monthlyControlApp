import 'package:FTT/models/billstopay.dart';
import 'package:FTT/screens/billspay/billspayadd.dart';
import 'package:FTT/services/billspayservice.dart';
import 'package:FTT/utils/stackBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_picker_strip/month_picker_strip.dart';

class BillsPay extends StatefulWidget {
  @override
  _BillsPay createState() => _BillsPay();
}

class _BillsPay extends State<BillsPay> {
  List<BillsToPay> items;
  BillsPayService fireServ = new BillsPayService();
  String totalMensal = "";

  @override
  void initState() {
    super.initState();

    items = new List();

    fireServ
        .getBillList(
            DateTime(DateTime.now().year, DateTime.now().month, 1).toString(),
            true)
        .listen((QuerySnapshot snapshot) {
      final List<BillsToPay> bills = snapshot.documents
          .map((documentSnapshot) => BillsToPay.fromMap(
              documentSnapshot.data, documentSnapshot.documentID))
          .toList();
      setState(() {
        items = bills;
        totalMensal = BillsToPay.calculateTotalMensal(items);
      });
    });
  }

  void getBillsByDate(String date) {
    fireServ.getBillList(date, false).listen((QuerySnapshot snapshot) {
      final List<BillsToPay> bills = snapshot.documents
          .map((documentSnapshot) => BillsToPay.fromMap(
              documentSnapshot.data, documentSnapshot.documentID))
          .toList();
      setState(() {
        items = bills;
        totalMensal = BillsToPay.calculateTotalMensal(items);
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
          MonthStrip(
            format: 'MMM-yyyy',
            from: new DateTime(2016, 4),
            to: new DateTime(2030, 5),
            initialMonth: DateTime.now(),
            height: 45.0,
            normalTextStyle: TextStyle(fontSize: 15, color: Colors.grey),
            selectedTextStyle: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            viewportFraction: 0.25,
            onMonthChanged: (v) {
              getBillsByDate(v.toString());
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 170,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return StackBuilder()
                      .buildStackBills(context, items[index], fireServ);
                }),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),),
                  Text("R\$" + totalMensal),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  'Contas à pagar',
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
                      Icons.create_new_folder,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BillsPaysAdd(BillsToPay('', 0, '', 0, '')),
                            fullscreenDialog: true),
                      );
                    }),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
