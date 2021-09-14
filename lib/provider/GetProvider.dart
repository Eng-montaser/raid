import 'dart:convert';

import 'package:raid/model/BrandData.dart';
import 'package:raid/model/CodeData.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/model/NewModels.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/model/ProductReportData.dart';
import 'package:raid/model/SercicesData.dart';
import 'package:raid/model/SettingData.dart';
import 'package:raid/model/VideoData.dart';
import 'package:raid/provider/base_provider.dart';
import 'package:raid/service/GetService.dart';

class GetProvider extends BaseProvider {
  GetService _getService = GetService();

  ///Cat And Products -------------------------------------
  List<CatProductData> _catProducts = [];

  List<CatProductData> get catProducts => _catProducts;
  List<ProductData> _products = [];

  List<ProductData> get products => _products;

  ///Cat And Conciliation ---------------------------------
  List<ConciliationData> _conciliationData = [];

  List<ConciliationData> get conciliationData => _conciliationData;

  ///Cat And Offers --------------------------------------
  List<ProductOffer> _productOffers = [];

  List<ProductOffer> get productOffers => _productOffers;

  ///Cat And Brands --------------------------------------
  List<BrandData> _brandsData = [];

  List<BrandData> get brandsData => _brandsData;

  ///Cat And Service --------------------------------------
  List<ServicesData> _serviceData = [];

  List<ServicesData> get serviceData => _serviceData;

  ///Cat And Videos --------------------------------------
  List<VideoData> _videosData = [];

  List<VideoData> get videosData => _videosData;

  ///Cat And Codes --------------------------------------
  List<CodeData> _codesData = [];

  List<CodeData> get codesData => _codesData;

  ///Cat And Setting --------------------------------------
  SettingData _settingData;

  SettingData get settingData => _settingData;

  ///Customer Profile Data --------------------------------------
  CustomersProfileData _customersProfileData;

  CustomersProfileData get customersProfileData => _customersProfileData;

  ///Customers Data --------------------------------------
  List<CustomersData> _customersData = [];

  List<CustomersData> get customersData => _customersData;

  ///Customer Reports Data --------------------------------------
  CustomersReportData _customersReportData;

  CustomersReportData get customersReportData => _customersReportData;

