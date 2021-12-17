import 'package:http/http.dart' as http;
import 'package:raid/service/base_api.dart';

class GetService extends BaseApi {
  Future<http.Response> getCatProducts() async {
    return await api.httpGet('categories');
  }

  Future<http.Response> getProducts(int page) async {
    return await api.httpGet('products', query: {'page': '$page'});
  }

  Future<http.Response> searchProduct(String text, int page) async {
    return await api
        .httpGet('products', query: {'search': '$text', 'page': '$page'});
  }

  Future<http.Response> getOffers(int page) async {
    return await api.httpGet('offers', query: {'page': '$page'});
  }

  Future<http.Response> searchOffers(String text, int page) async {
    return await api
        .httpGet('offers', query: {'search': '$text', 'page': '$page'});
  }

  Future<http.Response> getProductById(int id, int page) async {
    return await api
        .httpGet('products', query: {'category_id': '$id', 'page': '$page'});
  }

  Future<http.Response> getAllProducts() async {
    return await api.httpGet('all_products');
  }

  Future<http.Response> getIntegrations() async {
    return await api.httpGet('integrations');
  }

  Future<http.Response> getCodes(String text) async {
    return await api.httpGet('codes', query: {'search': '$text'});
  }

  Future<http.Response> getVideos() async {
    return await api.httpGet('videos');
  }

  Future<http.Response> getBrands() async {
    return await api.httpGet('brands');
  }

  Future<http.Response> getServices() async {
    return await api.httpGet('services');
  }

  Future<http.Response> getMobiles(String search, int page) async {
    return await api
        .httpGet('services', query: {"search": "$search", 'page': '$page'});
  }

  Future<http.Response> getSetting() async {
    return await api.httpGet('settings');
  }

  Future<http.Response> getCustomerProfile() async {
    return await api.httpGet('user/details');
  }

  Future<http.Response> getCustomers() async {
    return await api.httpGet('customers');
  }

/////new services///////
  Future<http.Response> getExpenseCategories() async {
    return await api.httpGet('expense_categories');
  }

  Future<http.Response> getAccounts() async {
    return await api.httpGet('accounts');
  }

  Future<http.Response> getCustomerGroups() async {
    return await api.httpGet('customer_groups');
  }

  Future<http.Response> getWarehouses() async {
    return await api.httpGet('warehouses');
  }

  Future<http.Response> getSuppliers() async {
    return await api.httpGet('suppliers');
  }

  Future<http.Response> getUnits() async {
    return await api.httpGet('unites');
  }

  Future<http.Response> getSearchBrand(int cat_id) async {
    return await api.httpGet('integrations/get_brands/$cat_id');
  }

  Future<http.Response> getSearchModel(String brand, int cat_id) async {
    return await api.httpGet('integrations/get_models/$cat_id/$brand');
  }

///////end new services///////////
  Future<http.Response> getCustomersReports(
      int customerId, String startDate, String endDate) async {
//    https://fsdmarketing.com/alraayid/api/customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06
//    return await api.httpGet('customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06');
    return await api.httpGet('customers/report', query: {
      'customer_id': '$customerId',
      'start_date': '$startDate',
      'end_date': '$endDate'
    });
  }

  /*Future<http.Response> getStocksReports(
      String startDate, String endDate) async {
//    https://fsdmarketing.com/alraayid/api/customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06
//    return await api.httpGet('customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06');
    return await api.httpGet('stock',
        query: {'start_date': '$startDate', 'end_date': '$endDate'});
  }*/

  Future<http.Response> getUserData() async {
    return await api.httpGet('user/details');
  }

  Future<http.Response> getStocksReports(
      String startDate, String endDate, int page, int warehouseId) async {
//    https://fsdmarketing.com/alraayid/api/customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06
//    return await api.httpGet('customers/report?customer_id=1&start_date=2020-01-01&end_date=2021-08-06');
    return await api.httpGet('stock', query: {
      'start_date': '$startDate',
      'end_date': '$endDate',
      'page': '$page',
      'warehouse_id': '${warehouseId.toString()}'
    });
  }

  Future<http.Response> getWarehousesData() async {
    return await api.httpGet('warehouses');
  }

  Future<http.Response> getCompanies() async {
    return await api.httpGet('companies');
  }

  Future<http.Response> getCodCat() async {
    return await api.httpGet('code_categories');
  }

  Future<http.Response> getCompanyCodCat(int com, int cat) async {
    return await api
        .httpGet('codes', query: {"category_id": "$cat", "company_id": "$com"});
  }
}
