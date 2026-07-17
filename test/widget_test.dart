import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Đổi 'tên_project_của_bạn' thành tên thư mục dự án (ví dụ: edulog)
import 'package:tên_project_của_bạn/main.dart'; 

void main() {
  testWidgets('Kiểm tra khởi chạy ứng dụng EduLogApp', (WidgetTester tester) async {
    // Bọc ứng dụng trong ProviderScope để Riverpod hoạt động trong môi trường test
    await tester.pumpWidget(
      const ProviderScope(
        child: EduLogApp(),
      ),
    );

    // Xác nhận ứng dụng đã render thành công màn hình có chứa đoạn text này
    expect(find.text('Hệ thống Đánh giá EduLog'), findsOneWidget);
  });
}