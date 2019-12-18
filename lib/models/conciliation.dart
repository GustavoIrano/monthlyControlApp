class ConciliationModel{
  int _day;
  String _billsToPay;
  String _studentsToReceive;
  double _valueToReceive;
  double _valueToPay;
  double _total;

  ConciliationModel(this._day, this._billsToPay, this._valueToReceive, this._valueToPay, this._studentsToReceive, this._total);

  int get day => _day;
  String get billsToPay => _billsToPay;
  double get valueToReceive => _valueToReceive;
  double get valueToPay => _valueToPay;
  String get studentsToReceive => _studentsToReceive;
  double get total => _total;

  set day(int d){
    _day = d;
  }

  set total(double t){
    _total = t;
  }

  set studentsToReceive(String studs){
    _studentsToReceive = studs;
  }

  set billsToPay(String btp){
    _billsToPay = btp;
  }

  set valueToReceive(double vtr){
    _valueToReceive = vtr;
  }

  set valueToPay(double vtp){
    _valueToPay = vtp;
  }
}