import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/shared/bloc/update_password/update_password_bloc.dart';
import '../../../../common_export.dart';

class UpdatePasswordForm extends StatefulWidget {
  final UpadatePasswordBloc upadatePasswordBloc;
  final UpdatePasswordState state;
  const UpdatePasswordForm(
      {Key? key, required this.upadatePasswordBloc, required this.state})
      : super(key: key);
  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = "";
    oldPasswordController.text = "";
    newPasswordController.text = "";
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
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('PhoneField'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Enter Phone No.',
              isDense: true,
              prefixIcon: Icon(
                Icons.perm_identity,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter Phone',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: phoneController,
            keyboardType: TextInputType.phone,
            autocorrect: false,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Phone is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 15.toResponsiveHeight),
          TextFormField(
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            key: const Key('oldPasswordField'),
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              labelText: 'Enter Old Password',
              hintText: 'Enter Old Password',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: oldPasswordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Old Password is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 15.toResponsiveHeight),
          TextFormField(
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            key: const Key('newPasswordField'),
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              labelText: 'Enter New Password',
              hintText: 'Enter New Password',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: newPasswordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'New Password is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 15.toResponsiveHeight),

          // SizedBox(height: 1.toResponsiveHeight),
          BlocListener<UpadatePasswordBloc, UpdatePasswordState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is UpdatePassState) {
                _showError('Password Update Successful');
                context.pop();
              }
            },
            child: ElevatedButton(
              // key: const Key('forgotButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                if (_key.currentState!.validate()) {
                  widget.upadatePasswordBloc.add(
                    UpdatePassword(
                      phone: phoneController.text,
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
                    ),
                  );
                } else {}
              },
              child: widget.state is UpdatePasswordLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.background,
                    )
                  : Text(
                      'Change Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 15.toResponsiveFont),
                    ),
            ),
          ),
          SizedBox(height: 12.toResponsiveHeight),
        ],
      ),
    );
  }
}
