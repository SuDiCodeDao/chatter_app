import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displaySmall: GoogleFonts.poppins(
      color: secondaryTextColor,
    ),
    titleSmall: GoogleFonts.poppins(
      color: primaryTextColor,
      fontSize: 24.sp,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    displaySmall: GoogleFonts.poppins(
      color: secondaryTextDarkColor,
    ),
    titleSmall: GoogleFonts.poppins(
      color: primaryTextDarkColor,
      fontSize: 24.sp,
    ),
  );
}
