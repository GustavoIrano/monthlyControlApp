import 'package:FTT/firestoreservice.dart';
import 'package:FTT/paymenthistory.dart';
import 'package:FTT/task.dart';
import 'package:FTT/utils.dart';
import 'package:flutter/material.dart';

class StackBuilder{

  Stack buildStack(BuildContext context, Task stud, FirestoreService fireServ){

    return  Stack(children: <Widget>[
      // The containers in the background
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
                        todoType(stud.taskImage),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentHistory( stud.taskid ),
                                  fullscreenDialog: true),
                            );
                          },
                          child: Text( stud.taskname ,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAlertDialog(
                                context,
                                stud.taskid,
                                stud.taskpagamentos,
                                fireServ);
                          },
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Dia Pag: ' + stud.taskdate,
                                style: TextStyle(
                                    color: payLate(
                                        stud.taskdate,
                                        stud.taskpagamentos)
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    ]);
  }

}