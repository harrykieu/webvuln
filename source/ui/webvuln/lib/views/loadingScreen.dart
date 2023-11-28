import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scan_screen.dart';

class loadingScreen extends StatelessWidget {
  const loadingScreen({super.key});
  Future<String> fetchData() async {
    // postURL(nameURL: nameURL, moduleNumber: moduleNumber)
    await Future.delayed(
        const Duration(seconds: 2)); // Giả lập thời gian đợi API
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Nếu đang đợi dữ liệu, hiển thị màn hình loading
            return Container(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Nếu có lỗi khi gọi API, hiển thị thông báo lỗi
            return Text('Error: ${snapshot.error}');
          } else {
            // Nếu thành công, hiển thị nội dung cần thiết
            return resultScreen();
          }
        },
      ),
      ),
    );
  }
}
