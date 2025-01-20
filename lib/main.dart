import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartwin/common/utils/cache_helper.dart';
import 'package:smartwin/features/c4/bloc/c4_bloc.dart';
import 'package:smartwin/common/constants/constants.dart';
import 'package:smartwin/features/auth/cubit/auth_cubit.dart';
import 'package:smartwin/common/utils/dio_helper.dart';
import 'package:smartwin/config/generated/l10n.dart';
import 'package:smartwin/features/auth/screens/login_screen.dart';
import 'package:smartwin/features/home/screens/main_screen.dart';
import 'package:smartwin/features/auth/screens/register_screen.dart';
import 'package:smartwin/features/c4/screens/room_screen.dart';
import 'package:smartwin/features/stores/cubit/stores_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return AllStoresCubit();
          },
        ),
        BlocProvider(create: (context) {
          return AuthCubit();
        }),
        BlocProvider(
          create: (context) => C4Bloc(
              "ws://192.168.1.105:8080/ws/c4/974c0039-e0d2-4c53-b6b4-adad8fd99aef/"),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 36),
            primarySwatch: primarySwatch,
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 30, 30, 36),
                centerTitle: true)),
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: CacheHelper.getCache(key: 'token') != null
            ? MainScreen()
            : const RegisterScreen(),
      ),
    );
  }
}
