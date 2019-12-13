import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference myCollection = Firestore.instance.collection('billspay');

class BillsPayService {

  Future addBillsToPay(String bill, double value, String type, int ammountMonths, String dateBill) async {

    myCollection.add({
      'billpayname': bill,
      'billpayvalue': value,
      'billpaytype': type,
      'billpayammountmonths': ammountMonths,
      'billpaydate': dateBill
    });
  }

  Stream<QuerySnapshot> getBillList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

}
