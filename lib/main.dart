import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartwin/bloc/c4_bloc.dart';
import 'package:smartwin/constants.dart';
import 'package:smartwin/cubit/auth/auth_cubit.dart';
import 'package:smartwin/dio.dart';
import 'package:smartwin/generated/l10n.dart';
import 'package:smartwin/screens/login_screen.dart';
import 'package:smartwin/screens/main_screen.dart';
import 'package:smartwin/screens/register_screen.dart';
import 'package:smartwin/screens/room_screen.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
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
        home: const RegisterScreen(),
      ),
    );
  }
}
