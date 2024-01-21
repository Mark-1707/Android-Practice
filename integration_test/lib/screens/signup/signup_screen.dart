import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../common_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  void _showError(String error) async {
    await Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: authenticationBloc,
          listener: (context, state) {
            if (state is AuthenticationFailure) {
              _showError(state.message);
            }
            if (state is SignUpState) {
              context.go('/login');
              _showError(state.message);
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              return SafeArea(
                  child: Stack(
                children: [
                  Responsive.isDesktop(context)
                      ? Center(
                          child: Card(
                            elevation: 15,
                            child: SizedBox(
                                width: 500.toResponsiveWidth,
                                height: 650.toResponsiveHeight,
                                child: _authenticationForm(context, state)),
                          ),
                        )
                      : SingleChildScrollView(
                          child: _authenticationForm(context, state),
                        ),
                  Positioned(
                    left: 6,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                        color: Theme.of(context).textTheme.displayLarge!.color,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }

  Widget _authenticationForm(BuildContext context, AuthenticationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32.toResponsiveHeight),
        Center(
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Image.asset(
                AllImages().logo,
                width: 100.toResponsiveWidth,
                height: 100.toResponsiveHeight,
              )),
        ),
        // Center(
        //   child: Image.asset(
        //     AllImages().signup,
        //     width: 260.toResponsiveWidth,
        //     height: 250.toResponsiveHeight,
        //   ),
        // ),
        SizedBox(height: 12.toResponsiveHeight),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 32.toResponsiveWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.displayLarge),
              SizedBox(height: 15.toResponsiveHeight),
              SignUpForm(
                authenticationBloc: authenticationBloc,
                state: state,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.toResponsiveHeight),
        Center(
          child: RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: ' Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pop();
                      //BUTTON ACTION
                    },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.toResponsiveHeight),
      ],
    );
  }
}