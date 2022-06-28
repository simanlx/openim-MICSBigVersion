import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/res/styles.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FontSizeSlider extends StatefulWidget {
  const FontSizeSlider({Key? key, this.onChanged}) : super(key: key);
  final Function(double factor)? onChanged;

  @override
  _FontSizeSliderState createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends State<FontSizeSlider> {
  double _value = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PageStyle.c_FFFFFF,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 5.h,
      ),
      child: Column(
        children: [
          _buildIndicatorLabel(),
          SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 4,
              inactiveTrackHeight: 4,
              inactiveTrackColor: const Color(0xFF2196f3),
              activeTrackColor: const Color(0xFF2196f3),
            ),
            child: SfSlider(
              min: 0.8,
              max: 3,
              value: _value,
              // interval: 2,
              showTicks: false,
              showLabels: false,
              enableTooltip: false,
              minorTicksPerInterval: 1,
              onChanged: (dynamic value) {
                setState(() {
                  _value = value;
                  widget.onChanged?.call(_value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorLabel() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StrRes.little,
            style: PageStyle.ts_333333_12sp,
          ),
          // Text(
          //   StrRes.standard,
          //   style: PageStyle.ts_333333_14sp,
          // ),
          Text(
            StrRes.big,
            style: PageStyle.ts_333333_18sp,
          ),
        ],
      );
}
