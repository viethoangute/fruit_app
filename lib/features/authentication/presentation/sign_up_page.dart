import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_example/generated/assets.dart';
import 'package:training_example/utils/snackbar_hepler.dart';
import '../../../constants/fonts.dart';
import '../../../di/injection.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../utils/string_helper.dart';
import '../blocs/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool isLoading = false;

  var authBloc = getIt.get<AuthBloc>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Visibility(
          visible: !isLoading,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.grey.shade600),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: BlocListener<AuthBloc, AuthState>(
                bloc: authBloc,
                listener: (context, state) {
                  if (state is SignUpErrorState) {
                    setState(() {
                      isLoading = false;
                    });
                    SnackBarHelper.showMessage(
                        context: context,
                        message: state.error,
                        duration: const Duration(seconds: 5),
                        hideAction: 'OK');
                  } else if (state is Loading) {
                    setState(() {
                      isLoading = true;
                    });
                  } else if (state is AuthenticatedState) {
                    Navigator.of(context).pop();
                  }
                },
                child: isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Image.asset(
                            Assets.assetsGreeting,
                            height: 300,
                            width: 300,
                          ),
                          const SizedBox(height: 50),
                          Text(
                            LocaleKeys.createAccount.tr(),
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.grey,
                                fontFamily: Fonts.muktaBold),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 24),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: LocaleKeys.email.tr(),
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                      labelStyle: const TextStyle(
                                          fontFamily: Fonts.muktaMedium),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    validator: _validateUsername,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 24),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.key_outlined),
                                      labelText: LocaleKeys.password.tr(),
                                      labelStyle: const TextStyle(
                                          fontFamily: Fonts.muktaMedium),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    obscureText: true,
                                    validator: _validatePassword,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 24),
                                  child: TextFormField(
                                    controller: _passwordConfirmController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.confirmation_num_outlined),
                                      labelText: LocaleKeys.confirmPW.tr(),
                                      labelStyle: const TextStyle(
                                          fontFamily: Fonts.muktaMedium),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    obscureText: true,
                                    validator: _validatePasswordConfirmation,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  _createUser();
                                },
                                child: const Icon(
                                  Icons.done,
                                  size: 30,
                                )),
                          ),
                        ],
                      )),
          ),
        ),
      ),
    );
  }

  // Form field validators
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty || value.length < 8 || !StringHelper.isEmailFormat(value)) {
      return LocaleKeys.invalidEmail.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return LocaleKeys.invalidPW.tr();
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value != _passwordController.text) {
      return 'The password you entered do not match';
    }
    return null;
  }

  void _createUser() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      authBloc.add(SignUpRequest(email: username, password: password));
    }
  }
}
