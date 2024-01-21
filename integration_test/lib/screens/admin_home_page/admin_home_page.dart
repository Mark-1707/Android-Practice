// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:integration_test/common_export.dart';
import 'package:integration_test/screens/group_update/goup_update.dart';
import 'package:integration_test/shared/bloc/group/group_bloc.dart';
import 'package:integration_test/screens/admin_home_page/model/group_model.dart';
import 'package:telephony/telephony.dart';
import '../../api_sdk/dio/models/employee_model.dart';
import '../../main.dart';
import '../../shared/bloc/get_employee/employee_bloc.dart';
import '../../shared/bloc/show_address/address_bloc.dart';
import '../../shared/bloc/user_details/user_details_bloc.dart';
import 'model/group_member_model.dart';
import 'widget/create_group.dart';

class AdminPage extends StatefulWidget {
  final String text;
  const AdminPage({super.key, required this.text});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool checkbox = false;
  bool value = false;

  late final EmployeeBloc employeeBloc;
  late final AuthenticationBloc authenticationBloc;
  late final AddressBloc addressBloc;
  late final GroupBloc groupBloc;
  late final UserDetailsBloc userDetailsBloc;
  final SharedPrefs prefs = SharedPrefs.instance;
  EmployeeModel? employeeModel;
  bool isLoading = true;
  //bool isGroupLoading = true;
  List<GroupModel> _groupList = [];
  List<String> phoneNum = [];
  List<GroupMemberModel> groupMembers = [];
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  int groupCreatedCount = 0;

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  bool? isCheckedIn;

  @override
  void initState() {
    super.initState();
    getGroupCounts();
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    addressBloc = BlocProvider.of<AddressBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    groupBloc = BlocProvider.of<GroupBloc>(context);
    userDetailsBloc = BlocProvider.of<UserDetailsBloc>(context);

    employeeBloc.add(GetEmployeeData(id: int.parse(prefs.getUserdeptid()!)));

    userDetailsBloc.add(GetUserDetails(
        phone: prefs.getPhone()!, password: prefs.getPassword()!));
    groupBloc.add(GetGroupList(phone: prefs.getPhone()!));

    setState(() {
      isCheckedIn = prefs.getCheckIn() ?? false;
    });

    getLocation();
  }

