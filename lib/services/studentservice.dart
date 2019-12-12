import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

final CollectionReference myCollection = Firestore.instance.collection('students');

class StudentService {
  
  Future<Task> createTODOTask(String taskname, String taskphone,String taskdate,String taskdateinsert, String taskImage) async {

    List<String> pagamentos = new List<String>();
    pagamentos.add(DateTime.now().toString());

    myCollection
        .add({'taskname': taskname,
              'taskphone': taskphone,
              'taskdate': taskdate,
              'taskdateinsert': taskdateinsert,
              'taskImage': taskImage,
              'taskpagamentos': pagamentos });
  }
  
  Future addPayDate(String payDate, String documentID){
    List<String> pay = new List<String>();
    pay.add(payDate);

    Firestore.instance.collection('students').document(documentID).updateData({"taskpagamentos": FieldValue.arrayUnion(pay)});
  }

  Stream<QuerySnapshot> getTaskList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection.orderBy("taskname").snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Stream<DocumentSnapshot> getPaymentsList(String idStudent) {
    Stream<DocumentSnapshot> snapshots = myCollection.document(idStudent).snapshots();

    return snapshots;
  }

  Future deletePayment(String datePayment, String idStudent){
    List<String> pay = new List<String>();
    pay.add(datePayment);

    myCollection.document(idStudent).updateData({"taskpagamentos": FieldValue.arrayRemove(pay)});
  }
  
}
