import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneInputFormWidget extends StatelessWidget {
  PhoneInputFormWidget(
      {super.key,
      required this.hintText,
      required this.keyboardType,
      this.icon,
      required this.onChanged,
      required this.controller});
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final IconData? icon;
  final TextEditingController controller;
  final Country selectedCountry = Country(
      phoneCode: '+84',
      countryCode: 'VN',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Việt Nam',
      example: 'Việt Nam',
      displayName: 'Việt Nam',
      displayNameNoCountryCode: 'VN',
      e164Key: '');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: (value) {
        onChanged(value);
      },
      controller: controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Số điện thoại không được để trống';
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Số điện thoại khong hop le';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10).w,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20).r),
        hintText: hintText,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(8).r,
          child: InkWell(
            onTap: () {},
            child: Text(
              '${selectedCountry.flagEmoji}  ${selectedCountry.phoneCode}',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0.w, maxHeight: 50.h),
      ),
      keyboardAppearance: Brightness.dark,
    );
  }
}
