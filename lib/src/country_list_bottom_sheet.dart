import 'package:flutter/material.dart';

import '../country_picker.dart';
import 'country_list_view.dart';

void showCountryListBottomSheet({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
  VoidCallback? onClosed,
  List<String>? favorite,
  List<String>? exclude,
  List<String>? countryFilter,
  List<String>? chosen,
  bool showPhoneCode = false,
  CustomFlagBuilder? customFlagBuilder,
  CountryListThemeData? countryListTheme,
  bool searchAutofocus = false,
  bool showWorldWide = false,
  bool showSearch = true,
  bool useSafeArea = false,
  bool useRootNavigator = false,
  bool moveAlongWithKeyboard = false,
}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: (context) => _builder(
        context,
        onSelect,
        favorite,
        exclude,
        countryFilter,
        chosen,
        showPhoneCode,
        countryListTheme,
        searchAutofocus,
        showWorldWide,
        showSearch,
        moveAlongWithKeyboard,
        customFlagBuilder,
      ),
    ).whenComplete(() {
      if (onClosed != null) onClosed();
    });

Widget _builder(
    BuildContext context,
    ValueChanged<Country> onSelect,
    List<String>? favorite,
    List<String>? exclude,
    List<String>? countryFilter,
    List<String>? chosen,
    bool showPhoneCode,
    CountryListThemeData? countryListTheme,
    bool searchAutofocus,
    bool showWorldWide,
    bool showSearch,
    bool moveAlongWithKeyboard,
    CustomFlagBuilder? customFlagBuilder,
    ) {
  final width = countryListTheme?.bottomSheetWidth;

  var backgroundColor = countryListTheme?.backgroundColor ??
      Theme.of(context).bottomSheetTheme.backgroundColor;

  if (backgroundColor == null) {
    if (Theme.of(context).brightness == Brightness.light) {
      backgroundColor = Colors.white;
    } else {
      backgroundColor = Colors.black;
    }
  }

  final borderRadius = countryListTheme?.borderRadius ??
      const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      );
  return Padding(
    padding: moveAlongWithKeyboard
        ? MediaQuery.of(context).viewInsets
        : EdgeInsets.zero,
    child: DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: width,
          padding: countryListTheme?.padding,
          margin: countryListTheme?.margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Positioned(
                top: 16,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              CountryListView(
                onSelect: onSelect,
                scrollController: scrollController,
                exclude: exclude,
                favorite: favorite,
                chosen: chosen,
                countryFilter: countryFilter,
                showPhoneCode: showPhoneCode,
                countryListTheme: countryListTheme,
                searchAutofocus: searchAutofocus,
                showWorldWide: showWorldWide,
                showSearch: showSearch,
                customFlagBuilder: customFlagBuilder,
              ),
            ],
          ),
        );
      },
    ),
  );
}
