import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/screens/search/views/components/filter_sort_screen.dart';
import 'package:shop/theme/input_decoration_theme.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    Key? key,
    required this.onSearch,
    this.controller,
  }) : super(key: key);

  final Function(String) onSearch;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (value) => onSearch(value),
        onChanged: (value) =>
            onSearch(value), // Add this if you want to search as the user types
        textInputAction: TextInputAction.search,
        autofocus:
            true, // Add this if you want the field to be focused automatically
        decoration: InputDecoration(
          hintText: "Find something...",
          filled: false,
          border: secodaryOutlineInputBorder(context),
          enabledBorder: secodaryOutlineInputBorder(context),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            ),
          ),
          suffixIcon: SizedBox(
            width: 40,
            child: Row(
              children: [
                const SizedBox(
                  height: 24,
                  child: VerticalDivider(width: 1),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: FilterSortScreen()
                      );
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/Filter.svg",
                      height: 24,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
