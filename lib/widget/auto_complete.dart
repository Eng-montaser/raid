import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutoCompeteText extends StatelessWidget {
  List<dynamic> suggestions;
  final bool hideText;
  final String hintText;
  // This will be displayed below the autocomplete field
  final Function getSelected;
  AutoCompeteText(
      {Key key,
      this.suggestions,
      this.getSelected,
      this.hideText = true,
      this.hintText});

  // This list holds all the suggestions

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .80,
      child: Autocomplete(
        fieldViewBuilder: getview,
        // displayStringForOption: ,
        optionsViewBuilder: getoptions,
        optionsBuilder: (TextEditingValue value) {
          // When the field is empty
          if (value.text.isEmpty) {
            return [];
          }

          // The logic to find out which ones should appear
          return suggestions.where((suggestion) => suggestion.name
              .toLowerCase()
              .contains(value.text.toLowerCase()));
        },
        displayStringForOption: (var options) => hideText ? '' : options.name,
        onSelected: (value) {
          FocusManager.instance.primaryFocus.unfocus();
          getSelected(value);
        },
      ),
    );
  }

  Widget getview(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      onFieldSubmitted) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey,
            spreadRadius: 3.5,
            blurRadius: 3.5,
            offset: Offset.infinite),
        BoxShadow(
            color: Colors.blue,
            spreadRadius: 3.5,
            blurRadius: 3.5,
            offset: Offset.infinite),
        BoxShadow(
            color: Colors.black,
            spreadRadius: 3.5,
            blurRadius: 3.5,
            offset: Offset.infinite)
      ], borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10))),
      ),
    );
  }

  Widget getoptions(
      BuildContext context, onSelected, Iterable<dynamic> options) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
          width: MediaQuery.of(context).size.width * .80,
          color: Colors.grey.shade100,
          child: ListView.builder(
            //padding: EdgeInsets.all(10.0),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              var option = options.elementAt(index);

              return GestureDetector(
                onTap: () {
                  onSelected(option);
                },
                child: ListTile(
                  title: Text(option.name, style: const TextStyle()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
