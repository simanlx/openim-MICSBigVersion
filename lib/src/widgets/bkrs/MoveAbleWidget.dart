import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoveAbleWidget extends StatefulWidget {
  final Widget child;
  final GlobalKey stackKey; // stack组件的key
  final double offsetX; // 组件初始位置X坐标
  final double offsetY; // 组件初始位置Y坐标

  const MoveAbleWidget(
      {Key? key,
        required this.child,
        required this.stackKey,
        this.offsetX = 0,
        this.offsetY = 0})
      : super(key: key);

  @override
  State<MoveAbleWidget> createState() => _MoveAbleWidgetState();
}

class _MoveAbleWidgetState extends State<MoveAbleWidget> {
  // stack组件宽度
  late double stackWidth;
  // stack组件高度
  late double stackHeight;

  // child组件key
  final GlobalKey _childKey = GlobalKey();
  // child组件宽度
  late double childWidth;
  // child组件高度
  late double childHeight;

  // child组件位置
  late Offset initialOffset;
  var xPosition = 0.0.obs;
  var yPosition = 0.0.obs;

  @override
  void initState() {
    super.initState();

    // 绘制完毕监听
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // 获取stack宽高
      // RenderBox? stackRenderBox =
      // widget.stackKey.currentContext?.findRenderObject() as RenderBox?;
      // stackWidth = stackRenderBox?.size.width ?? 0;
      // stackHeight = stackRenderBox?.size.height ?? 0;
      stackWidth = 1280;
      stackHeight = 720;

      // 获取child宽高
      RenderBox? childRenderBox =
      _childKey.currentContext?.findRenderObject() as RenderBox?;
      childWidth = childRenderBox?.size.width ?? 0;
      childHeight = childRenderBox?.size.height ?? 0;

      // 可拖动组件的初始位置
      Offset newOffset = configOffset(widget.offsetX, widget.offsetY);
      xPosition.value = newOffset.dx;
      yPosition.value = newOffset.dy;
    });
  }

  // 设置可拖动组件位置不超出父组件范围
  Offset configOffset(double childX, double childY) {
    double newX = childX;
    double newY = childY;
    // 左边界
    if (newX < 0) {
      newX = 0;
    }
    // 右边界
    if (newX > (stackWidth - childWidth)) {
      newX = stackWidth - childWidth;
    }
    // 上边界
    if (newY < 0) {
      newY = 0;
    }
    // 下边界
    if (newY > (stackHeight - childHeight)) {
      newY = stackHeight - childHeight;
    }

    return Offset(newX, newY);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        top: yPosition.value,
        left: xPosition.value,
        child: GestureDetector(
          child: Container(
            key: _childKey,
            child: widget.child,
          ),
          onPanUpdate: (DragUpdateDetails details) {
            // 拖动不允许超过父组件范围
            Offset newOffset = configOffset(
              xPosition.value + details.delta.dx,
              yPosition.value + details.delta.dy,
            );
            xPosition.value = newOffset.dx;
            yPosition.value = newOffset.dy;
            // print('x: ${xPosition.value}  y: ${yPosition.value}');
          },
        ),
      );
    });
  }
}