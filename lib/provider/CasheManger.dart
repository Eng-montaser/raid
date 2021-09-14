import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:raid/model/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManger{
  saveData(CacheType cacheType,data)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(cacheType){
      case CacheType.userData:
        if(data.token!=null)await prefs.setString("token", data.token);
        if(data.name!=null)await prefs.setString("name", data.name);
        if(data.email!=null)await prefs.setString("email", data.email);
        if(data.phone!=null)await prefs.setString("phone", data.phone);
        if(data.role_id!=null)await prefs.setInt("role_id", data.role_id);
        break;
      case CacheType.otherData:
        // TODO: Handle this case.
        break;
    }
  }
  Future<dynamic>getData(cacheType)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data;
      switch(cacheType){
        case CacheType.userData:
        UserData userData=new UserData(
          token: prefs.getString("token"),
          name:prefs.getString("name"),
           email:prefs.getString("email"),
            phone:prefs.getString("phone"),
            role_id:prefs.getInt("role_id")
        );
        data=userData;
          break;
        case CacheType.otherData:
        // TODO: Handle this case.
          break;
      }
      return data;
  }
  removeData(CacheType cacheType)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(cacheType){
      case CacheType.userData:
        await prefs.remove("token");
        await prefs.remove("name");
        await prefs.remove("email");
        await prefs.remove("phone");
        await prefs.remove("role_id");
        break;
      case CacheType.otherData:
      // TODO: Handle this case.
        break;
    }
  }
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token=prefs.getString("token");
    return token!=null?token:null;
  }
}
enum CacheType{
  userData,
  otherData
}