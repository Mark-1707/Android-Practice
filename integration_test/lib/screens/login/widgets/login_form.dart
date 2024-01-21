// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../../common_export.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationState state;
  const LoginForm(
      {Key? key, required this.authenticationBloc, required this.state})
      : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = "";
    _passwordController.text = "";
  }

  void checkSMSPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      print("permissionStatus ${permissionStatus.isGranted}");
    } else {
      // access the resoruce
      widget.authenticationBloc.add(UserLogin(
          phone: _phoneController.text, password: _passwordController.text));
    }
  }

  Future<bool?> askPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted == true) {
      PermissionStatus status = await Permission.sms.request();
    } else {
      PermissionStatus status = await Permission.sms.request();
      askPermission();
    }
    if (status.isGranted == true) {
      PermissionStatus status = await Permission.storage.request();
    } else {
      askPermission();
    }
    if (status.isGranted == true) {
      PermissionStatus status = await Permission.camera.request();
    } else {
      askPermission();
    }
    if (status.isGranted == true) {
      widget.authenticationBloc.add(UserLogin(
          phone: _phoneController.text, password: _passwordController.text));
    } else {
      askPermission();
    }
    //return null;
  }

  permissionHandle() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.audio,
      Permission.sms,
    ].request();
    if (status[Permission.location]!.isGranted) {
      if (status[Permission.camera]!.isGranted) {
        if (status[Permission.storage]!.isGranted) {
          if (status[Permission.accessMediaLocation]!.isGranted) {
            if (status[Permission.audio]!.isGranted) {
              if (status[Permission.sms]!.isGranted) {
                widget.authenticationBloc.add(UserLogin(
                    phone: _phoneController.text,
                    password: _passwordController.text));
              } else {
                try {
                  status = (await Permission.storage.request())
                      as Map<Permission, PermissionStatus>;
                } catch (err) {
                  status = PermissionStatus.granted
                      as Map<Permission, PermissionStatus>;
                }
                print("sms permission is isGranted");
              }
            } else {
              permissionHandle();
              try {
                status = (await Permission.storage.request())
                    as Map<Permission, PermissionStatus>;
              } catch (err) {
                status = PermissionStatus.denied
                    as Map<Permission, PermissionStatus>;
              }
              print("accessMediaLocation permission is isGranted");
            }
          } else {
            permissionHandle();

            status[Permission.accessMediaLocation]!.isGranted;
            print("accessMediaLocation permission is isGranted");
          }
        } else {
          permissionHandle();

          status[Permission.storage]!.isGranted;
          print("storage permission is isGranted");
        }
      } else {
        permissionHandle();

        status[Permission.camera]!.isGranted;
        print("Camera permission is isGranted");
      }
    } else {
      permissionHandle();

      status[Permission.location]!.isGranted;

      print("Location permission is isGranted");
    }
  }

//----------------------
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.sms,
    ].request();
    final List<Permission> permissions = statuses.keys.toList();
    final List<PermissionStatus> permissionStatuses = statuses.values.toList();

    for (int i = 0; i < permissions.length; i++) {
      if (permissionStatuses[i] == PermissionStatus.denied) {
        if (await permissions[i].isPermanentlyDenied) {
          openAppSettings();
        } else {
          Fluttertoast.showToast(
              msg: permissions[i].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Theme.of(context).colorScheme.error,
              textColor: Colors.white,
              fontSize: 16.0);
          widget.authenticationBloc.add(UserLogin(
              phone: _phoneController.text,
              password: _passwordController.text));
        }
      }
    }
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
              labelText: 'Phone',
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
            controller: _phoneController,
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
            key: const Key('passwordField'),
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              labelText: 'Password',
              hintText: 'Enter Password',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required.';
              }
              return null;
            },
          ),
          SizedBox(height: 15.toResponsiveHeight),
          TextButton(
            onPressed: () {
              context.push('/updatePassword');
            },
            child: const Text("FORGOT YOUR PASSWORD?"),
          ),
          ElevatedButton(
            key: const Key('loginButton'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (_key.currentState!.validate()) {
                //checkSMSPermission();
                //    askPermission();
                //requestPermissions();
                // permissionHandle();
                requestPermissions();
                widget.authenticationBloc.add(UserLogin(
                    phone: _phoneController.text,
                    password: _passwordController.text));
              }
            },
            child: widget.state is AuthenticationLoading
                ? CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.background,
                  )
                : Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 15.toResponsiveFont),
                  ),
          ),
          SizedBox(height: 10.toResponsiveHeight),
          Center(
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: ' Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push('/register');
                        //BUTTON ACTION
                      },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 180.toResponsiveHeight),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Powered By ',
                style: TextStyle(
                    //fontSize: 17,
                    ),
              ),
              CircleAvatar(
                  backgroundColor: Colors.white12,
                  radius: 20,
                  child: Image.asset(
                    AllImages().poweredby,
                    width: 50.toResponsiveWidth,
                    height: 50.toResponsiveHeight,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
