import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_bloc.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_event.dart';
import 'package:training_example/translations/locale_keys.g.dart';
import '../../../constants/fonts.dart';

class ChangeNamePage extends StatefulWidget {
  final String currentName;
  const ChangeNamePage({Key? key, required this.currentName}) : super(key: key);

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final _formKey = GlobalKey<FormState>();
  final UserInfoBloc userInfoBloc = getIt.get<UserInfoBloc>();

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.currentName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.changeName.tr(),
            style: const TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red, size: 24),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontFamily: Fonts.muktaMedium),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: _validateUsername,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _changeName();
              },
              child: Container(
                color: Colors.red,
                height: 45,
                width: double.infinity,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(LocaleKeys.done.tr(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18))),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return LocaleKeys.invalidName.tr();
    }
    return null;
  }

  void _changeName() {
    if (_formKey.currentState!.validate()) {
      userInfoBloc.add(ChangeNameEvent(name: _nameController.text));
      GoRouter.of(context).pop();
    }
  }
}
