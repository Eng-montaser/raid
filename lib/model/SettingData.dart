import 'package:raid/model/OurServer.dart';

class SettingData {
  String address;
  String phone;
  String facebook;
  String instgrame;
  List<OurServerData> ourServerList;
  SettingData({this.address, this.phone,this.facebook,this.instgrame,this.ourServerList});
  SettingData.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phone = json['phone'];
    facebook = json['facebook'];
    instgrame = json['instgrame'];
  }
}