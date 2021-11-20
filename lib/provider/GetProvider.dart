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
  Product _mproducts;
  Offer _offers;
  List<ProductData> get products => _products;
  Offer get offers => _offers;
  Product get mproducts => _mproducts;

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
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _catProducts;
  }

  Future<Product> getProducts(int page) async {
    setBusy(true);
    try {
      var response = await _getService.getProducts(page);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _mproducts = Product.fromJson(data);
        if (page == 1) {
          _products = _mproducts.productdata;
        } else {
          products.addAll(_mproducts.productdata);
        }
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _mproducts;
  }

  ///Cat And Offers --------------------------------------
  Future<Offer> getOffers(int page) async {
    setBusy(true);
    try {
      var response = await _getService.getOffers(page);
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _offers = Offer.fromJson(data);
        if (page == 1) {
          _productOffers = _offers.productdata;
        } else {
          _productOffers.addAll(_offers.productdata);
        }

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _offers;
  }

  Future<Offer> searchOffers(String text, int page) async {
    setBusy(true);
    try {
      var response = await _getService.searchOffers(text, page);
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _offers = Offer.fromJson(data);
        if (page == 1) {
          _productOffers = _offers.productdata;
        } else {
          _productOffers.addAll(_offers.productdata);
        }

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _offers;
  }

  Future<Product> getProductById(int id, int page) async {
    setBusy(true);
    try {
      var response = await _getService.getProductById(id, page);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _mproducts = Product.fromJson(data);
        if (page == 1) {
          _products = _mproducts.productdata;
        } else {
          products.addAll(_mproducts.productdata);
        }
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _mproducts;
  }

  Future<List<ProductData>> getAllProducts() async {
    setBusy(true);
    try {
      var response = await _getService.getAllProducts();
      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _products = [];
        data.forEach((product) {
          if (ProductData.fromJson(product).price != null)
            _products.add(ProductData.fromJson(product));
        });
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _products;
  }

  Future<Product> searchProduct(String text, int page) async {
    Product searchProducts;
    setBusy(true);
    try {
      var response = await _getService.searchProduct(text, page);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        searchProducts = Product.fromJson(data);
        /* if (page == 1) {
          _products = _mproducts.productdata;
        } else {
          products.addAll(_mproducts.productdata);
        }*/

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
      //print('sss $e');
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

  Future<List<String>> getSearchBrand(int cat_id) async {
    List<String> brands = [];
    setBusy(true);
    try {
      var response = await _getService.getSearchBrand(cat_id);
      print('${response.statusCode} ${response.body}');
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        data.forEach((item) => brands.add(item));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return brands;
  }

  Future<List<Integrations>> getSearchModel(String text, int cat_id) async {
    List<Integrations> integrations = [];
    setBusy(true);
    try {
      var response = await _getService.getSearchModel(text, cat_id);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        data['data'].forEach(
            (product) => integrations.add(Integrations.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return integrations;
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

  Future<List<Unit>> getUnits() async {
    List<Unit> units = [];
    setBusy(true);
    try {
      var response = await _getService.getUnits();
      var data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        data['unites'].forEach((product) => units.add(Unit.fromJson(product)));
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return units;
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

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        _codesData = [];
        data['all_search_data']
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
      if (response.statusCode == 201) {
        _customersData = [];
        data.forEach((customer) {
          _customersData.add(CustomersData.fromJson(customer));
        });
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
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

      if (response.statusCode == 200) {
        _customersReportData = CustomersReportData.fromJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
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

      if (response.statusCode == 200) {
//        _customersReportData = CustomersReportData.fromJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return _customersReportData;
  }

  ///StockReport Data --------------------------------------

//////new providers///////
  Future<List<ExpenseCategory>> getExpenseCategories() async {
    List<ExpenseCategory> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getExpenseCategories();
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

  Future<List<SuppliersData>> getSuppliers() async {
    List<SuppliersData> searchProducts = [];
    setBusy(true);

    try {
      var response = await _getService.getSuppliers();
      print('sup ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data['data'].forEach(
            (product) => searchProducts.add(SuppliersData.fromJson(product)));

        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
    }
    setBusy(false);
    return searchProducts;
  }

  Future<ProductReportDataList> getStocksReports(
      String startDate, String endDate, int page, int warehouseId) async {
    ProductReportDataList _productReportDataList;
    setBusy(true);
    try {
      var response = await _getService.getStocksReports(
          startDate, endDate, page, warehouseId);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      Map<dynamic, dynamic> da = jsonDecode(response.body);
      print(da["data"]);
      for (dynamic key in da.keys) {
        if (key != "data") {
          print(key);
          print(da[key].toString());
        }
      }
      print(response.body);
      if (response.statusCode == 200) {
        _productReportDataList = ProductReportDataList.fromJson(data);
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _productReportDataList;
  }

  Future<List<WarehousesData>> getWarehousesData() async {
    List<WarehousesData> _warehousesDataList;
    setBusy(true);
    try {
      var response = await _getService.getWarehousesData();
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        _warehousesDataList = [];
        _warehousesDataList.add(new WarehousesData(name: 'الكل', wId: 1));
        data['data'].forEach((warehouse) {
          _warehousesDataList.add(WarehousesData.fromJson(warehouse));
        });
        notifyListeners();
        setBusy(false);
      }
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
    return _warehousesDataList;
  }
}
