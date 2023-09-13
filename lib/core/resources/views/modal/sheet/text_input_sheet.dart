import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class TextInputSheet extends StatelessWidget {
  final String title;
  final IconData? headerIcon;
  final String? prefilledText;
  final String? hintText;
  final IconData? okIcon;
  final String? okText;
  final TextEditingController _textEditingController = TextEditingController();

  TextInputSheet({
    Key? key,
    required this.title,
    this.headerIcon,
    this.prefilledText,
    this.hintText,
    this.okIcon,
    this.okText,
  }) : super(key: key) {
    _textEditingController.text = prefilledText ?? '';
  }

  Future<String?> present(BuildContext context) async {
    return await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      constraints: const BoxConstraints.tightFor(width: 700),
      backgroundColor: Colors.transparent,
      elevation: 8.0,
      context: context,
      builder: (context) => this..build(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Theme.of(context).cardColor),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                          Visibility(
                              visible: headerIcon != null,
                              child: const SizedBox(width: 40)),
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
                        Navigator.pop<String?>(context, '');
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
              TextField(
                controller: _textEditingController,
                autofocus: false,
                decoration: InputDecoration(
                    counterStyle: const TextStyle(height: 4.0),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    hintText: hintText,
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                keyboardType: TextInputType.name,
                maxLength: 24,
                onEditingComplete: () {
                  Navigator.pop(context, _textEditingController.text);
                },
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context, _textEditingController.text);
                  },
                  icon: Icon(
                    okIcon ?? Icons.check,
                    color: Colors.green.shade400,
                  ),
                  label: Text(
                    okText ?? "OK",
                    style: TextStyle(color: Colors.green.shade400),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
