import 'package:flutter/material.dart';

import '../../../res/constant/app_fonts.dart';
import '../../../res/style/app_colors.dart';
import '../../../utils/dimens/dimens_manager.dart';

class TextDialog extends StatelessWidget {
  final String content;
  final String contentBetween;
  final String contentEnd;
  final String contentEndBold;

  const TextDialog(
      {super.key,
      required this.content,
      required this.contentBetween,
      required this.contentEnd,
      required this.contentEndBold});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DimensManager.dimens.setWidth(26),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        textScaleFactor: 1.0,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: content,
              style: TextStyle(
                letterSpacing: 0.75,
                height: 1.25,
                fontFamily: AppFonts.nunito,
                color: AppColors.primaryColor,
                fontSize: DimensManager.dimens.setSp(14),
                fontWeight: FontWeight.w500,
              )),
          TextSpan(
              text: contentBetween,
              style: TextStyle(
                letterSpacing: 0.75,
                height: 1.25,
                fontFamily: AppFonts.nunito,
                color: AppColors.primaryColor,
                fontSize: DimensManager.dimens.setSp(14),
                fontWeight: FontWeight.w700,
              )),
          TextSpan(
              text: contentEnd,
              style: TextStyle(
                letterSpacing: 0.75,
                height: 1.25,
                fontFamily: AppFonts.nunito,
                color: AppColors.primaryColor,
                fontSize: DimensManager.dimens.setSp(14),
                fontWeight: FontWeight.w500,
              )),
          TextSpan(
              text: contentEndBold,
              style: TextStyle(
                letterSpacing: 0.75,
                height: 1.25,
                fontFamily: AppFonts.nunito,
                color: AppColors.primaryColor,
                fontSize: DimensManager.dimens.setSp(14),
                fontWeight: FontWeight.w700,
              )),
        ]),
      ),
    );
  }
}
