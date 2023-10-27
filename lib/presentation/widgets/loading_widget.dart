import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Tạo một lớp mờ trên màn hình nền
      child: const Center(
        child: CircularProgressIndicator(), // Hiển thị tiến trình tải
      ),
    );
  }
}
