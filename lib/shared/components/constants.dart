//https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ae1a59e12c104b01997085796dab74bd
//https://newsapi.org/v2/everything?q=tesla&apiKey=ae1a59e12c104b01997085796dab74bd

// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca

import 'package:application1/modules/shop_app/login/shop_login_screen.dart';
import 'package:application1/shared/components/componants.dart';
import 'package:application1/shared/network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';
