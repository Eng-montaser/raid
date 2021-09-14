import 'dart:convert';

import 'package:raid/model/UserData.dart';
import 'package:raid/provider/CasheManger.dart';
import 'package:raid/provider/base_provider.dart';
import 'package:raid/service/PostService.dart';
import 'package:raid/service/api.dart';

class PostProvider extends BaseProvider {
  PostService _postService = PostService();
  Api _api = Api();

  Future<AuthenticationResult> register(
      AuthenticationData authenticationData) async {
    AuthenticationResult authenticationResult;
    setBusy(true);
    try {
      var response = await _postService.register(authenticationData);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        authenticationResult = AuthenticationResult(
            success: true,
            message: 'Success',
            data: UserData.fromLoginJson(data));
        CacheManger().saveData(CacheType.userData, authenticationResult.data);
        notifyListeners();
        setBusy(false);
      } else {
        authenticationResult = AuthenticationResult(
          success: false,
          message: 'Fail',
        );
      }
    } catch (e) {
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
      var data = jsonDecode(response.body);
      print(data['user'].toString());
      print(response.statusCode);
      if (response.statusCode == 200) {
        authenticationResult = new AuthenticationResult(
            success: true,
            message: 'Success',
            data: UserData.fromLoginJson(data));
        CacheManger().saveData(CacheType.userData, authenticationResult.data);
        notifyListeners();
        setBusy(false);
      } else {
        authenticationResult = AuthenticationResult(
          success: false,
          message: 'Fail',
        );
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return authenticationResult;
  }

  Future<bool> sendComplaints(String message) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.sendComplaints(message);
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return result;
  }

  Future<bool> sendSuggestionIntegration(
      int integrationCategoryId, String name, String tags) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.sendSuggestionIntegration(
          integrationCategoryId, name, tags);
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return result;
  }

  Future<bool> addsale(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addSale(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return result;
  }

  ////new provider/////
  Future<bool> addCustomer(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addCustomer(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return result;
  }

  Future<bool> addSupplier(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addSupplier(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return result;
  }

  Future<bool> addExpense(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addExpense(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return result;
  }
////end new provider///
}
