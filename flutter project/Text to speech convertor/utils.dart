import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Command{ //Commands which perform if text contain these commands words
  static final all=[email,browser1,browser2];
  static const email="write email";
  static const browser1="open";
  static const browser2="go to";
  static const phone="call to";
  static const sms="sms to";
}
class Utils{
  static void scanText(String rawtext){
    final text=rawtext.toLowerCase();
    if(text.contains(Command.email)){ //check if text conatin write email word
      final body=_getTextAfterCommand(Text:text,command:Command.email); //check the next words after command word
      openemail(body:body);
    }else if(text.contains(Command.browser1)){ //check if text conatin open word
      final url=_getTextAfterCommand(Text:text,command:Command.browser1);
      openLink(Url:url);
    }
    else if(text.contains(Command.phone)){ // check if text contain call to word
      final url=_getTextAfterCommand(Text:text,command:Command.phone);

      call(Url:url);
    }else if(text.contains(Command.sms)){ //check if text contain sms to word
      final url=_getTextAfterCommand(Text:text,command:Command.sms);
      sms(Url:url);
    }
  }
  static _getTextAfterCommand({ //scan the next word after command word
    required String Text,required String command
}){
    final indexcommand=Text.indexOf(command);
    final inddexafter=indexcommand+command.length;
    if(indexcommand==-1){
      return null;
    }else{
      return Text.substring(inddexafter).trim();
    }
  }
  static Future openemail({required String body})async{ //open the email 
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'arpitv747@gmail.com',
        query:

          'body=$body',
    );
    if(await canLaunchUrl(params)){
      await launchUrl(params);
    }

  }
  static Future openLink({required String Url})async{ 
    final Uri _url1 = Uri.parse('https://www.google.co.in/');
    final Uri _url2=Uri.parse('https://$Url');
    if(Url.trim().isEmpty){
      await launchUrl(_url1);
    }else{
      await launchUrl(_url2);
    }
  }
  static Future call({required String Url})async{ //open the phone app and dial 807*****51
    final Uri _url = Uri(scheme: 'tel',path:Url);
    final Uri _url1 = Uri(scheme: 'tel',path:'807*****51');

    if(Url.trim().isEmpty){
      await launchUrl(_url1);
    }else{
      launchUrl(_url);
    }
  }
  static Future sms({required String Url})async{  //open the sms app and dial 807*****51
    final Uri _url = Uri(scheme: 'sms',path:Url);
    final Uri _url1 = Uri(scheme: 'sms',path:'8077485551');

    if(Url.trim().isEmpty){
      await launchUrl(_url1);
    }else{
      launchUrl(_url);
    }
  }

}
