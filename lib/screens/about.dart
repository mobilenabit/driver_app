import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Về ứng dụng",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        centerTitle: false,
        foregroundColor: const Color(0xFFFCFCFF),
        backgroundColor: const Color(0xFF6360FF),
        surfaceTintColor: const Color(0xFF6360FF),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 32, bottom: 70),
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEFF8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Petronet Driver là một ứng dụng hiện đại, mang lại sự tiện lợi và nhanh chóng cho các tài xế khi mua xăng dầu tại các cửa hàng xăng dầu trong hệ thống. Với ứng dụng này, tài xế có thể tận hưởng những trải nghiệm tiện ích như:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Thanh toán nhanh chóng chỉ với một quẹt: Với mỗi giao dịch mua xăng dầu trong hệ thống cửa hàng, tài xế chỉ cần thanh toán thông qua mã QR định danh, đây giải pháp thông minh, hiện đại, giúp cải thiện trải nghiệm mua xăng dầu của tài xế, giảm thiểu thời gian chờ đợi tại trạm.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Quản lý các giao dịch: Lưu lịch sử các giao dịch, lượng chi tiêu nhiên liệu xăng dầu, tiện lợi trong công tác đối soát không phải thực hiện đối chiếu thủ công.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Dễ dàng tìm kiếm cửa hàng xăng dầu gần nhất giúp tiết kiệm thời gian và tối ưu hóa lộ trình di chuyển.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Cập nhật tin tức: Các thông tin về giá xăng dầu và diễn biến giá xăng dầu.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Liên hệ với Petronet:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Email: petronet.vn@gmail.com",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Website: www.petronet.vn",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
