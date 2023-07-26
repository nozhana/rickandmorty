import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';

abstract class SelectorSheet<T extends Enum> extends StatelessWidget {
  final String title;
  final IconData? headerIcon;
  final T? selected;
  final List<T> choices;
  final List<IconData>? choiceIcons;
  const SelectorSheet({
    Key? key,
    required this.title,
    required this.choices,
    this.headerIcon,
    this.choiceIcons,
    this.selected,
  }) : super(key: key);

  Future<ValueGetter<T?>?> present(BuildContext context) async {
    return await showModalBottomSheet<ValueGetter<T?>?>(
        useRootNavigator: true,
        isScrollControlled: true,
        constraints: const BoxConstraints.tightFor(width: 700),
        backgroundColor: Colors.transparent,
        elevation: 8.0,
        context: context,
        builder: ((context) => this..build(context)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Colors.grey.shade200),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Visibility(
                              visible: headerIcon != null,
                              child: Icon(headerIcon,
                                  color: theme().primaryColorDark)),
                          Visibility(
                              visible: headerIcon != null,
                              child: const SizedBox(width: 24.0)),
                          Text(
                            title,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 340
                                        ? 21.0
                                        : 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      onPressed: (() {
                        HapticFeedback.heavyImpact();
                        Navigator.pop<ValueGetter<T?>?>(context, (() => null));
                      }),
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: choices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop<ValueGetter<T?>?>(
                          context, (() => choices[index]));
                    },
                    enableFeedback: true,
                    leading: Radio<T>(
                        value: choices[index],
                        groupValue: selected,
                        onChanged: ((T? newValue) {
                          HapticFeedback.mediumImpact();
                          Navigator.pop<ValueGetter<T?>?>(
                              context, (() => newValue));
                        })),
                    trailing: Visibility(
                      visible: choiceIcons?.isNotEmpty ?? false,
                      child: Icon(
                        choiceIcons![index],
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    title: Text(
                      choices[index].name,
                      style: theme().textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
