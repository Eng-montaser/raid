import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Salesperson/preview.dart';
import 'package:raid/widget/cart_item.dart';
import 'package:raid/widget/gray_input_field.dart';

class Invoice extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Invoice> {
  List<CustomersData> customerData;
  List<ProductData> productData;
  List<CartItem> cart = [];
  double total = 0;
  CustomersData customer;
  TextEditingController _customerEditingController =
      TextEditingController(text: '');
  TextEditingController _productEditingController =
      TextEditingController(text: '');

  TextEditingController shippingController =
      new TextEditingController(text: '0.00');
  TextEditingController discountController =
      new TextEditingController(text: '0.00');
  // This will be displayed below the autocomplete field
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ///Cat And Products -------------------------------------

      ///Cat And Setting --------------------------------------
      customerData =
          await Provider.of<GetProvider>(context, listen: false).getCustomers();
      productData = await Provider.of<GetProvider>(context, listen: false)
          .getAllProducts();
    });
  }

  // This list holds all the suggestions
  updateTotal() {
    total = 0;
    for (var c in cart) {
      total = total + (c.product.price * c.qty);
      print('${c.qty}');
    }
    if (shippingController.text.isNotEmpty &&
        !shippingController.text.contains('-')) {
      total = total + (double.parse(shippingController.text));
    }
    if (discountController.text.isNotEmpty &&
        !discountController.text.contains('-')) {
      total = total - (double.parse(discountController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'إصدار فاتورة',
          style: FCITextStyle(color: Colors.white).bold18(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            customerData != null
                ? Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff1f1f1), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: ScreenUtil().setHeight(50),
                    child: TypeAheadField<CustomersData>(
                      suggestionsCallback: (pattern) async {
                        List<CustomersData> data = [];
                        provider.customersData.forEach((element) {
                          if (element.name.contains(pattern)) data.add(element);
                          print(pattern);
                        });
                        //   FocusManager.instance.primaryFocus.unfocus();

                        return data;
                      },
                      itemBuilder: (context, CustomersData suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.name != null ? suggestion.name : '',
                            style: FCITextStyle().bold16(),
                          ),
                          subtitle: Text(
                            suggestion.phone != null
                                ? '(${suggestion.phone})'
                                : '',
                            style: FCITextStyle(color: Colors.grey).normal16(),
                          ),
                        );
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            hintText: 'اختر العميل',
                          ),
                          textAlign: TextAlign.center,
                          controller: _customerEditingController),
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _customerEditingController.text = suggestion.name;
                          customer = suggestion;
                        });
                      },
                    ),
                  )

                /*AutoCompeteText(
                    hideText: false,
                    hintText: 'اسم العميل',
                    getSelected: (val) {
                      customer = val;
                    },
                    suggestions: customerData,
                  )*/
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    alignment: Alignment.centerRight,
                    child: Text('تحميل بيانات العملاء ...')),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            productData != null
                ? Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xfff1f1f1), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: ScreenUtil().setHeight(50),
                    child: TypeAheadField<ProductData>(
                      suggestionsCallback: (pattern) async {
                        List<ProductData> data = [];
                        productData.forEach((element) {
                          if (element.name.contains(pattern)) data.add(element);
                          print(pattern);
                        });
                        //  FocusManager.instance.primaryFocus.unfocus();
                        return data;
                      },
                      itemBuilder: (context, ProductData suggestion) {
                        //FocusManager.instance.primaryFocus.unfocus();
                        return ListTile(
                          title: Text(
                            suggestion.name != null ? suggestion.name : '',
                            style: FCITextStyle().bold16(),
                          ),
                          subtitle: Text(
                            suggestion.code != null
                                ? '(${suggestion.code})'
                                : '',
                            style: FCITextStyle(color: Colors.grey).normal16(),
                          ),
                        );
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            hintText: 'اسم الصنف',
                          ),
                          textAlign: TextAlign.center,
                          controller: _productEditingController),
                      onSuggestionSelected: (suggestion) async {
                        setState(() {
                          _productEditingController.text = '';
                        });
                        await cart.add(CartItem(product: suggestion, qty: 1));

                        productData.remove(suggestion);
                        updateTotal();
                      },
                    ),
                  )
                /*AutoCompeteText(
                    hintText: 'اسم الصنف',
                    getSelected: (val) async {
                      await cart.add(CartItem(product: val, qty: 1));

                      productData.remove(val);
                      updateTotal();
                    },
                    suggestions: productData,
                  )*/
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    alignment: Alignment.centerRight,
                    child: Text('تحميل بيانات المنتجات ...')),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _createShoppingCartRows(context),
                ),
              ),
            ),
            summary()
          ],
        ),
      ),
    );
  }

  Widget summary() {
    final smallAmountStyle = TextStyle(color: Theme.of(context).accentColor);
    final largeAmountStyle = FCITextStyle().bold16();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(15),
        // vertical: ScreenUtil().setHeight(10)
      ),
      child: Card(
        shadowColor: Colors.black,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(12),
              horizontal: ScreenUtil().setWidth(5)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('مصاريف الشحن', style: smallAmountStyle),
                  ),
                  Expanded(
                    child: GrayInputField(
                      inputType: TextInputType.number,
                      controller: shippingController,
                      hintText: '',
                      onChanged: (val) {
                        updateTotal();
                      },
                    ),
                  ),
                ],
              ),
              //    const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text('التخفيض', style: smallAmountStyle),
                  ),
                  Expanded(
                    child: GrayInputField(
                      inputType: TextInputType.number,
                      controller: discountController,
                      // initial: '0.0',
                      hintText: '',
                      onChanged: (val) {
                        updateTotal();
                      },
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text('الإجمالى:', style: largeAmountStyle),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} جنيه',
                    style: largeAmountStyle,
                  ),
                ],
              ),
              if (cart.length > 0)
                InkWell(
                  onTap: () {
                    if (customer != null)
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PreviewPage(
                                cart: cart,
                                discount:
                                    double.parse('${discountController.text}'),
                                shipping:
                                    double.parse('${shippingController.text}'),
                                customerData: customer,
                                total: total,
                              )));
                    //else
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: primaryColor),
                    child: Text(
                      'إتمام الشراء',
                      style: FCITextStyle(color: Colors.white).bold18(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _createShoppingCartRows(BuildContext context) {
    return cart.map((e) {
      //total = total + (e.qty * (e.product.price));
      double qty = double.parse('${e.qty}');
      //   double subtotal = e.price * qty;
      return ShoppingCartRow(
        product: e.product,
        quantity: qty,
        onChangeQuantity: (val) {
          e.setCart(double.parse('$val'));
          updateTotal();
        },
        onRemove: () async {
          await cart.remove(e);
          productData.add(e.product);
          updateTotal();
        },
      );
    }).toList();
  }
}
