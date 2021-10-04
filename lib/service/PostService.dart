import 'package:http/http.dart' as http;
import 'package:raid/model/UserData.dart';
import 'package:raid/service/base_api.dart';

class PostService extends BaseApi {
  Future<http.Response> sendComplaints(String message) async {
    return await api.httpPost("contacts/store", {"message": message});
  }

  Future<http.Response> sendSuggestionIntegration(
      int integrationCategoryId, String name, String tags) async {
    return await api.httpPost("integrations/store", {
      "integration_category_id": integrationCategoryId.toString(),
      "name": name,
      "tags": tags,
    });
  }

  Future<http.Response> register(AuthenticationData authenticationData) async {
    return await api.httpPost("register", authenticationData.getSignUpBody());
  }

  Future<http.Response> login(AuthenticationData data) async {
    return await api.httpPost("login", data.getLoginBody());
  }

  Future<http.Response> updateUserData(AuthenticationData data) async {
    return await api.httpPost("user/update", data.getUpdateBody());
  }

  Future<http.Response> addSale(var data) async {
    return await api.httpPost("sales", data);
  }

  Future<http.Response> addPurchse(var data) async {
    return await api.httpPost("purchses", data);
  }

  /////new post//////
  Future<http.Response> addCustomer(var data) async {
    return await api.httpPost("customers", data);
  }

  Future<http.Response> addSupplier(var data) async {
    return await api.httpPost("suppliers", data);
  }

  Future<http.Response> addExpense(var data) async {
    return await api.httpPost("expenses", data);
  }

  Future<http.Response> addProduct(var data) async {
    return await api.httpPost("products", data);
  }
//////end new post///
}
