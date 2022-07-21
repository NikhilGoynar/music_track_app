import 'package:flutter/material.dart';
import 'package:music_track_app/Database/MemoDbprovider.dart';

import '../Database/memo_model.dart';

class Manage extends ChangeNotifier {
  bool isMark=false;
  List l = [];
  findId(int id){
    if(l.contains(id)){
      isMark=true;
     notifyListeners();
    }
    else{
      l.add(id);

      notifyListeners();
    }
    
    
  }
  makeList(int id){
    findId(id);
    notifyListeners();
  }
  makeFalse(){
    isMark=false;
    notifyListeners();
  }
 
}
