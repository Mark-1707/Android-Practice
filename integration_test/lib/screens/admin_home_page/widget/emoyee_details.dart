import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/utils/size_utils.dart';
import '../../../api_sdk/dio/models/employee_model.dart';
import '../../../shared/bloc/show_address/address_bloc.dart';

class EmployeeInfoPage extends StatefulWidget {
  final Datum data;
  const EmployeeInfoPage({super.key, required this.data});

  @override
  State<EmployeeInfoPage> createState() => _EmployeeInfoPageState();
}

class _EmployeeInfoPageState extends State<EmployeeInfoPage> {
  late final AddressBloc addressBloc;
  //List<Placemark>? placemarks;

  @override
  void initState() {
    super.initState();
    addressBloc = BlocProvider.of<AddressBloc>(context);
    //addressBloc.add(GetAddressData(id: int.parse(widget.data)));
  }
  // final coordinates = new Coordinates(lat_data, lon_data);
  //                 var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //                 var first = address.first;

  getAddress(latitude, longitude) async {
    //placemarks = await placemarkFromCoordinates(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Details", style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      /*body: BlocBuilder<AddressBloc, AddressState>(
          bloc: addressBloc,
          buildWhen: (prevState, curState) {
            return curState is AdrressData;
          },
          builder: (context, state) {
            if (state is AdrressData) {
              if (state.addressModel.data!.isNotEmpty) {
                addressBloc.add(GetAddress(
                    latitude: double.tryParse(
                        state.addressModel.data!.elementAt(0).latitude)!,
                    longitude: double.tryParse(
                        state.addressModel.data!.elementAt(0).longitude)!));
              }

              return state.addressModel.data!.isNotEmpty
                  ? Card(
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.deepPurpleAccent, //<-- SEE HERE
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  DateUtils.isSameDay(
                                          state.addressModel.data![0].time,
                                          DateTime.now())
                                      ? 'Attended'
                                      : 'Not Attended',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: DateUtils.isSameDay(
                                            state.addressModel.data![0].time,
                                            DateTime.now())
                                        ? Colors.greenAccent
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24.toResponsiveHeight,
                            ),
                            Row(
                              children: [
                                Text(
                                  "DateTime: ",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  state.addressModel.data![0].time.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24.toResponsiveHeight,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    child:
                                        BlocBuilder<AddressBloc, AddressState>(
                                      bloc: addressBloc,
                                      buildWhen: (prevState, curState) {
                                        return curState is GetAdrress;
                                      },
                                      builder: (context, state) {
                                        if (state is GetAdrress) {
                                          return Text(
                                            //'${state.placemark.locality},${state.placemark..subLocality}, ${state.placemark..postalCode}',
                                            state.placemark.name!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text("Not Attended"),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),*/
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
                Text(widget.data.name),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Mobile : '),
                Text(widget.data.phone),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Email : '),
                Text(widget.data.email),
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('UserType : '),
                Text(widget.data.userType == 1 ? 'Admin' : 'Employee'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
