import 'package:cloud_firestore/cloud_firestore.dart';

class Comments{
  String Comment , Pid,Uid,name,Uphoto;
  Timestamp Time;

  Comments(this.Comment, this.Pid, this.Uid, this.name, this.Uphoto, this.Time);
}