import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:integration_test/api_sdk/dio/models/department_model.dart';
import 'package:integration_test/api_sdk/dio/models/division_model.dart';
import 'package:integration_test/api_sdk/dio/models/railway_model.dart';
import 'package:integration_test/api_sdk/dio/models/zone_model.dart';
import 'package:integration_test/shared/bloc/department/department_bloc.dart';
import 'package:integration_test/shared/bloc/division/division_bloc.dart';
import 'package:integration_test/shared/bloc/zone/zone_bloc.dart';
import '../../../common_export.dart';
import '../../../shared/bloc/railway/railway_bloc.dart';

class SignUpForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationState state;
  const SignUpForm(
      {Key? key, required this.authenticationBloc, required this.state})
      : super(key: key);
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _railwayController = TextEditingController();
  final _zoneController = TextEditingController();
  final _divisionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  List<String> userType = ["Employee, Admin"];
  bool agree = false;
  int? railwayValue;
  int? zoneValue;
  int? divisionValue;
  int? departmentValue;
  int? userTypeValue;
  late final RailwayBloc railwayBloc;
  late final ZoneBloc zoneBloc;
  late final DivisionBloc divisionBloc;
  late final DepartmentBloc departmentBloc;
  RailwayModel? railwayModel;
  ZoneModel? zoneModel;
  DivisionModel? divisionModel;
  DepartmentModel? departmentModel;

  @override
  void initState() {
    super.initState();
    railwayBloc = BlocProvider.of<RailwayBloc>(context);
    zoneBloc = BlocProvider.of<ZoneBloc>(context);
    divisionBloc = BlocProvider.of<DivisionBloc>(context);
    departmentBloc = BlocProvider.of<DepartmentBloc>(context);
    railwayBloc.add(const GetRailwayData());
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

  void onRailwayTap(RailwayModel railwayModel) {
    List<SelectedListItem> dataList = railwayModel.data!
        .map((e) => SelectedListItem(value: e.rId.toString(), name: e.rname!))
        .toList();
    DropDownState(
      DropDown(
        isSearchVisible: true,
        data: dataList,
        selectedItems: (List<dynamic> selectedList) {
          List<int> listId = [];
          List<String> listName = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              listId.add(int.parse(item.value!));
              listName.add(item.name);
            }
          }
          _railwayController.text = listName.first;
          zoneBloc.add(GetZoneData(id: listId.first));
          _zoneController.clear();
          divisionBloc.add(const WaitForDivision());
          _divisionController.clear();
          departmentBloc.add(const WaitForDepartment());
          _departmentController.clear();
          railwayValue = listId.first;
          if (kDebugMode) {
            print(railwayValue);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void onZoneTap(ZoneModel zoneModel) {
    List<SelectedListItem> dataList = zoneModel.data!
        .map((e) => SelectedListItem(value: e.zid.toString(), name: e.zname))
        .toList();
    DropDownState(
      DropDown(
        isSearchVisible: true,
        data: dataList,
        selectedItems: (List<dynamic> selectedList) {
          List<int> listId = [];
          List<String> listName = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              listId.add(int.parse(item.value!));
              listName.add(item.name);
            }
          }
          _zoneController.text = listName.first;
          divisionBloc.add(GetDivisionData(id: listId.first));
          _divisionController.clear();
          departmentBloc.add(const WaitForDepartment());
          _departmentController.clear();
          zoneValue = listId.first;
          if (kDebugMode) {
            print(zoneValue);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void onDivisionTap(DivisionModel divisionModel) {
    List<SelectedListItem> dataList = divisionModel.data!
        .map((e) => SelectedListItem(value: e.dId.toString(), name: e.dname))
        .toList();
    DropDownState(
      DropDown(
        isSearchVisible: true,
        data: dataList,
        selectedItems: (List<dynamic> selectedList) {
          List<int> listId = [];
          List<String> listName = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              listId.add(int.parse(item.value!));
              listName.add(item.name);
            }
          }
          _divisionController.text = listName.first;
          departmentBloc.add(GetDepartmentData(id: listId.first));
          _departmentController.clear();
          divisionValue = listId.first;
          if (kDebugMode) {
            print(divisionValue);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void onDepartmentTap(DepartmentModel departmentModel) {
    List<SelectedListItem> dataList = departmentModel.data!
        .map((e) => SelectedListItem(value: e.id.toString(), name: e.name))
        .toList();
    DropDownState(
      DropDown(
        isSearchVisible: true,
        data: dataList,
        selectedItems: (List<dynamic> selectedList) {
          List<int> listId = [];
          List<String> listName = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              listId.add(int.parse(item.value!));
              listName.add(item.name);
            }
          }
          _departmentController.text = listName.first;
          //divisionBloc.add(GetDivisionData(id: listId.first));
          departmentValue = listId.first;
          if (kDebugMode) {
            print(departmentValue);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void onUserTypeTap() {
    List<SelectedListItem> dataList = [];
    dataList.add(SelectedListItem(name: "Admin", value: "1"));
    dataList.add(SelectedListItem(name: "Employee", value: "2"));
    DropDownState(
      DropDown(
        isSearchVisible: true,
        data: dataList,
        selectedItems: (List<dynamic> selectedList) {
          List<int> listId = [];
          List<String> listName = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              listId.add(int.parse(item.value!));
              listName.add(item.name);
            }
          }
          _userTypeController.text = listName.first;
          userTypeValue = listId.first;
          //divisionBloc.add(GetDivisionData(id: listId.first));
          if (kDebugMode) {
            print(userTypeValue);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            key: const Key('nameField'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Enter Name',
              isDense: true,
              prefixIcon: Icon(
                Icons.person,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter Name',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: _nameController,
            keyboardType: TextInputType.name,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'name',
          ),
          SizedBox(height: 15.toResponsiveHeight),
          FormBuilderTextField(
            key: const Key('emailField'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Email address',
              isDense: true,
              prefixIcon: Icon(
                Icons.email,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter Email',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              //FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
            name: 'email',
          ),
          SizedBox(height: 15.toResponsiveHeight),
          FormBuilderTextField(
            key: const Key('phonefiled'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Enter Phone No.',
              isDense: true,
              prefixIcon: Icon(
                Icons.phone,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter phone',
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
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.integer(),
              FormBuilderValidators.equalLength(10)
            ]),
            name: 'phoneNumber',
          ),
          SizedBox(
            height: 15.toResponsiveHeight,
          ),
          BlocListener<RailwayBloc, RailwayState>(
            listener: (context, state) {
              if (state is RailwayDataSelect) {
                railwayValue = state.rId;
              }
              if (state is RailwayData) {
                railwayModel = state.railwayModel;
              }
            },
            child: FormBuilderTextField(
              key: const Key('railwayField'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onRailwayTap(railwayModel!);
              },
              decoration: InputDecoration(
                labelText: 'Select Railway Type',
                isDense: true,
                prefixIcon: Icon(
                  Icons.train,
                  size: 28.toResponsiveFont,
                ),
                fillColor: Colors.white,
                hintText: 'Select Railway Type',
                hintStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(width: 3, color: Colors.black38),
                ),
                filled: false,
                contentPadding: const EdgeInsets.all(16),
              ),
              controller: _railwayController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              name: 'railwayType',
            ),
          ),
          SizedBox(
            height: 15.toResponsiveHeight,
          ),
          BlocListener<ZoneBloc, ZoneState>(
            listener: (context, state) {
              if (state is ZoneDataSelect) {
                zoneValue = state.zId;
              }
              if (state is ZonesData) {
                zoneModel = state.zoneModel;
              }
            },
            child: FormBuilderTextField(
              key: const Key('zoneField'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onZoneTap(zoneModel!);
              },
              decoration: InputDecoration(
                labelText: 'Select Zone',
                isDense: true,
                prefixIcon: Icon(
                  Icons.directions_railway,
                  size: 28.toResponsiveFont,
                ),
                fillColor: Colors.white,
                hintText: 'Select Zone',
                hintStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(width: 3, color: Colors.black38),
                ),
                filled: false,
                contentPadding: const EdgeInsets.all(16),
              ),
              controller: _zoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              name: 'zone',
            ),
          ),
          SizedBox(
            height: 15.toResponsiveHeight,
          ),
          BlocListener<DivisionBloc, DivisionState>(
            listener: (context, state) {
              if (state is DivisionDataSelect) {
                divisionValue = state.dId;
              }
              if (state is DivisionData) {
                divisionModel = state.divisionModel;
              }
            },
            child: FormBuilderTextField(
              key: const Key('divisionField'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onDivisionTap(divisionModel!);
              },
              decoration: InputDecoration(
                labelText: 'Select Division',
                isDense: true,
                prefixIcon: Icon(
                  Icons.location_city,
                  size: 28.toResponsiveFont,
                ),
                fillColor: Colors.white,
                hintText: 'Select Division',
                hintStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(width: 3, color: Colors.black38),
                ),
                filled: false,
                contentPadding: const EdgeInsets.all(16),
              ),
              controller: _divisionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              name: 'division',
            ),
          ),
          SizedBox(
            height: 15.toResponsiveHeight,
          ),
          BlocListener<DepartmentBloc, DepartmentState>(
            listener: (context, state) {
              if (state is DepartmentDataSelect) {
                departmentValue = state.dId;
              }
              if (state is DepartmentsData) {
                departmentModel = state.departmentModel;
              }
            },
            child: FormBuilderTextField(
              key: const Key('departmentField'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onDepartmentTap(departmentModel!);
              },
              decoration: InputDecoration(
                labelText: 'Select Department',
                isDense: true,
                prefixIcon: Icon(
                  Icons.location_pin,
                  size: 28.toResponsiveFont,
                ),
                fillColor: Colors.white,
                hintText: 'Select Department',
                hintStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(width: 3, color: Colors.black38),
                ),
                filled: false,
                contentPadding: const EdgeInsets.all(16),
              ),
              controller: _departmentController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              name: 'department',
            ),
          ),
          SizedBox(
            height: 15.toResponsiveHeight,
          ),
          FormBuilderTextField(
            key: const Key('userTypeField'),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              onUserTypeTap();
            },
            decoration: InputDecoration(
              labelText: 'User Type',
              isDense: true,
              prefixIcon: Icon(
                Icons.person_search,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'User Type',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            controller: _userTypeController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'userType',
          ),
          SizedBox(height: 15.toResponsiveHeight),
          FormBuilderTextField(
            key: const Key('passwordField'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Enter Password',
              isDense: true,
              prefixIcon: Icon(
                Icons.visibility,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter Password',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            obscureText: true,
            controller: _passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'password',
          ),
          SizedBox(height: 15.toResponsiveHeight),
          FormBuilderTextField(
            key: const Key('ConfirmpasswordField'),
            cursorColor: Theme.of(context).textTheme.displayLarge!.color,
            decoration: InputDecoration(
              labelText: 'Enter Confirm Password',
              isDense: true,
              prefixIcon: Icon(
                Icons.visibility,
                size: 28.toResponsiveFont,
              ),
              fillColor: Colors.white,
              hintText: 'Enter Confirm Password',
              hintStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 3, color: Colors.black38),
              ),
              filled: false,
              contentPadding: const EdgeInsets.all(16),
            ),
            obscureText: true,
            controller: _confirmpasswordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            name: 'confirmPassword',
          ),
          SizedBox(height: 15.toResponsiveHeight),
          FormBuilderCheckbox(
            name: 'accept_terms',
            initialValue: false,
            onChanged: (value) {
              if (kDebugMode) {
                print(value);
              }
            },
            title: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'I have read and agree to the ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: const TextStyle(color: Colors.blue),
                    // Flutter doesn't allow a button inside a button
                    // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086

                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Terms and Conditions'),
                                content: const Text(
                                    '1) The siren sound ringing in Mobile is depend on text message ring.If mobile did not have network, then there may be delay for siren sound.  \n2)Always alerted for breakdown duties never depend on mobile phone siren.\n3) If you are in no network zone then inform it to your concern supervisor. \n 4) Never switch off your mobile phone mobile phone, it may lead to no siren sound from mobile. \n5) Always give all necessary permission required to app. If you denied permission then it will malfunction app or no siren sound from mobile.\n 6)This app is developed for additional alerting system. Do not completely depend on this app.   \n7) In order to use the Rapid Response APP for BD&DM, you must first agree to the terms and Condition. You may not use the Rapid Response App for BD&DM if you do not accept the terms and conditions. \n8) By clicking to accept and/or using this Rapid Response app for BD&DM, you hereby agree to the terms of the terms and Conditions. \n9) During Server Downtime the Rapid Response App for BD&DM may malfunction or may not work. \n10) The Rapid Response App for BD&DM should update to latest version of App. \n11) App developer has rights to change or update terms and conditions.'),
                                actions: [
                                  TextButton(
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      //context.pop();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                  ),
                ],
              ),
            ),
            validator: FormBuilderValidators.equal(
              true,
              errorText: 'You must accept terms and conditions to continue',
            ),
          ),
          SizedBox(height: 10.toResponsiveHeight),
          ElevatedButton(
            key: const Key('signupButton'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (_key.currentState!.validate()) {
                widget.authenticationBloc.add(UserSignUp(
                  email: _emailController.text,
                  password: _passwordController.text,
                  activation: userTypeValue == 1 ? 0 : 0,
                  dept_id: departmentValue!,
                  name: _nameController.text,
                  phone: _phoneController.text,
                  user_type: userTypeValue!,
                ));
              } else {}
            },
            child: widget.state is AuthenticationLoading
                ? CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.background,
                  )
                : Text(
                    'Sign Up',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 15.toResponsiveFont),
                  ),
          )
        ],
      ),
    );
  }
}
