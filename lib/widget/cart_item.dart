import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/style/FCITextStyles.dart';

class ShoppingCartRow extends StatefulWidget {
  ShoppingCartRow({
    @required this.product,
    @required this.quantity,
    //  @required this.subtotal,
    this.onRemove,
    this.onChangeQuantity,
  });

  final ProductData product;
  final double quantity;
//  final double subtotal;
  final Function onChangeQuantity;
  final VoidCallback onRemove;

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {
  double subtotal = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subtotal = widget.quantity * widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              key: ValueKey(widget.product.productId),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /*Container(
                        width: constraints.maxWidth * 0.25,
                        height: constraints.maxWidth * 0.3,
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.contain,
                        ),
                      ),*/
                      SizedBox(width: ScreenUtil().setWidth(16)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: FCITextStyle().normal16(),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: ScreenUtil().setHeight(7)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('السعر ${widget.product.price}',
                                      style: FCITextStyle(color: Colors.orange)
                                          .normal14()),
                                  Text(
                                    'إجمالى الصنف  ${(subtotal).toStringAsFixed(2)}',
                                    style: FCITextStyle(color: Colors.orange)
                                        .normal14(),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setHeight(10)),
                              QuantitySelection(
                                enabled: widget.onChangeQuantity != null,
                                width: ScreenUtil().setWidth(60),
                                height: ScreenUtil().setHeight(30),
                                color: Theme.of(context).accentColor,
                                limitSelectQuantity: widget.product?.qty != null
                                    ? int.parse(
                                        '${widget.product.qty}'.split('.')[0])
                                    : 100,
                                value: widget.quantity,
                                onChanged: (val) {
                                  widget.onChangeQuantity(val);
                                  setState(() {
                                    subtotal = val * widget.product.price;
                                  });
                                },
                                useNewDesign: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(16)),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: primaryColor,
                    ),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            //  const SizedBox(height: 5.0),
            const Divider(color: accentColor, height: 1),
            SizedBox(height: ScreenUtil().setHeight(5)),
          ],
        );
      },
    );
  }
}

class QuantitySelection extends StatefulWidget {
  final int limitSelectQuantity;
  final double value;
  final double width;
  final double height;
  final Function onChanged;
  final Color color;
  final bool useNewDesign;
  final bool enabled;
  final bool expanded;

  QuantitySelection({
    @required this.value,
    this.width = 40.0,
    this.height = 42.0,
    this.limitSelectQuantity = 100,
    @required this.color,
    this.onChanged,
    this.useNewDesign = true,
    this.enabled = true,
    this.expanded = false,
  });

  @override
  _QuantitySelectionState createState() => _QuantitySelectionState();
}

class _QuantitySelectionState extends State<QuantitySelection> {
  final TextEditingController _textController = TextEditingController();
  Timer _debounce;

  Timer _changeQuantityTimer;

  @override
  void initState() {
    super.initState();
    _textController.text = '${widget.value}'.split('.')[0];
    _textController.addListener(_onQuantityChanged);
    print('${widget.value}  ggg');
  }

  @override
  void dispose() {
    _textController?.removeListener(_onQuantityChanged);
    _changeQuantityTimer?.cancel();
    _debounce?.cancel();
    _textController?.dispose();
    super.dispose();
  }

  int get currentQuantity => int.tryParse(_textController.text) ?? -1;

  bool _validateQuantity([int value]) {
    print('dd $value');
    if ((value ?? currentQuantity) <= 0) {
      _textController.text = '1';
      return false;
    }

    if ((value ?? currentQuantity) > widget.limitSelectQuantity) {
      print('yes ${widget.limitSelectQuantity}');
      _textController.text = '${widget.limitSelectQuantity}';
      return false;
    }
    return true;
  }

  void changeQuantity(int value, {bool forceUpdate = false}) {
    if (!_validateQuantity(value)) {
      return;
    }

    if (value != currentQuantity || forceUpdate == true) {
      _textController.text = '$value';
    }
  }

  void _onQuantityChanged() {
    if (!_validateQuantity()) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (widget.onChanged != null) {
          widget.onChanged(currentQuantity);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useNewDesign == true) {
      final _iconPadding = EdgeInsets.all(
        max(
          ((widget.height ?? 32.0) - 24.0 - 8) * 0.5,
          0.0,
        ),
      );
      final _textField = Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: widget.height,
        width: widget.expanded == true ? null : widget.width,
        decoration: BoxDecoration(
          border: Border.all(width: .50, color: accentColor),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: TextField(
          readOnly: widget.enabled == false,
          enabled: widget.enabled == true,
          controller: _textController,
          maxLines: 1,
          maxLength: '${widget.limitSelectQuantity ?? 1000}'.length,
          onEditingComplete: _validateQuantity,
          onSubmitted: (_) => _validateQuantity(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          textAlign: TextAlign.center,
        ),
      );
      return Row(
        children: [
          widget.enabled == true
              ? IconButton(
                  padding: _iconPadding,
                  onPressed: () => changeQuantity(currentQuantity - 1),
                  icon: const Center(
                      child: Icon(
                    Icons.remove_circle_outline_sharp,
                    size: 20,
                  )),
                )
              : const SizedBox.shrink(),
          widget.expanded == true
              ? Expanded(
                  child: _textField,
                )
              : _textField,
          widget.enabled == true
              ? IconButton(
                  padding: _iconPadding,
                  onPressed: () => changeQuantity(currentQuantity + 1),
                  icon: const Icon(
                    Icons.add_circle_outline_sharp,
                    size: 20,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          showOptions(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: accentColor),
          borderRadius: BorderRadius.circular(3),
        ),
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: (widget.onChanged != null) ? 5.0 : 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(fontSize: 14, color: widget.color),
                  ),
                ),
              ),
              if (widget.onChanged != null)
                const SizedBox(
                  width: 5.0,
                ),
              if (widget.onChanged != null)
                Icon(Icons.keyboard_arrow_down,
                    size: 14, color: Theme.of(context).accentColor)
            ],
          ),
        ),
      ),
    );
  }

  void showOptions(context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int option = 1;
                          option <= widget.limitSelectQuantity;
                          option++)
                        ListTile(
                            onTap: () {
                              widget.onChanged(option);
                              Navigator.pop(context);
                            },
                            title: Text(
                              option.toString(),
                              textAlign: TextAlign.center,
                            )),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                decoration: const BoxDecoration(color: accentColor),
              ),
              ListTile(
                title: Text(
                  'الكمية',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }
}
