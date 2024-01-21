import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:integration_test/common_export.dart';
import 'package:integration_test/screens/admin_home_page/model/group_member_model.dart';
import 'package:integration_test/screens/admin_home_page/model/group_model.dart';
import 'package:integration_test/shared/bloc/get_employee/employee_bloc.dart';
import 'package:integration_test/shared/bloc/group/group_bloc.dart';

class GroupUpdatePage extends StatefulWidget {
  //final List<GroupMemberModel> memberList;
  //final GroupModel groupModel;
  final String groupId;

  const GroupUpdatePage({
    Key? key,
    //required this.memberList,
    //required this.groupModel,
    required this.groupId,
  }) : super(key: key);

  @override
  _GroupUpdatePageState createState() => _GroupUpdatePageState();
}

class _GroupUpdatePageState extends State<GroupUpdatePage> {
  final _key = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  late final GroupBloc groupBloc;
  late final EmployeeBloc employeeBloc;
  bool isEdited = false;
  final SharedPrefs prefs = SharedPrefs.instance;
  GroupModel? groupModel;
  List<GroupMemberModel> groupMembers = [];

  @override
  void initState() {
    groupBloc = BlocProvider.of<GroupBloc>(context);
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    //_groupNameController.text = widget.groupModel.groupName;
    employeeBloc.add(GetEmployeeData(id: int.parse(prefs.getUserdeptid()!)));
    groupBloc.add(GetGroup(groupId: widget.groupId));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        iconTheme: Theme.of(context)
            .appBarTheme
            .iconTheme!
            .copyWith(color: Colors.black),
        actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
        titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          "Edit Group",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        bloc: groupBloc,
        builder: (context, state) {
          if (state is GroupData) {
            if (state.groupData.exists) {
              groupModel = GroupModel.fromJson(state.groupData.data()!);
            }
            _groupNameController.text = groupModel!.groupName;
          }
          return Form(
            key: _key,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const Key('GroupNameField'),
                    cursorColor:
                        Theme.of(context).textTheme.displayLarge!.color,
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      isDense: true,
                      prefixIcon: Icon(
                        Icons.group,
                        size: 28.toResponsiveFont,
                      ),
                      fillColor: Colors.white,
                      hintText: 'Enter Group Name',
                      hintStyle: const TextStyle(fontSize: 16),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(width: 3, color: Colors.black38),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    controller: _groupNameController,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Group Name is required.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        isEdited = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.toResponsiveHeight,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.toResponsiveWidth),
                    child: Text(
                      'Members',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: BlocListener<EmployeeBloc, EmployeeState>(
                      bloc: employeeBloc,
                      listener: (context, state) {
                        if (state is EmployeeData) {
                          //groupMembers.clear();

                          for (var element in state.employeeModel.data!) {
                            for (var member in groupModel!.members) {
                              //groupMembers.add(member);
                              if (element.id == member.id) {
                                setState(() {
                                  element.isChecked = true;
                                });
                              } else {
                                setState(() {
                                  element.isChecked = false;
                                });
                              }
                            }
                          }
                        }
                      },
                      child: BlocBuilder<EmployeeBloc, EmployeeState>(
                        bloc: employeeBloc,
                        builder: (context, state) {
                          if (state is EmployeeData) {
                            return ListView.builder(
                                itemCount: state.employeeModel.data!.length,
                                padding: const EdgeInsets.only(top: 01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  //for (var element in state.employeeModel.data!) {

                                  return ListTile(
                                    title: Text(
                                        state.employeeModel.data![index].name),
                                    leading: Checkbox(
                                        activeColor: const Color(0xFF000000),
                                        value: state.employeeModel.data![index]
                                            .isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isEdited = true;
                                          });
                                          //phoneNum.clear();
                                          groupMembers.clear();
                                          print("Check $value");
                                          setState(() {
                                            state.employeeModel.data![index]
                                                .isChecked = value!;
                                            if (value) {
                                              groupMembers.add(
                                                  GroupMemberModel.fromJson(
                                                      state.employeeModel
                                                          .data![index]
                                                          .toJson()));
                                            } else {
                                              groupMembers.remove(
                                                  GroupMemberModel.fromJson(
                                                      state.employeeModel
                                                          .data![index]
                                                          .toJson()));
                                            }
                                          });
                                          print(
                                              "lenght ${groupMembers.length}");
                                        }),
                                  );
                                });
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('updateGroupButton'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: isEdited
                        ? () {
                            if (_key.currentState!.validate()) {
                              groupBloc.add(UpdateGroup(
                                  groupId: widget.groupId,
                                  groupName: _groupNameController.text,
                                  memebers: groupMembers));

                              Fluttertoast.showToast(
                                  msg: "Group Updated",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              setState(() {
                                isEdited = false;
                              });

                              //Navigator.of(context).pop();
                            }
                          }
                        : null,
                    child: state is GroupLoading
                        ? CircularProgressIndicator(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                          )
                        : Text(
                            'Update Group',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 15.toResponsiveFont),
                          ),
                  ),
                  SizedBox(height: 10.toResponsiveHeight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
