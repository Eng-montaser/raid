
import 'dart:convert';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:raid/model/BrandData.dart';
import 'package:raid/model/CodeData.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/model/SercicesData.dart';
import 'package:raid/model/SettingData.dart';
import 'package:raid/model/VideoData.dart';
import 'package:raid/provider/base_provider.dart';
import 'package:raid/service/GetService.dart';
import 'package:raid/service/PostService.dart';
import 'package:raid/service/api.dart';
import 'package:raid/model/UserData.dart';

import 'CasheManger.dart';

class AuthProvider extends BaseProvider {
  GetService _getService = GetService();
  PostService _postService=PostService();

  ///Cat And Products -------------------------------------
 UserData _userData =new UserData();
  UserData get userData  => _userData;

  Future<bool> setUserDataFromCache()async{
    bool result;
   await  CacheManger().getData(CacheType.userData).then((value){
      if(value.token!=null) {
        _userData=value;
        result= true;
      }else{
        result=false;
      }
    });
    return result;
  }
//  Future<AuthenticationResult> register(AuthenticationData authenticationData) async {
//    AuthenticationResult authenticationResult;
//    setBusy(true);
//    try {
//      var response = await _postService.register(authenticationData);
//      var data = jsonDecode(response.body);
//      print(response.statusCode);
//      print(data);
//      if (response.statusCode == 200) {
//        _userData=UserData.fromLoginJson(data);
//        authenticationResult=AuthenticationResult(
//            success: true,
//            message: 'Success',
//            data:_userData
//        );
//        print("in User Data");
//        CacheManger().saveData(CacheType.userData, _userData);
//        notifyListeners();
//        setBusy(false);
//      }else{
//        authenticationResult=AuthenticationResult(
//          success: false,
//          message: 'Fail',
//        );
//      }
//    } catch (e) {
//      setBusy(false);
//    }
//    setBusy(false);
//    return authenticationResult;
//  }
  Future<AuthenticationResult> register(
      AuthenticationData authenticationData) async {
    AuthenticationResult authenticationResult;
    print(authenticationData.getSignUpBody());
    setBusy(true);
    try {
      var response = await _postService.register(authenticationData);
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print("Register Body :$data");
      if (response.statusCode == 200){
        _userData = UserData.fromLoginJson(data);
        authenticationResult = AuthenticationResult(
            success: true, message: 'تم تسجيل الدخول بنجاح', data: _userData);
        await CacheManger().saveData(CacheType.userData, _userData);
        notifyListeners();
        setBusy(false);
      }else {
        if(data["message"]!=null) {
          authenticationResult = AuthenticationResult(
            success: false,
            message: "${data["message"]}\n ${data["errors"]}",
          );
        }else{
          authenticationResult = AuthenticationResult(
            success: false,
            message: "هناك خطا فى تسجيل الدخول",
          );
        }
      }
    } catch (e) {
      print("Try Fail: $e");
      authenticationResult = AuthenticationResult(
        success: false,
        message: "هناك خطا فى تسجيل الدخول",
      );
      setBusy(false);
    }
    setBusy(false);
    return authenticationResult;
  }
  Future<AuthenticationResult> login(
      AuthenticationData authenticationData) async {
    AuthenticationResult authenticationResult;
    setBusy(true);
    try {
      var response = await _postService.login(authenticationData);
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print("Body Login :$data");
      print("User Body Login :${data['user'].toString()}");
      if (response.statusCode == 200) {
        _userData = UserData.fromLoginJson(data);
        authenticationResult = new AuthenticationResult(
            success: true, message:"تم تسجيل الدخول بنجاح", data: _userData);
        await CacheManger().saveData(CacheType.userData, _userData);
        notifyListeners();
        setBusy(false);
      } else {
        if(data["message"]!=null) {
          authenticationResult = AuthenticationResult(
            success: false,
            message: "${data["message"]}\n ${data["errors"]}",
          );
        }else{
          authenticationResult = AuthenticationResult(
            success: false,
            message: "هناك خطا فى تسجيل الدخول",
          );
        }
      }
    } catch (e) {
      print("Try Fail: $e");
      authenticationResult = AuthenticationResult(
        success: false,
        message: "هناك خطا فى تسجيل الدخول",
      );
      setBusy(false);
    }
    setBusy(false);
    return authenticationResult;
  }
//  Future<AuthenticationResult> login( AuthenticationData authenticationData )async {
//    AuthenticationResult authenticationResult;
//    setBusy(true);
//    try {
//      var response = await _postService.login(authenticationData );
//      var data = jsonDecode(response.body);
//      print(data['user'].toString());
//      print(response.statusCode);
//      if (response.statusCode == 200) {
//        _userData=UserData.fromLoginJson(data);
//        authenticationResult=new AuthenticationResult(
//            success: true,
//            message: 'Success',
//            data:  _userData
//        );
//        CacheManger().saveData(CacheType.userData, _userData);
//        notifyListeners();
//        setBusy(false);
//      }else{
//        authenticationResult=AuthenticationResult(
//          success: false,
//          message: 'Fail',
//        );
//      }
//    } catch (e) {
//      setBusy(false);
//    }
//    setBusy(false);
//    return authenticationResult;
//  }
  Future<UserData> getUserData() async {
    UserData _userData;
    setBusy(true);
    try {
      var response = await _getService.getUserData();
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print("|||||||||");
      print(data);
      if (response.statusCode == 200) {
        _userData = UserData.fromLoginJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _userData;
  }
  Future<AuthenticationResult> updateUserData(authenticationData) async {
    AuthenticationResult authenticationResult;
    setBusy(true);
    try {
      var response = await _postService.updateUserData(authenticationData);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print("|||||||||");
      print(data);
      if (response.statusCode == 200) {
        _userData.updateUserData(data);
        authenticationResult=new AuthenticationResult(
            success: true,
            message: 'Success',
            data:  _userData
        );
        CacheManger().saveData(CacheType.userData, _userData);
        notifyListeners();
        setBusy(false);
      }else{
        authenticationResult=AuthenticationResult(
          success: false,
          message: 'Fail',
        );
      }
    } catch (e) {
      print(e);
      authenticationResult=AuthenticationResult(
        success: false,
        message: 'Fail',
      );
      setBusy(false);
    }
    setBusy(false);
    return authenticationResult;
  }
}