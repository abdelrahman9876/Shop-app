import 'dart:developer';

import 'package:application1/shared/bloc_observer.dart';
import 'package:application1/shared/components/constants.dart';
import 'package:application1/shared/cubit/cubit.dart';
import 'package:application1/shared/cubit/states.dart';
import 'package:application1/shared/network/local/cache_helper.dart';
import 'package:application1/shared/network/remote/dio_helper.dart';
import 'package:application1/shared/styles/themes.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/shop_app/login/shop_login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';


void main() async {
  //Future.delayed(const Duration(milliseconds: 500), () => makeRequest());
  WidgetsFlutterBinding.ensureInitialized();
  blocObserver:
  MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(isDark: isDark, startwidget: widget));
    },
  );
}

// Stateless
// Stateful
// class MyApp
class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startwidget;
  MyApp({this.isDark, this.startwidget});

  // constructor
  // build
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark,
              ),
          ),
          BlocProvider(
              create: (BuildContext context) => ShopCubit()
                ..getHomeData()
                ..getCategories()
                ..getFavorites()
                ..getUserData()),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: AppCubit.get(context).isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: startwidget,
              );
            }));
  }
}
