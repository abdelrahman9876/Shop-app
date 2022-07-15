import 'package:application1/layout/shop_app/shop_layout.dart';
import 'package:application1/models/shop_app/login_model.dart';
import 'package:application1/modules/shop_app/login/cubit/cubit.dart';
import 'package:application1/modules/shop_app/login/cubit/states.dart';
import 'package:application1/shared/components/componants.dart';
import 'package:application1/shared/components/constants.dart';
import 'package:application1/shared/network/local/cache_helper.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../register/shop_register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  String? aNullableString = null;
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    bool isPassword = true;

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.loginModel?.status == true &&
              state.loginModel?.status != null) {
            print(state.loginModel?.message);
            print(state.loginModel?.data?.token);
            CacheHelper.saveData(
                    key: 'token', value: state.loginModel?.data?.token)
                .then((value) {
              token = state.loginModel!.data!.token;
              navigateAndFinish(context, ShopLayout());
            });
          } else {
            print(state.loginModel?.message);
            showToast(
                text: state.loginModel!.message, state: ToastStates.ERROR);
          }
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: (Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.black)),
                      Text(
                        'Login Now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter Your Email Address';
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          isPassword: ShopLoginCubit.get(context).ispassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          onSubmit: (value) {
                            {
                              ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return ('Please enter Your Password');
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context) => defaultButton(
                            function: () {
                              if (formkey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'login',
                            isUpperCase: true),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('don\'t have an account?'),
                          defaultTextButton(
                              function: () {
                                navigateTo(context, ShopRegisterScreen());
                              },
                              text: 'register'),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ),
          ),
        );
      }),
    );
  }
}
