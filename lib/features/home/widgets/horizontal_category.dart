import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
import '../../../translations/locale_keys.g.dart';

class HorizontalCategory extends StatefulWidget {
  final int initialIndex;

  final Function(int? index) onCategoryChange;

  const HorizontalCategory({Key? key, required this.initialIndex, required this.onCategoryChange}) : super(key: key);

  @override
  State<HorizontalCategory> createState() => _HorizontalCategoryState();
}

class _HorizontalCategoryState extends State<HorizontalCategory>{

  List<String> categories = [
    LocaleKeys.organic.tr(),
    LocaleKeys.fruit.tr(),
    LocaleKeys.veggies.tr(),
    LocaleKeys.grocery.tr(),
    LocaleKeys.fridge.tr(),
    LocaleKeys.seafood.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => TextButton(
          onPressed: () {},
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.onCategoryChange(index);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: index == widget.initialIndex
                      ? const Color.fromRGBO(247, 221, 222, 1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  categories[index].toUpperCase(),
                  style: TextStyle(
                      fontFamily: Fonts.muktaSemiBold,
                      fontSize: 20.0,
                      color: index == widget.initialIndex
                          ? const Color.fromRGBO(194, 112, 110, 1)
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
