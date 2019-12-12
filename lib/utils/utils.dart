import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/studentservice.dart';
import '../main.dart';

Widget todoType(String url) {
  return CircleAvatar(
    backgroundColor: Colors.deepOrangeAccent,
    child: ClipOval(
      child: SizedBox(
        width: 180.0,
        height: 180.0,
        child: (url != "")
            ? Image.network(url, fit: BoxFit.fill)
            : new Icon(Icons.person),
      ),
    ),
  );
}


showAlertDialog(
    BuildContext context, String idAluno, List<dynamic> pagamentos, StudentService fireServ) {
  pagamentos.sort();
  String ultimoPagamento = getLastPay(pagamentos);

  Widget cancelButton = FlatButton(
    child: Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  var lastPay = DateTime.parse(pagamentos.last.toString());
  var currentDate = DateTime.now();

  bool desabilitar = ((lastPay.year == currentDate.year) &&
      (lastPay.month == currentDate.month))
      ? true
      : false;

  Widget payButton = FlatButton(
    child: Text("Confirmar Pagamento"),
    onPressed: desabilitar
        ? null
        : () async {
      fireServ.addPayDate(DateTime.now().toString(), idAluno);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Pagamento"),
    content: new RichText(
      text: new TextSpan(
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(
                text: 'Último pagamento: ',
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new TextSpan(text: "$ultimoPagamento\n\n"),
            new TextSpan(
                text: "Confirma o pagamento desse mês?",
                style: new TextStyle(fontWeight: FontWeight.bold)),
          ]),
    ),
    actions: [
      cancelButton,
      payButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String getLastPay(List<dynamic> pagamentos) {
  return DateFormat("dd/MM/yyyy")
      .format(DateTime.parse(pagamentos.last.toString()));
}

bool payLate(String day, List<dynamic> ultimosPagamento) {
  ultimosPagamento.sort();
  var ultimoPagamento = DateTime.parse(ultimosPagamento.last.toString());

  var utcUltimoPagamento =
  DateTime.utc(ultimoPagamento.year, ultimoPagamento.month);

  var mesCorrenteUtc =
  DateTime.utc(DateTime.now().year, DateTime.now().month);

  if (utcUltimoPagamento.isBefore(mesCorrenteUtc)) {
    int d = int.parse(day);
    int dayMonth = new DateTime.now().day;
    if (dayMonth > d) {
      return true;
    }
  }

  return false;
}