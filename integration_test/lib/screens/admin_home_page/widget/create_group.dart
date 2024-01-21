import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/common_export.dart';
import 'package:integration_test/shared/bloc/group/group_bloc.dart';

import '../model/group_member_model.dart';

class GroupForm extends StatefulWidget {
  final List<GroupMemberModel> memberList;
  final String phoneNumber;

  const GroupForm(
      {Key? key, required this.memberList, required this.phoneNumber})
      : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _key = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  late final GroupBloc groupBloc;

  @override
  void initState() {
    groupBloc = BlocProvider.of<GroupBloc>(context);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      bloc: groupBloc,
      listener: (context, state) {
        if (state is GroupData) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        bloc: groupBloc,
        builder: (context, state) {
          return Material(
            elevation: 5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Form(
              key: _key,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Create Group",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.toResponsiveHeight,
                    ),
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
                          borderSide:
                              BorderSide(width: 3, color: Colors.black38),
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
                    ),
                    SizedBox(
                      height: 10.toResponsiveHeight,
                    ),
                    ElevatedButton(
                      key: const Key('createGroupButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          groupBloc.add(CreateGroup(
                              phone: widget.phoneNumber,
                              groupName: _groupNameController.text,
                              memebers: widget.memberList));
                          Navigator.of(context).pop();
                        }
                      },
                      child: state is GroupLoading
                          ? CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                            )
                          : Text(
                              'Create Group',
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
            ),
          );
        },
      ),
    );
  }
}
