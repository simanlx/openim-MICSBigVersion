

import 'package:flutter/services.dart';

class ChannelManage{


  ChannelManage._internal();

  static ChannelManage _singleton = ChannelManage._internal();

  factory ChannelManage() => _singleton;

  var methodChannel = MethodChannel("channel_big_version");
  var eventChannel = EventChannel("speech_event_channel");



}