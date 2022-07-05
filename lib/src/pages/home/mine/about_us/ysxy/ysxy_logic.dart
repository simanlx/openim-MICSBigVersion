
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class YsxyLogic extends GetxController {



  @override
  void onReady() {

    initContent();
    super.onReady();
  }

  var content = "".obs;

  void initContent() async{
    var  con  = await rootBundle.loadString("assets/splash/ysxy.txt");
    content.value =  con;
  }

}
