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

  Stream<QuerySnapshot> getBillList(String date, bool initial, {int offset, int limit}) {

    var nextMonthsplit = date.split("-");
    int day = int.parse( nextMonthsplit[1] ) + 1;
    var nextMonth = (nextMonthsplit[0] + "-" + day.toString() + "-" + nextMonthsplit[2]).toString();

    Stream<QuerySnapshot> snapshots = myCollection.where("billpaydate", isGreaterThanOrEqualTo: date)
        .where("billpaydate", isLessThanOrEqualTo: nextMonth).snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }


  Future deleteBillToPay(String documentPay)async{

    myCollection.document(documentPay).delete();
  }
}
