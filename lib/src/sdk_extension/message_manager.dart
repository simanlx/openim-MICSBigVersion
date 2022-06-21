import 'dart:convert';

import 'package:flutter_openim_widget/flutter_openim_widget.dart';

extension MessageManagerExt on MessageManager {
  /// 通话消息；语音/视频通话
  /// [ type ] video/voice
  /// [ state ] 已拒绝/对方已拒绝/已取消/对方已取消/其他
  Future<Message> createCallMessage({
    required String type,
    required String state,
    int? duration,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.call,
          "data": {
            'duration': duration,
            'state': state,
            'type': type,
          },
        }),
        extension: '',
        description: '',
      );

  /// 自定义表情消息
  Future<Message> createCustomEmojiMessage({
    required String url,
    int? width,
    int? height,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.custom_emoji,
          "data": {
            'url': url,
            'width': width,
            'height': height,
          },
        }),
        extension: '',
        description: '',
      );

  /// 根据tag下发通知
  /// 包含语音内容或文字内容
  Future<Message> createTagMessage({
    String? url,
    int? duration,
    String? text,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.tag_message,
          "data": {
            'url': url,
            'duration': duration,
            'text': text,
          },
        }),
        extension: '',
        description: '',
      );
}

class CustomMessageType {
  static const call = 901;
  static const custom_emoji = 902;
  static const tag_message = 903;
}
