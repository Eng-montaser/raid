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

  Future<dynamic> addsale(var datas) async {
    setBusy(true);
    var data;
    try {
      var response = await _postService.addSale(datas);

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        print('${data}');
        notifyListeners();
        setBusy(false);
        //return data;
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return data;
  }

/*{message:  Sale created successfully,
invoice: {variant_id: null, product_batch_id: null, sale_id: 5, product_id: 1, qty: 1, sale_unit_id: 1, net_unit_price: 0, discount: 0, tax_rate: 0, tax: 0, total: 122, updated_at: 2021-11-25 01:24:47, created_at: 2021-11-25 01:24:47, id: 11}}*/
  Future<bool> addPurchase(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addPurchse(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        result = true;
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print('sss $e');
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

  Future<bool> addProduct(var datas) async {
    bool result = false;
    setBusy(true);
    try {
      var response = await _postService.addProduct(datas);
      var data = jsonDecode(response.body);
      print('returns ${response.statusCode} ${response.body}');
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
////end new provider///
}
