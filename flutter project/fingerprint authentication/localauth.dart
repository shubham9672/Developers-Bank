import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi{
  static final _auth=  LocalAuthentication();

  static Future<bool>hasBiometrics()async{ //return bool true if your device supports biometrics
    try{
    return _auth.canCheckBiometrics;}
        on PlatformException catch(e){
          print(e);
      return false;
        }
  }
  static Future<List<BiometricType>>getBiometrics()async{ //show list of biometrics availbale on your device
   return  await _auth.getAvailableBiometrics();}
    on PlatformException catch(e){
      return <BiometricType>[];
      }
  }
  static Future <bool>authenticate()async{
    final isAvailable=await hasBiometrics();
    if(!isAvailable)
    {return false;}
    try{
    return await _auth.authenticate(localizedReason: 'Scan to authenticate',
      options: AuthenticationOptions(
      useErrorDialogs: true,
      stickyAuth: true),
    );

  } on PlatformException catch(e){
      print(e);
      return false;
    }
    }
}
