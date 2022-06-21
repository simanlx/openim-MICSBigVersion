import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:mics_big_version/src/app.dart';
import 'package:mics_big_version/src/common/config.dart';

void main() => FlutterBugly.postCatchedException(() {
  Config.init(() => runApp(EnterpriseChatApp()));
});