import 'package:FTT/models/billstopay.dart';
import 'package:FTT/models/conciliation.dart';
import 'package:FTT/models/task.dart';
import 'package:date_utils/date_utils.dart';

class ConciliationUtil {
  static List<ConciliationModel> buildArrayMonths(DateTime dateMonth) {
    DateTime qtdDiasMonth = Utils.lastDayOfMonth(dateMonth);
    qtdDiasMonth.day;

    List<ConciliationModel> conciliation = new List<ConciliationModel>();

    for (int i = 1; i < qtdDiasMonth.day; i++) {
      ConciliationModel c = new ConciliationModel(i, "", 0, 0);
      conciliation.add(c);
    }

    return conciliation;
  }

  static List<ConciliationModel> buildConciliation(List<Task> items) {
    List<ConciliationModel> conciliation = buildArrayMonths(DateTime.now());

    for (int i = 0; i < items.length; i++) {
      int dayItem = int.parse(items[i].taskdate);
      conciliation[dayItem].valueToReceive = conciliation[dayItem].valueToReceive + 80.00;
      print(dayItem);
    }

    return conciliation;
  }

  static List<ConciliationModel> buildConciliationBillsToPay(List<ConciliationModel> conciliation, List<BillsToPay> billsToPay){

    for(int i = 0; i < billsToPay.length; i++){
      int dayBill = DateTime.parse( billsToPay[i].billdate ).day;

      print(dayBill);
      conciliation[dayBill].valueToPay = conciliation[dayBill].valueToPay + billsToPay[i].billvalue ;

      print( billsToPay[i].billdate );
      print( billsToPay[i].billvalue );
    }

    return conciliation;
  }
}
