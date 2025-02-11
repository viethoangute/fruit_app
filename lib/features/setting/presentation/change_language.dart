import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/translations/locale_keys.g.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late int currentLanguageIndex;
  late int choseLanguageIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLanguageIndex =
    EasyLocalization
        .of(context)
        ?.locale
        .toString() == 'en' ? 0 : 1;
    choseLanguageIndex = currentLanguageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(LocaleKeys.changeLanguage.tr(),
            style: const TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red, size: 24),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          Visibility(
            visible: currentLanguageIndex != choseLanguageIndex,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: Text(LocaleKeys.done.tr().toUpperCase(),
                      style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    if (currentLanguageIndex != choseLanguageIndex) {
                      if (choseLanguageIndex == 0) {
                        context.setLocale(const Locale('en'));
                      } else {
                        context.setLocale(const Locale('vi'));
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 1,
            child: Container(
              color: Colors.white,
              child: ListTile(
                leading: const Text('English'),
                trailing: choseLanguageIndex == 0
                    ? const Icon(Icons.check, color: Colors.red)
                    : null,
                onTap: () {
                  if (choseLanguageIndex != 0) {
                    setState(() {
                      choseLanguageIndex = 0;
                    });
                  }
                },
              ),
            ),
          ),
          Material(
            elevation: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              color: Colors.white,
              child: ListTile(
                leading: const Text('Tiếng Việt'),
                trailing: choseLanguageIndex == 1
                    ? const Icon(Icons.check, color: Colors.red)
                    : null,
                onTap: () {
                  if (choseLanguageIndex != 1) {
                    setState(() {
                      choseLanguageIndex = 1;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
