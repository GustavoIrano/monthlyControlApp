import 'package:FTT/models/billstopay.dart';
import 'package:FTT/screens/billspay/billspayadd.dart';
import 'package:FTT/services/billspayservice.dart';
import 'package:FTT/utils/stackBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BillsPay extends StatefulWidget{

   @override
  _BillsPay createState() => _BillsPay();

}

class _BillsPay extends State<BillsPay>{
  List<BillsToPay> items;
  BillsPayService fireServ = new BillsPayService();

  @override
  void initState(){
    super.initState();

    items = new List();

    fireServ.getBillList().listen((QuerySnapshot snapshot){
      final List<BillsToPay> bills = snapshot.documents
          .map((documentSnapshot) =>
          BillsToPay.fromMap(documentSnapshot.data, documentSnapshot.documentID)
      ).toList();
      setState(() {
        items = bills;
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
                      .buildStackBills(context, items[index], fireServ);
                }),
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
                                builder: (context) => BillsPaysAdd(BillsToPay('',0,'',0,'')),
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