import 'package:FTT/models/billstopay.dart';
import 'package:FTT/services/billspayservice.dart';
import 'package:FTT/utils/dropdownbuilder.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BillsPaysAdd extends StatefulWidget {
  final BillsToPay billsToPay;

  BillsPaysAdd(this.billsToPay);

  @override
  _BillsPaysAdd createState() => _BillsPaysAdd();
}

class _BillsPaysAdd extends State<BillsPaysAdd> {
  //Config serv
  BillsPayService fireServ = new BillsPayService();

  //Adding controllers
  TextEditingController _billNameController;
  TextEditingController _billValueController;
  TextEditingController _billAmmountMonthController;
  TextEditingController _billDateController;

  //Combo
  static List _payTypes = ["Fixo", "Parcelado", "Único"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentPay;
  String _currentDate;
  var dropDown = new DropDownBuilder(_payTypes);

  @override
  void initState() {
    _billNameController = new TextEditingController(text: widget.billsToPay.bill);
    _billValueController = new MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '');
    _billAmmountMonthController = new TextEditingController(text: widget.billsToPay.billammountMonths.toString());

    _dropDownMenuItems = dropDown.getDropDownMenuItems();
    _currentPay = _dropDownMenuItems[0].value;

    super.initState();
  }

  void changedDropDownItem(String selectedPay) {
    setState(() {
      _currentPay = selectedPay;
    });
  }

  void save() {

    fireServ
        .addBillsToPay(
            _billNameController.text,
            double.parse(_billValueController.text.replaceAll(",", ".")),
            _currentPay,
            int.parse(_billAmmountMonthController.text),
            _currentDate)
        .then((_) {
      Navigator.pop(context);
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
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  controller: _billNameController,
                  decoration: InputDecoration(labelText: "Conta"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _billValueController,
                  decoration: InputDecoration(labelText: "Valor"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Tipo da conta"),
                  value: _currentPay,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  controller: _billAmmountMonthController,
                  enabled: _currentPay == "Parcelado",
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantidade de meses"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: DateTimeField(
                  controller: _billDateController,
                  readOnly: true,
                  onChanged: (DateTime date){
                    _currentDate = date.toString();
                  },
                  format: DateFormat("dd/MM/yyyy"),
                  decoration: InputDecoration(labelText: "Data da conta"),
                  onShowPicker: (context, currentvalue) {
                    return showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                                primaryColor: Colors.deepOrange,
                                accentColor: Colors.deepOrangeAccent,
                                dialogBackgroundColor: Colors.white),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(2000),
                        initialDate: currentvalue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                        locale: Locale('pt', 'BR')
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      color: Color(0xFFFA7397),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Color(0xFFFDDE42)),
                      )),
                  // This button results in adding the contact to the database
                  RaisedButton(
                      color: Color(0xFFFA7397),
                      onPressed: () async {
                        save();
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Color(0xFFFDDE42)),
                      )),
                ],
              )
            ]),
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
                  'Nova conta à pagar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
