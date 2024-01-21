import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../common_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            if (state is AppAutheticated) {
              if (state.usertype == 1) {
                context.go('/adminRoot');
              } else {
                context.go('/userRoot');
              }
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              bloc: authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                return SafeArea(
                  child: Responsive.isDesktop(context)
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
                );
              }),
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
        SizedBox(height: 10.toResponsiveHeight),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 32.toResponsiveWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login', style: Theme.of(context).textTheme.displayLarge),
              SizedBox(height: 15.toResponsiveHeight),
              LoginForm(
                authenticationBloc: authenticationBloc,
                state: state,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.toResponsiveHeight),
      ],
    );
  }
}
