// To parse this JSON data, do
//
//     final customerNameData = customerNameDataFromJson(jsonString);

import 'dart:convert';

List<CustomerNameData> customerNameDataFromJson(String str) =>
    List<CustomerNameData>.from(
        json.decode(str).map((x) => CustomerNameData.fromJson(x)));

String customerNameDataToJson(List<CustomerNameData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerNameData {
  CustomerNameData({
    required this.id,
    required this.partyId,
    required this.billName,
    required this.billDate,
    required this.parent,
    required this.closingBalance,
    required this.vartaharName,
    required this.advtBranchName,
    required this.recoveryAgent,
    required this.billOrigDesc,
    required this.billOrigValue,
    required this.billValuePerc,
  });

  String id;
  String partyId;
  String billName;
  String billDate;
  String parent;
  String closingBalance;
  String vartaharName;
  String advtBranchName;
  String recoveryAgent;
  String billOrigDesc;
  String billOrigValue;
  String billValuePerc;

  factory CustomerNameData.fromJson(Map<String, dynamic> json) =>
      CustomerNameData(
        id: json["Id"] ?? '',
        partyId: json["PartyId"] ?? '',
        billName: json["BillName"] ?? '',
        billDate: json["BillDate"] ?? '',
        parent: json['Parent'] ?? '',
        closingBalance: json["ClosingBalance"] ?? '',
        vartaharName: json["VartaharName"] ?? '',
        //parentValues.map[json["VartaharName"]]!,
        advtBranchName: json["AdvtBranchName"] ?? '',
        //advtBranchNameValues.map[json["AdvtBranchName"]]!,
        recoveryAgent: json["RecoveryAgent"] ?? '',
        billOrigDesc: json["BillOrigDesc"] ?? '',
        billOrigValue: json["BillOrigValue"] ?? '',
        billValuePerc: json["BillValuePerc"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PartyId": partyId,
        "BillName": billName,
        "BillDate": billDate,
        "Parent": parentValues.reverse[parent],
        "ClosingBalance": closingBalance,
        "VartaharName": parentValues.reverse[vartaharName],
        "AdvtBranchName": advtBranchNameValues.reverse[advtBranchName],
        "RecoveryAgent": recoveryAgent,
        "BillOrigDesc": billOrigDesc,
        "BillOrigValue": billOrigValue,
        "BillValuePerc": billValuePerc,
      };
}

enum AdvtBranchName { EMPTY, DISPUT_MATTERS }

final advtBranchNameValues = EnumValues({
  "Disput Matters": AdvtBranchName.DISPUT_MATTERS,
  "": AdvtBranchName.EMPTY
});

enum Parent { DANDVATE_NARESH_VARTHAR_SAMBHAJI_NAGAR, EMPTY }

final parentValues = EnumValues({
  "Dandvate Naresh :Varthar - Sambhaji Nagar":
      Parent.DANDVATE_NARESH_VARTHAR_SAMBHAJI_NAGAR,
  "": Parent.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