  String first = "";
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    permission = await Geolocator.requestPermission();
    List<Placemark> addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      first =
          '${addresses.first.locality},${addresses.first.subLocality}, ${addresses.first.postalCode}';
    });
    // print("${first.name} : ${first..administrativeArea}");
    if (kDebugMode) {
      print(position.longitude);
      print(position.latitude);
    }

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (kDebugMode) {
        print(position.longitude);
        print(position.latitude);
      }

      long = position.longitude.toString();
      lat = position.latitude.toString();
      setState(() {
        //refresh UI on update
      });
    });
  }

  getGroupCounts() {
    firestore
        .collection('groups')
        .doc(prefs.getPhone())
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:

        if (mounted) {
          setState(() {
            groupCreatedCount = data['groupCreatedCount'] ?? 0;
          });
        }

        print("groupCreatedCount: $groupCreatedCount");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      bloc: employeeBloc,
      listener: (context, state) async {
        if (state is EmployeeLoadingState) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is EmployeeData) {
          setState(() {
            employeeModel = state.employeeModel;
            isLoading = false;
          });
        }
      },
      child: BlocListener<GroupBloc, GroupState>(
          bloc: groupBloc,
          listener: (context, state) {
            if (state is GroupListData) {
              state.groupList.listen((event) {
                //event.docs.length;
                setState(() {
                  groupCreatedCount = event.docs.length;
                });
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
              titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
              centerTitle: true,
              title: Column(children: [
                Row(children: [
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Image.asset(
                        AllImages().logo,
                        width: 25.toResponsiveWidth,
                        height: 25.toResponsiveHeight,
                      )),
                  SizedBox(
                    width: 5.toResponsiveWidth,
                  ),
                  //const Spacer(),
                  Text(
                    AppLocalizations.of(context)?.appName ??
                        'Rapid Response App for BD&DM',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ]),
              ]),
              actions: [
                TextButton(
                    onPressed: () async {
                      phoneNum.clear();
                      groupMembers.clear();
                      await Future.delayed(const Duration(seconds: 1));
                      for (var element in employeeModel!.data!) {
                        if (element.activation == 1) {
                          setState(() {
                            element.isChecked = true;
                          });
                        } else {
                          setState(() {
                            element.isChecked = false;
                          });
                        }
                        if (element.isChecked!) {
                          phoneNum.add(element.phone);
                          groupMembers
                              .add(GroupMemberModel.fromJson(element.toJson()));
                        } else {
                          phoneNum.remove(element.phone);
                          groupMembers.remove(
                              GroupMemberModel.fromJson(element.toJson()));
                        }
                      }
                      log("phoneNum:$phoneNum");
                      log("groupMembers:${groupMembers.length}");
                    },
                    child: const Text('Check all')),
                //IconButton(onPressed: () {}, icon: Icon(Icons.check_box)),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: phoneNum.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'showModel',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 3,
                        onPressed: () {
                          showModelSheet();
                        },
                        child: const Icon(Icons.message_rounded),
                      ),
                      SizedBox(
                        width: groupCreatedCount < prefs.getGroupCount()!
                            ? 10.toResponsiveWidth
                            : 0,
                      ),
                      groupCreatedCount < prefs.getGroupCount()!
                          ? FloatingActionButton(
                              heroTag: 'groupCreate',
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              elevation: 3,
                              onPressed: () {
                                //showModelSheet();
                                print("groupMembers : ${groupMembers.length}");
                                showDialog(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(
                                            20.toResponsiveHeight),
                                        child: GroupForm(
                                          memberList: groupMembers,
                                          phoneNumber: prefs.getPhone()!,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.group_add),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : const SizedBox.shrink(),
            body: Column(
              children: [
                //SizedBox(height: 18.toResponsiveHeight),
                /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: WidgetCircularAnimator(
                              size: 50,
                              child: GestureDetector(
                                  child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor:
                                        isCheckedIn! ? Colors.red : Colors.green),
                                onPressed: !isCheckedIn!
                                    ? () {
                                        prefs.setChechIn(true);
                                        setState(() {
                                          isCheckedIn = prefs.getCheckIn();
                                        });
                                      }
                                    : () {
                                        prefs.setChechIn(false);
                                        setState(() {
                                          isCheckedIn = prefs.getCheckIn();
                                        });
                                      },
                                child: const Icon(Icons.check),
                              )),
                            ),
                          ),
                          SizedBox(height: 10.toResponsiveWidth),
                          isCheckedIn!
                                    ? const Text("Check Out")
                                    : const Text("Check In"),
                        ],
                      ),*/
                BlocBuilder<GroupBloc, GroupState>(
                  bloc: groupBloc,
                  builder: (context, state) {
                    if (state is GroupListData) {
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: state.groupList,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              //if data is loading
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                              // return const Center(
                              //     child: CircularProgressIndicator());

                              //if some or all data is loaded then show it
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _groupList = data
                                        ?.map((e) =>
                                            GroupModel.fromJson(e.data()))
                                        .toList() ??
                                    [];

                                //setState(() {
                                groupCreatedCount = _groupList.length;
                                //});

                                if (_groupList.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 20.toResponsiveWidth,
                                            top: 5.toResponsiveHeight),
                                        child: Text(
                                          'Groups',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.toResponsiveWidth,
                                            top: 5.toResponsiveHeight),
                                        height: 80.toResponsiveHeight,
                                        child: ListView.builder(
                                            itemCount: _groupList.length,
                                            padding: EdgeInsets.only(
                                                top: 01.toResponsiveHeight),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: index ==
                                                        _groupList.length - 1
                                                    ? EdgeInsets.fromLTRB(
                                                        8.toResponsiveWidth,
                                                        0,
                                                        8.toResponsiveWidth,
                                                        0)
                                                    : EdgeInsets.only(
                                                        left: 8
                                                            .toResponsiveWidth),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: SizedBox(
                                                            child:
                                                                FloatingActionButton
                                                                    .small(
                                                          backgroundColor:
                                                              Colors.red,
                                                          child: Text(_groupList
                                                              .elementAt(index)
                                                              .groupName[0]),
                                                          onPressed: () {
                                                            //print("Cliked");

                                                            List<GroupMemberModel>
                                                                membersList =
                                                                _groupList
                                                                    .elementAt(
                                                                        index)
                                                                    .members;

                                                            List<String>
                                                                phoneNumbers =
                                                                [];

                                                            for (GroupMemberModel e
                                                                in membersList) {
                                                              phoneNumbers
                                                                  .add(e.phone);
                                                            }

                                                            String documentId =
                                                                _groupList
                                                                    .elementAt(
                                                                        index)
                                                                    .groupId;
                                                            print(
                                                                "phoneNumbers ${phoneNumbers.length}");
                                                            showGroupModelSheet(
                                                                phoneNumbers:
                                                                    phoneNumbers,
                                                                membersList:
                                                                    membersList,
                                                                employeeModel:
                                                                    employeeModel!,
                                                                documentId:
                                                                    documentId,
                                                                groupModel: _groupList
                                                                    .elementAt(
                                                                        index));
                                                          },
                                                        ))),
                                                    Text(
                                                      _groupList
                                                          .elementAt(index)
                                                          .groupName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 20.toResponsiveWidth),
                                        child: Text(
                                          'Members',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                            }
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                Expanded(
                  flex: 10,
                  child: BlocBuilder<EmployeeBloc, EmployeeState>(
                    bloc: employeeBloc,
                    builder: (context, state) {
                      if (state is EmployeeData) {
                        return !isLoading
                            ? ListView.builder(
                                itemCount: employeeModel!.data!.length,
                                padding: const EdgeInsets.only(top: 01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ExpansionTile(
                                        title: GestureDetector(
                                          child: Text(
                                              employeeModel!.data![index].name),
                                          onTap: () {
                                            context.push('/employeeDetails',
                                                extra: employeeModel!
                                                    .data![index]);
                                          },
                                        ),
                                        leading: Checkbox(
                                            activeColor:
                                                const Color(0xFF000000),
                                            value: employeeModel!
                                                .data![index].isChecked,
                                            onChanged: (bool? value) {
                                              phoneNum.clear();
                                              groupMembers.clear();
                                              if (employeeModel!.data!
                                                      .elementAt(index)
                                                      .activation ==
                                                  1) {
                                                setState(() {
                                                  employeeModel!.data![index]
                                                      .isChecked = value!;
                                                  if (value) {
                                                    phoneNum.add(employeeModel!
                                                        .data![index].phone);
                                                    groupMembers.add(
                                                        GroupMemberModel
                                                            .fromJson(
                                                                employeeModel!
                                                                    .data![
                                                                        index]
                                                                    .toJson()));
                                                  } else {
                                                    phoneNum.remove(
                                                        employeeModel!
                                                            .data![index]
                                                            .phone);
                                                    groupMembers.remove(
                                                        GroupMemberModel
                                                            .fromJson(
                                                                employeeModel!
                                                                    .data![
                                                                        index]
                                                                    .toJson()));
                                                  }
                                                });
                                              }
                                            }),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                backgroundColor: employeeModel!
                                                            .data!
                                                            .elementAt(index)
                                                            .activation ==
                                                        1
                                                    ? Colors.green
                                                    : const Color.fromARGB(
                                                        255, 235, 134, 129),
                                              ),
                                              child: employeeModel!.data!
                                                          .elementAt(index)
                                                          .activation ==
                                                      1
                                                  ? const Text("Activate")
                                                  : const Text("Deactivate"),
                                              onPressed: () {
                                                setState(() {
                                                  if (employeeModel!
                                                          .data![index]
                                                          .activation ==
                                                      1) {
                                                    //state.employeeModel.data![index].isActivated = false;
                                                    employeeBloc.add(
                                                        UpdateEmplyeeActivation(
                                                            eId: employeeModel!
                                                                .data![index]
                                                                .id,
                                                            dId: employeeModel!
                                                                .data![index]
                                                                .deptId,
                                                            activation: 0));
                                                    employeeModel!.data![index]
                                                        .isChecked = false;
                                                    phoneNum.remove(
                                                        employeeModel!
                                                            .data![index]
                                                            .phone);
                                                  } else {
                                                    employeeBloc.add(
                                                        UpdateEmplyeeActivation(
                                                            eId: employeeModel!
                                                                .data![index]
                                                                .id,
                                                            dId: employeeModel!
                                                                .data![index]
                                                                .deptId,
                                                            activation: 1));
                                                  }
                                                });
                                                if (kDebugMode) {
                                                  print(phoneNum);
                                                  print(groupMembers.length);
                                                }
                                              },
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Widget okButton = TextButton(
                                                    child: const Text("Delete"),
                                                    onPressed: () async {
                                                      employeeBloc.add(
                                                          EmplyeeDeletionEvent(
                                                        eId: employeeModel!
                                                            .data![index].id,
                                                        dId: employeeModel!
                                                            .data![index]
                                                            .deptId,
                                                      ));
                                                    },
                                                  );
                                                  Widget cancelButton =
                                                      TextButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      //context.pop();
                                                    },
                                                  );
                                                  // set up the AlertDialog
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: const Text(
                                                        "Delete User"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this User?"),
                                                    actions: [
                                                      okButton,
                                                      cancelButton
                                                    ],
                                                  );

                                                  // show the dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return alert;
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 25,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  showModelSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height:
              250.toResponsiveHeight + MediaQuery.of(context).viewInsets.bottom,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Train BreakDown Messaging',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          splashRadius: 40,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.toResponsiveHeight),
                myModelButton(
                    buttonText: 'Siren Testing',
                    onPressed: () async {
                      await siernTesting(context, phoneNum);
                    }),
                SizedBox(height: 5.toResponsiveHeight),
                myModelButton(
                    buttonText: 'IRALRT',
                    onPressed: () async {
                      await breakdownmessaging(context, phoneNum);
                    }),
                SizedBox(height: 5.toResponsiveHeight),
                myModelButton(
                    buttonText: 'IRVASP',
                    onPressed: () async {
                      await showInformationDialog(context, phoneNum);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myModelButton(
      {required void Function() onPressed,
      required String buttonText,
      Color? color}) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            minimumSize: const Size(100, 40),
            padding: const EdgeInsets.all(0),
            backgroundColor: color ?? Theme.of(context).colorScheme.primary),
        child: Text(
          buttonText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  showGroupModelSheet(
      {required List<String> phoneNumbers,
      required String documentId,
      required EmployeeModel employeeModel,
      required List<GroupMemberModel> membersList,
      required GroupModel groupModel}) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height:
              270.toResponsiveHeight + MediaQuery.of(context).viewInsets.bottom,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Train BreakDown Group Messaging',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        splashRadius: 40,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.toResponsiveHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      myModelButton(
                          buttonText: 'Siren Testing',
                          onPressed: () async {
                            await siernTesting(context, phoneNumbers);
                          }),
                      SizedBox(height: 5.toResponsiveHeight),
                      myModelButton(
                          buttonText: 'IRALRT',
                          onPressed: () async {
                            await breakdownmessaging(context, phoneNumbers);
                          }),
                      SizedBox(height: 5.toResponsiveHeight),
                      myModelButton(
                          buttonText: 'IRVASP',
                          onPressed: () async {
                            await showInformationDialog(context, phoneNumbers);
                          }),
                      SizedBox(height: 5.toResponsiveHeight),
                      myModelButton(
                          buttonText: 'Edit',
                          onPressed: () async {
                            print("Edit group");
                            print(documentId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupUpdatePage(
                                  groupId: documentId,
                                ),
                              ),
                            );
                          }),
                      SizedBox(height: 5.toResponsiveHeight),
                      myModelButton(
                          buttonText: 'Delete',
                          color: Colors.redAccent,
                          onPressed: () async {
                            print("Delete group");
                            print(documentId);
                            Widget okButton = TextButton(
                              child: const Text("Delete"),
                              onPressed: () async {
                                groupBloc.add(DeleteGroup(groupId: documentId));
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            );
                            Widget cancelButton = TextButton(
                              child: const Text("Cancel"),
                              onPressed: () async {
                                Navigator.pop(context);
                                //context.pop();
                              },
                            );
                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: const Text("Delete Group"),
                              content: const Text(
                                  "Are you sure you want to delete this Group?"),
                              actions: [okButton, cancelButton],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }),
                      SizedBox(height: 10.toResponsiveHeight),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> showInformationDialog(
    BuildContext context, List<String> phoneNumbers) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController var1controller = TextEditingController();
  final TextEditingController var2controller = TextEditingController();
  final TextEditingController var3contorller = TextEditingController();
  final TextEditingController var4controller = TextEditingController();
  final TextEditingController var5controller = TextEditingController();
  final TextEditingController var6controller = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 110),
                      child: const Text(
                        "Breakdown Train",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var1controller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var2controller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const Text(
                      "had been Ordered towards",
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var3contorller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          child: Text("at"),
                        ),
                        Flexible(
                          child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var4controller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const Text(
                      " O'Clock for",
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var5controller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Flexible(
                          child: SizedBox(
                              height: 40,
                              width: 150,
                              child: TextField(
                                controller: var6controller,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.black), //<-- SEE HERE
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const Text(
                      " By Team VASP Group",
                      style: TextStyle(fontSize: 14),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          const WidgetSpan(
                              child: Text(
                            "Note:",
                            style: TextStyle(color: Colors.red),
                          )),
                          WidgetSpan(
                              child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(minWidth: 100),
                                  child: const IntrinsicWidth(
                                    child: Text(
                                        "In sample values. allowed characters are alphbets numbers, '_','/' and ',' ",
                                        style: TextStyle(fontSize: 10)),
                                  ))),
                        ],
                      ),
                    ),
                  ],
                )),
            title: const Column(
              children: [
                Text(
                  'IRVASP',
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(
                      'http://websms.textidea.com/app/smsapi/index.php');
                  final json = {
                    'key': '4626BC02A8CFD8',
                    'type': 'text',
                    'contacts': phoneNumbers.toString(),
                    'senderid': 'IRVASP',
                    'msg':
                        "Breakdown Train ${var1controller.text}${var2controller.text} had been Ordered towards ${var3contorller.text} at ${var4controller.text} O'Clock for ${var5controller.text}${var6controller.text} By Team VASP Group",
                    'routeid': '18',
                  };
                  final response = await http.post(url, body: json);
                  if (response.statusCode == 200) {
                    Fluttertoast.showToast(
                        msg: "Text Sent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Text Send Error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('SEND'),
              ),
            ],
          );
        });
      });
}

// BreakDown Messaging
Future<void> breakdownmessaging(
    BuildContext context, List<String> phoneNumber) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController breakdowncontroller = TextEditingController();
  final TextEditingController orderbyvaspcontroller = TextEditingController();
  print(phoneNumber.toString());

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 100),
                      child: const Text(
                        "Breakdown Train",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: SizedBox(
                            height: 40,
                            width: 10,
                            child: TextField(
                              controller: breakdowncontroller,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black), //<-- SEE HERE
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: SizedBox(
                            height: 40,
                            width: 150,
                            child: TextField(
                              controller: orderbyvaspcontroller,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.black), //<-- SEE HERE
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 50),
                      child: const Text(
                        "Ordered was cancelled.\n By Team VASP Group",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          const WidgetSpan(
                              child: Text(
                            "Note:",
                            style: TextStyle(color: Colors.red),
                          )),
                          WidgetSpan(
                              child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(minWidth: 100),
                                  child: const IntrinsicWidth(
                                    child: Text(
                                        "In sample values. allowed characters are alphbets numbers, '_','/' and ',' ",
                                        style: TextStyle(fontSize: 10)),
                                  ))),
                        ],
                      ),
                    ),
                  ],
                )),
            title: const Column(
              children: [
                Text(
                  'IRALRT',
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Text(
                  "!!! Cancellation Message !!!",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () async {
                  final url = Uri.parse(
                      'http://websms.textidea.com/app/smsapi/index.php');
                  final json = {
                    'key': '4626BC02A8CFD8',
                    'type': 'text',
                    'contacts': phoneNumber.toString(),
                    'senderid': 'IRALRT',
                    'msg':
                        '!!! Cancellation Message !!! Breakdown Train ${breakdowncontroller.text} ${orderbyvaspcontroller.text} Ordered was cancelled.By Team VASP Group',
                    'routeid': '18'
                  };
                  final response = await http.post(url, body: json);
                  if (response.statusCode == 200) {
                    Fluttertoast.showToast(
                        msg: "Text Sent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Text Send Error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('SEND'),
              ),
            ],
          );
        });
      });
}

// Sciern testing Dilog Box in flutter
Future<void> siernTesting(BuildContext context, List<String> phoneNumber) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController startlocationcontroller = TextEditingController();
  final TextEditingController endloactioncontroller = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Whenever Breakdown Train",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: startlocationcontroller,
                            //"Whenever Breakdown Train ${.text}",
                            // label: 'eg: ART',
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: TextFormField(
                            controller: endloactioncontroller,
                            // text: 'eg: pune',
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Ordered such Siren sound will ring in your mobile.\n By Team VASP Group",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )),
            title: const Column(
              children: <Widget>[
                Text(
                  'IRVASP',
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Text(
                  "!!! Breakdown Siren !!!",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () {
                  // Get.back();
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () async {
                  for (var element in phoneNumber) {
                    print(element);
                    telephony.sendSms(
                      to: element.toString(),
                      message:
                          ' !! Siren Testing !!! Whenever Breakdown Train ${startlocationcontroller.text} ${endloactioncontroller.text} Ordered such Siren sound will ring in your mobile.By Team VASP Group',
                      statusListener: (SendStatus status) {
                        Fluttertoast.showToast(
                            msg: "Text Sent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                    );
                  }
                  // final url = Uri.parse(
                  //     'http://websms.textidea.com/app/smsapi/index.php');
                  // final json = {
                  //   'key': '4626BC02A8CFD8',
                  //   'type': 'text',
                  //   'contacts': phoneNum.toString(),
                  //   'senderid': 'IRVASP',
                  //   'msg':
                  //       ' !! Siren Testing !!! Whenever Breakdown Train ${startlocationcontroller.text} ${endloactioncontroller.text} Ordered such Siren sound will ring in your mobile.By Team VASP Group',
                  //   'routeid': '18',
                  // };
                  // final response = await post(url, body: json);
                  // if (response.statusCode == 200) {
                  //   await Fluttertoast.showToast(
                  //       msg: response.body,
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.TOP,
                  //       timeInSecForIosWeb: 5,
                  //       backgroundColor: Colors.green,
                  //       textColor: Colors.white,
                  //       fontSize: 16.0);
                  // } else {
                  //   Fluttertoast.showToast(
                  //       msg: response.reasonPhrase!,
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.TOP,
                  //       timeInSecForIosWeb: 3,
                  //       backgroundColor: Theme.of(context).colorScheme.error,
                  //       textColor: Colors.white,
                  //       fontSize: 16.0);
                  // }
                  Navigator.pop(context);
                },
                child: const Text('SEND'),
              ),
            ],
          );
        });
      });
}
