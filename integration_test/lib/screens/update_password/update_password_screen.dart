import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/screens/update_password/widget/update_password_form.dart';
import '../../common_export.dart';
import '../../shared/bloc/update_password/update_password_bloc.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late final UpadatePasswordBloc upadatePasswordBloc;

  @override
  void initState() {
    super.initState();
    upadatePasswordBloc = BlocProvider.of<UpadatePasswordBloc>(context);
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
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              context.pop();
            },
            color: Colors.black, // <-- SEE HERE
          ),
          centerTitle: true),
      body: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<UpadatePasswordBloc, UpdatePasswordState>(
          bloc: upadatePasswordBloc,
          listener: (context, state) {
            if (state is UpdatePasswordFailure) {
              _showError(state.message);
            }
            // if (state is UpdatePasswordStart) {
            //   //context.go('/root');
            // }
          },
          child: BlocBuilder<UpadatePasswordBloc, UpdatePasswordState>(
              bloc: upadatePasswordBloc,
              builder: (BuildContext context, UpdatePasswordState state) {
                return SafeArea(
                  child: Responsive.isDesktop(context)
                      ? Center(
                          child: Card(
                            elevation: 15,
                            child: SizedBox(
                                width: 500.toResponsiveWidth,
                                height: 650.toResponsiveHeight,
                                child: _updatePasswordForm(context, state)),
                          ),
                        )
                      : SingleChildScrollView(
                          child: _updatePasswordForm(context, state),
                        ),
                );
              }),
        ),
      ),
    );
  }

  Widget _updatePasswordForm(BuildContext context, UpdatePasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32.toResponsiveHeight),
        Center(
          child: CircleAvatar(
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
              Center(
                child: Text('UPDATE YOUR PASSWORD',
                    style: Theme.of(context).textTheme.displayMedium),
              ),
              SizedBox(height: 15.toResponsiveHeight),
              UpdatePasswordForm(
                  upadatePasswordBloc: upadatePasswordBloc, state: state),
            ],
          ),
        ),
      ],
    );
  }
}
