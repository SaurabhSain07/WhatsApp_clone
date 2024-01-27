import 'package:flutter/cupertino.dart';
import 'package:whatsapp_web_clone/models/user_models.dart';

class ProviderChat with ChangeNotifier{
  UserModel? _toUserData;

  UserModel? get toUserData=> _toUserData;

  set toUserData(UserModel? userDataModel)
  {
    _toUserData=userDataModel;
    notifyListeners();
  }
}