  ///Cat And Products -------------------------------------
  Future<List<CatProductData>> getCatProducts() async {
    setBusy(true);
    try {
      var response = await _getService.getCatProducts();

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        _catProducts = [];
        data['data'].forEach((catProduct) =>
            _catProducts.add(CatProductData.fromJson(catProduct)));
        _catProducts.forEach((CatProductData element) {});
        print('cats ${response.statusCode} ${response.body}');
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _catProducts;
  }

  Future<List<ProductData>> getProducts() async {
    setBusy(true);
    try {
      var response = await _getService.getProducts();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _products = [];
        data['data']
            .forEach((product) => _products.add(ProductData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _products;
  }

  Future<List<ProductData>> getProductById(int id) async {
    setBusy(true);
    try {
      var response = await _getService.getProductById(id);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _products = [];
        data['data']
            .forEach((product) => _products.add(ProductData.fromJson(product)));
        print(' sss ${response.statusCode} ${response.body}');
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _products;
  }

  Future<List<ProductData>> getAllProducts() async {
    setBusy(true);
    try {
      var response = await _getService.getAllProducts();
      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _products = [];
        data.forEach((product) => _products.add(ProductData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _products;
  }

  Future<List<ProductData>> searchProduct(String text) async {
    List<ProductData> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.searchProduct(text);
      print('${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(ProductData.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }

  ///Cat And Conciliation ---------------------------------
  Future<List<ConciliationData>> getIntegrations() async {
    setBusy(true);
    try {
      var response = await _getService.getIntegrations();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _conciliationData = [];
        data['data'].forEach((product) =>
            _conciliationData.add(ConciliationData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _conciliationData;
  }

  ///Cat And Brands --------------------------------------
  Future<List<BrandData>> getBrands() async {
    setBusy(true);
    try {
      var response = await _getService.getBrands();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _brandsData = [];
        data.forEach((product) => _brandsData.add(BrandData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _brandsData;
  }

  ///Cat And Offers --------------------------------------
  Future<List<ProductOffer>> getOffers() async {
    setBusy(true);
    try {
      var response = await _getService.getOffers();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _productOffers = [];
        data['data'].forEach(
            (product) => _productOffers.add(ProductOffer.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _productOffers;
  }

  ///Cat And Service --------------------------------------
  Future<List<ServicesData>> getService() async {
    setBusy(true);
    try {
      var response = await _getService.getServices();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _serviceData = [];
        data['data'].forEach(
            (product) => _serviceData.add(ServicesData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _serviceData;
  }

  ///Cat And Videos --------------------------------------
  Future<List<VideoData>> getVideos() async {
    setBusy(true);
    try {
      var response = await _getService.getVideos();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _videosData = [];
        data['data']
            .forEach((product) => _videosData.add(VideoData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _videosData;
  }

  ///Cat And Codes --------------------------------------
  Future<List<CodeData>> getCodes() async {
    setBusy(true);
    try {
      var response = await _getService.getCodes();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _codesData = [];
        data['data']
            .forEach((product) => _codesData.add(CodeData.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _codesData;
  }

  ///Cat And Setting --------------------------------------
  Future<SettingData> getSetting() async {
    setBusy(true);
    try {
      var response = await _getService.getSetting();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _settingData = SettingData.fromJson(data[0]);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _settingData;
  }

  ///Customer Profile --------------------------------------
  Future<CustomersProfileData> getCustomerProfile() async {
    setBusy(true);
    try {
      var response = await _getService.getCustomerProfile();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _customersProfileData = CustomersProfileData.fromJson(data[0]);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _customersProfileData;
  }

  ///Customers Data --------------------------------------
  Future<List<CustomersData>> getCustomers() async {
    setBusy(true);
    try {
      var response = await _getService.getCustomers();
      var data = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        _customersData = [];
        data.forEach((customer) {
          _customersData.add(CustomersData.fromJson(customer));
          print(customer);
        });
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _customersData;
  }

  ///Customer Reports Data --------------------------------------
  Future<CustomersReportData> getCustomersReports(
      int customerId, String startDate, String endDate) async {
    setBusy(true);
    try {
      var response =
          await _getService.getCustomersReports(customerId, startDate, endDate);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print("|||||||||");
      print(data);
      if (response.statusCode == 200) {
        _customersReportData = CustomersReportData.fromJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _customersReportData;
  }

  Future<CustomersReportData> getUserData() async {
    setBusy(true);
    try {
      var response = await _getService.getUserData();
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print("|||||||||");
      print(data);
      if (response.statusCode == 200) {
//        _customersReportData = CustomersReportData.fromJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _customersReportData;
  }

  ///StockReport Data --------------------------------------
  Future<List<ProductReportData>> getStocksReports(
      String startDate, String endDate) async {
    List<ProductReportData> _productReportData = [];
    setBusy(true);
    try {
      var response = await _getService.getStocksReports(startDate, endDate);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        data['data'].forEach((productReport) {
          print(productReport);
        });
        _productReportData = [];
        data['data'].forEach((productReport) {
          _productReportData.add(ProductReportData.fromJson(productReport));
        });

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _productReportData;
  }

//////new providers///////
  Future<List<ExpenseCategory>> getExpenseCategories() async {
    List<ExpenseCategory> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getExpenseCategories();
      print('${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(ExpenseCategory.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }

  Future<List<Account>> getAccounts() async {
    List<Account> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getAccounts();
      print('${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(Account.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }

  Future<List<Warehouse>> getWarehouses() async {
    List<Warehouse> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getWarehouses();
      print('${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(Warehouse.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }

  Future<List<CustomerGroup>> getCustomerGroups() async {
    List<CustomerGroup> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getCustomerGroups();
      print('${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(CustomerGroup.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }
}
