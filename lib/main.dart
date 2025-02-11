import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/authentication/blocs/auth_bloc.dart';
import 'package:training_example/features/authentication/presentation/login_page.dart';
import 'package:training_example/features/cart/bloc/cart_bloc.dart';
import 'package:training_example/features/general_page/bloc/connectivity_bloc.dart';
import 'package:training_example/features/general_page/bloc/connectivity_event.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_bloc.dart';
import 'package:training_example/features/search/bloc/search_bloc.dart';
import 'package:training_example/features/users_list/bloc/load_more/load_more_cubit.dart';
import 'package:training_example/routing/app_router.dart';
import 'package:training_example/features/splash/introduction_page.dart';
import 'package:training_example/translations/codegen_loader.g.dart';

import 'constants/fonts.dart';
import 'features/home/bloc/product_bloc/product_bloc.dart';
import 'features/users_list/bloc/remote_user/remote_user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();

  configureDependencies();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime && FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.signOut();
  }

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale(
        'vi',
      )
    ],
    path: 'assets/localization',
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    child: MaterialApp(
        theme: ThemeData(fontFamily: Fonts.muktaRegular),
        debugShowCheckedModeBanner: false,
        home: isFirstTime ? const IntroductionPage() : const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt.get<UserInfoBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<ProductBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<CartBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<SearchBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<LoadMoreCubit>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<RemoteUsersBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt.get<ConnectivityBloc>()..add(ConnectivityInitialEvent()),
          ),
        ],
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return MaterialApp.router(
                      debugShowCheckedModeBanner: false, routerConfig: router);
                } else {
                  return const LoginPage();
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
