
class Task{
  String _taskid;
  String _taskname;
  String _taskphone;
  String _taskdate;
  String _taskDateInsert;
  String _taskImage;
  List<dynamic>  _taskPagamentos;

  Task(this._taskname,this._taskphone,this._taskdate,this._taskDateInsert, this._taskImage);

  Task.map(dynamic obj){
    this._taskid = obj['taskid'];
    this._taskname = obj['taskname'];
    this._taskphone = obj['taskphone'];
    this._taskdate = obj['taskdate'];
    this._taskDateInsert = obj['taskdateinsert'];
    this._taskImage = obj['taskImage'];
    this._taskPagamentos = obj['taskpagamentos'];
  }

  String get  taskid => _taskid;
  String get  taskname => _taskname;
  String get  taskphone => _taskphone;
  String get  taskdate => _taskdate;
  String get  taskDateInsert => _taskDateInsert;
  String get  taskImage => _taskImage;
  List<dynamic> get  taskpagamentos => _taskPagamentos;


  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['taskname']=_taskname;
     map['taskphone'] = _taskphone;
    map['taskdate'] = _taskdate;
    map['taskdateinsert'] = _taskDateInsert;
    map['taskImage'] = _taskImage;
    return map;
  }

  Task.fromMap(Map<String,dynamic> map, String documentID ){
    this._taskid = documentID;
    this._taskname= map['taskname'];
    this._taskphone = map['taskphone'];
    this._taskdate = map['taskdate'];
    this._taskDateInsert = map['taskdateinsert'];
    this._taskImage = map['taskImage'];
    this._taskPagamentos = map['taskpagamentos'];
  }
}