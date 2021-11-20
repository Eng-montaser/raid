import 'package:raid/model/OurServer.dart';

class SettingData {
  String address;
  String phone;
  String facebook;
  String whatsapp;
  String telegram;
  List<OurServerData> ourServerList;
  SettingData(
      {this.address,
      this.phone,
      this.facebook,
      this.whatsapp,
      this.telegram,
      this.ourServerList});
  SettingData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phone = json['phone'];
    facebook = json['facebook'];
    whatsapp = json['whatsapp'];
    telegram = json['telegram'];
  }
}
