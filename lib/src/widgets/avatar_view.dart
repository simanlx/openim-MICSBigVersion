import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../utils/im_util.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    Key? key,
    this.visible = true,
    this.size,
    this.onTap,
    this.url,
    this.builder,
    this.text,
    this.textStyle,
    this.onLongPress,
    this.isCircle = false,
    this.borderRadius,
    this.enabledPreview = false,
    this.lowMemory = true,
    this.isNineGrid = false,
    this.nineGridUrl = const [],
    this.isUserGroup = false,
  }) : super(key: key);
  final bool visible;
  final double? size;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;
  final CustomAvatarBuilder? builder;
  final bool isCircle;
  final BorderRadius? borderRadius;
  final enabledPreview;
  final String? text;
  final TextStyle? textStyle;
  final bool lowMemory;
  final bool isNineGrid;
  final List<String> nineGridUrl;
  final bool isUserGroup;

  @override
  Widget build(BuildContext context) {
    var tag = Uuid().v4();
    return Hero(
      tag: tag,
      child: ChatAvatarView(
        visible: visible,
        size: size ?? 42.h,
        onTap: onTap ??
            (enabledPreview
                ? () {
                    if (url != null && url!.trim().isNotEmpty) {
                      Get.to(() => IMUtil.previewPic(
                          tag: tag, picList: [PicInfo(url: url)]));
                    }
                  }
                : null),
        url: url,
        builder: builder,
        text: _calShowName(),
        textStyle: textStyle,
        onLongPress: onLongPress,
        isCircle: isCircle,
        borderRadius: borderRadius,
        lowMemory: lowMemory,
        isNineGrid: false,
        nineGridUrls: [],
        isUserGroup: isUserGroup,
        color: Color(0xFF0072E3),
      ),
    );
  }

  AvatarView.nineGrid(
    this.visible,
    this.size,
    this.borderRadius,
    this.nineGridUrl,
  )   : lowMemory = false,
        url = null,
        builder = null,
        isCircle = false,
        enabledPreview = false,
        isNineGrid = false,
        text = null,
        textStyle = null,
        onLongPress = null,
        onTap = null,
        isUserGroup = true;

  String? _calShowName() {
    if (text != null) {
      // if (ChineseHelper.isChinese(text!)) {
      if (text!.length <= 2) {
        return text;
      } else {
        return text!.substring(text!.length - 2);
      }
      // }
    }
    return null;
  }
}
