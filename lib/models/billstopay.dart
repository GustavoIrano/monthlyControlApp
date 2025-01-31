
class BillsToPay{
  String   _billID;
  String   _bill;
  double   _billvalue;
  String   _billtype;
  int      _billammountMonths;
  String   _billdate;

  BillsToPay(this._bill, this._billvalue, this._billtype, this._billammountMonths, this._billdate);

  BillsToPay.map(dynamic obj){
    this._bill = obj['billpayname'];
    this._billvalue = obj['billpayvalue'];
    this._billtype = obj['billpaytype'];
    this._billammountMonths = obj['billpayammountmonths'];
    this._billdate = obj['billpaydate'];
  }

  String get billID => _billID;
  String get bill => _bill;
  double get billvalue => _billvalue;
  String get billtype => _billtype;
  int    get billammountMonths => _billammountMonths;
  String get billdate => _billdate;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['billpayname'] = _bill;
    map['billpayvalue'] = _billvalue;
    map['billpaytype'] = _billtype;
    map['billpayammountmonths'] = _billammountMonths;
    map['billpaydate'] = _billdate;
  }

  BillsToPay.fromMap(Map<String,dynamic> map, String documentID ){
    this._billID = documentID;
    this._bill = map['billpayname'];
    this._billvalue = map['billpayvalue'];
    this._billtype = map['billpaytype'];
    this._billammountMonths = map['billpayammountmonths'];
    this._billdate = map['billpaydate'];
  }

  static formatPay(String pay){
    var p = pay.split(".");

    if(p[1].length == 1 ){
      pay = pay + "0";
    }

    return pay;
  }

  static calculateTotalMensal(List<BillsToPay> bills){

    double total = 0;

    for(BillsToPay bill in bills){
      total = total + bill.billvalue;
    }

    return formatPay(total.toString()).toString().replaceAll(".", ",");
  }
}