import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/common_export.dart';

class ProfilePage extends StatefulWidget {
  final String text;
  const ProfilePage({super.key, required this.text});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthenticationBloc authenticationBloc;
  final SharedPrefs prefs = SharedPrefs.instance;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
        titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              key: const Key('logoutButton'),
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                authenticationBloc.add(const UserLogOut());
              }),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 24.toResponsiveHeight,
          ),
          CircleAvatar(
            radius: 40.toResponsiveWidth,
            child: const Icon(Icons.person),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Name : '),
                Text(prefs.getName()!),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Mobile : '),
                Text(prefs.getPhone()!),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Email : '),
                Text(prefs.getEmail()!),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('UserType : '),
                Text(prefs.getUsertype()! == "1" ? 'Admin' : 'Employee'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//----

