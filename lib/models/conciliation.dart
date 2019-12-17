class ConciliationModel{
  int _day;
  String _billsToPay;
  double _valueToReceive;
  double _valueToPay;

  ConciliationModel(this._day, this._billsToPay, this._valueToReceive, this._valueToPay);

  int get day => _day;
  String get billsToPay => _billsToPay;
  double get valueToReceive => _valueToReceive;
  double get valueToPay => _valueToPay;

  set day(int d){
    _day = d;
  }

  set biilsToPay(String btp){
    _billsToPay = btp;
  }

  set valueToReceive(double vtr){
    _valueToReceive = vtr;
  }

  set valueToPay(double vtp){
    _valueToPay = vtp;
  }
}