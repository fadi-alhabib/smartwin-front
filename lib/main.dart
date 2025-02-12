import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sw/common/constants/constants.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/config/generated/l10n.dart';
import 'package:sw/features/auth/cubit/auth_cubit.dart';
import 'package:sw/features/auth/screens/register_screen.dart';

import 'package:sw/features/home/cubit/home_cubit.dart';
import 'package:sw/features/home/screens/main_screen.dart';
import 'package:sw/features/rooms/bloc/pusher_bloc.dart';
import 'package:sw/features/rooms/cubit/room_cubit.dart';

import 'features/stores/all_stores/cubit/stores_cubit.dart';

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
        BlocProvider(create: (context) {
          return HomeCubit();
        }),
        BlocProvider<PusherBloc>(create: (context) => PusherBloc()),
        BlocProvider<RoomCubit>(create: (context) => RoomCubit()),
        // BlocProvider(
        //   create: (context) => C4Bloc(
        //       "ws://192.168.1.105:8080/ws/c4/974c0039-e0d2-4c53-b6b4-adad8fd99aef/"),
        // ),
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
        onGenerateRoute: (settings) {
          return null;

          // if (settings.name == "store_screen") {
          //   return MaterialPageRoute(
          //     builder: (context) => StoreScreen(
          //       index: 0,
          //     ),
          //   );
          // }
          // return null;
        },
        home: CacheHelper.getCache(key: 'token') != null
            ? const MainScreen()
            : const RegisterScreen(),
      ),
    );
  }
}
