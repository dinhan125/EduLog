# TÀI LIỆU ĐẶC TẢ YÊU CẦU HỆ THỐNG (SYSTEM REQUIREMENTS SPECIFICATION - SRS)

**Tên dự án:** EduLog - Ứng dụng Hỗ trợ Vấn đáp & Đánh giá Bài tập lớn
**Người thực hiện:** Đỗ Đình An
**Lớp:** KTPM K65 - Đại học Thủy Lợi (TLU)
**Quy mô đội dự án:** 3 thành viên
**Nền tảng mục tiêu:** Mobile App (React Native / Flutter)
**Phiên bản tài liệu:** 1.0

---

## MỤC LỤC
- [Chương 1: Giới thiệu chung](#chương-1-giới-thiệu-chung)
- [Chương 2: Mô tả tổng quan](#chương-2-mô-tả-tổng-quan)
- [Chương 3: Yêu cầu chức năng (Chi tiết Use Case)](#chương-3-yêu-cầu-chức-năng-chi-tiết-use-case)
- [Chương 4: Yêu cầu phi chức năng (NFR)](#chương-4-yêu-cầu-phi-chức-năng-nfr)
- [Chương 5: Yêu cầu Giao diện & Trải nghiệm (UI/UX)](#chương-5-yêu-cầu-giao-diện--trải-nghiệm-uiux)
- [Chương 6: Ràng buộc & Hướng phát triển](#chương-6-ràng-buộc--hướng-phát-triển)

---

## Chương 1: Giới thiệu chung

### 1.1. Mục đích tài liệu
Tài liệu này cung cấp đặc tả chi tiết về các yêu cầu phần mềm cho ứng dụng di động EduLog. Tài liệu phục vụ làm cơ sở thống nhất giữa đội ngũ phát triển (Dev, UI/UX Designer) và định hướng kiến trúc, kiểm thử cho toàn bộ vòng đời dự án.

### 1.2. Mục tiêu dự án
Xây dựng một nền tảng di động khép kín hỗ trợ giảng viên trong quá trình quản lý, đánh giá và vấn đáp bài tập lớn của sinh viên. Hệ thống tự động hóa việc phân tích dữ liệu đóng góp thực tế từ GitHub và Google Docs, kết hợp sức mạnh của Trí tuệ nhân tạo (AI) để đánh giá chất lượng mã nguồn, sinh câu hỏi phỏng vấn sát với thực tế, từ đó giúp chấm điểm minh bạch, công bằng và chống gian lận (thi hộ, copy code).

### 1.3. Thuật ngữ & Viết tắt
*   **SRS:** System Requirements Specification (Tài liệu đặc tả yêu cầu hệ thống).
*   **OAuth 2.0:** Giao thức ủy quyền mở, cho phép hệ thống truy cập dữ liệu GitHub/Google Docs của sinh viên một cách an toàn.
*   **Code Burst:** Thuật ngữ hệ thống dùng để chỉ hành vi đẩy (push) một lượng lớn mã nguồn bất thường vào repository trong một thời gian cực ngắn (dấu hiệu sao chép).
*   **Zero-typing:** Nguyên tắc thiết kế giao diện hạn chế tối đa việc nhập liệu bằng bàn phím ảo.
*   **LLM:** Large Language Model (Mô hình ngôn ngữ lớn) - AI engine đứng sau tính năng sinh câu hỏi và tổng hợp nhận xét (Gemini/ChatGPT).

---

## Chương 2: Mô tả tổng quan

### 2.1. Định nghĩa Tác nhân (Actors)
1.  **Giảng viên (Teacher):** Người có toàn quyền quản lý lớp học, quản lý các nhóm, theo dõi biểu đồ thống kê, sử dụng AI để hỗ trợ vấn đáp và trực tiếp chốt điểm.
2.  **Sinh viên (Student):** Bao gồm vai trò Trưởng nhóm (quản lý link dự án, duyệt thành viên) và Thành viên bình thường. Sinh viên sử dụng app để kết nối tài khoản, theo dõi tiến độ và nhận kết quả.
3.  **Hệ thống AI (AI Agent - Actor ẩn):** Hệ thống tự động kích hoạt ngầm để xử lý dữ liệu thô từ API, tóm tắt dự án, nhận diện code rác và sinh câu hỏi trắc nghiệm/vấn đáp.

### 2.2. Môi trường hoạt động
*   **Nền tảng:** Ứng dụng di động (Android 8.0+ và iOS 13.0+).
*   **Kiến trúc:** Clean Architecture.
*   **Kết nối:** Yêu cầu kết nối Internet liên tục để giao tiếp với API bên thứ ba (GitHub, Google, LLM).

---

## Chương 3: Yêu cầu chức năng (Chi tiết Use Case)

### 3.1. Phân hệ Giảng viên (Teacher Module)

| ID | Tên chức năng (Use Case) | Mô tả chi tiết nghiệp vụ |
| :--- | :--- | :--- |
| **TE-01** | **Quản lý Lớp học** | - **Mô tả:** Giảng viên tạo lớp học mới trên hệ thống.<br>- **Luồng xử lý:** Giảng viên nhập Tên lớp -> Hệ thống tự động sinh Mã lớp (Class Code) và Link mời -> Giảng viên chia sẻ qua các nền tảng khác (Zalo, Teams). |
| **TE-02** | **Xem Tổng quan Nhóm** | - **Mô tả:** Xem dữ liệu phân tích đóng góp của một nhóm cụ thể.<br>- **Dữ liệu hiển thị:** Biểu đồ tròn hiển thị % đóng góp tổng hợp (GitHub, Docs, Teamwork). Cảnh báo "Code Burst" nếu phát hiện sinh viên có lượng commit lớn bất thường. Danh sách commit không đạt chuẩn kèm lý do từ AI. |
| **TE-03** | **Chụp ảnh Xác thực** | - **Mô tả:** Chống thi hộ trước khi bắt đầu vấn đáp.<br>- **Luồng xử lý:** Giảng viên bấm nút Camera cạnh tên sinh viên -> Hệ thống chia đôi màn hình (Ảnh thẻ hồ sơ vs. Camera thực tế) -> Giảng viên chụp ảnh Live -> Lưu ảnh vào biên bản vấn đáp. |
| **TE-04** | **Điều khiển Vấn đáp (AI)** | - **Mô tả:** Trợ lý AI hỗ trợ đặt câu hỏi dựa trên code của sinh viên.<br>- **Luồng xử lý:** Màn hình hiển thị 5 câu hỏi AI đề xuất dựa trên nhiệm vụ của sinh viên (phân loại Nhận biết, Hiểu logic, Tối ưu). Giảng viên sử dụng thao tác "Tick chọn" các câu sẽ hỏi. |
| **TE-05** | **Đánh giá & Chốt điểm** | - **Mô tả:** Thao tác chấm điểm Zero-typing.<br>- **Luồng xử lý:** Giảng viên chọn mức độ (Xuất sắc/Tốt/Một phần/Chưa đạt) cho từng câu hỏi -> Chọn các Thẻ (Chips) nhận xét nhanh -> Hệ thống AI tính toán và đề xuất một con số điểm (vd: 7.5) -> Giảng viên dùng thanh trượt (Slider) để điều chỉnh lần cuối và lưu kết quả. |
| **TE-06** | **Ghi âm Nhận xét** | - **Mô tả:** Voice-to-Text để nhận xét ngoại lệ.<br>- **Luồng xử lý:** Giảng viên nhấn giữ nút Mic -> Đọc nhận xét -> App tự chuyển đổi thành Text và đính kèm vào biên bản kết quả. |

### 3.2. Phân hệ Sinh viên (Student Module)

| ID | Tên chức năng (Use Case) | Mô tả chi tiết nghiệp vụ |
| :--- | :--- | :--- |
| **ST-01** | **Tham gia Lớp học** | - **Mô tả:** Định danh sinh viên vào lớp cụ thể.<br>- **Luồng xử lý:** Sinh viên dán Link mời hoặc nhập Mã lớp vào thanh tìm kiếm -> Tham gia vào lớp. |
| **ST-02** | **Quản lý Nhóm** | - **Mô tả:** Tìm đồng đội và thiết lập dự án.<br>- **Tạo nhóm (Trưởng nhóm):** Nhập Tên nhóm, Link GitHub, Link Google Docs -> Nhận mã nhóm để mời bạn bè.<br>- **Tham gia nhóm:** Nhập mã nhóm hoặc Xin vào nhóm từ danh sách lớp. Trưởng nhóm có quyền duyệt hoặc kick (xóa) thành viên. |
| **ST-03** | **Cấp quyền OAuth** | - **Mô tả:** Ủy quyền cho hệ thống đọc dữ liệu đóng góp.<br>- **Luồng xử lý:** Sinh viên bấm nút "Tích hợp GitHub/Google" -> Màn hình WebView hiện lên để đăng nhập -> Trả về token. Nút chuyển sang trạng thái "Tích xanh" (Đã kết nối). *Lưu ý: Bắt buộc để tính % đóng góp.* |
| **ST-04** | **Xem Dashboard Cá nhân** | - **Mô tả:** Sinh viên theo dõi hiệu suất làm việc trước buổi thi.<br>- **Dữ liệu hiển thị:** Biểu đồ hiển thị % công việc so với toàn đội. Thống kê chi tiết số Commit, số dòng code, số từ Docs. Hiển thị các cảnh báo đỏ nếu AI phát hiện code rác. |
| **ST-05** | **Nhận Kết quả Vấn đáp** | - **Mô tả:** Xem lại lịch sử đánh giá sau khi thi xong.<br>- **Luồng xử lý:** Nhận Push Notification khi giảng viên chốt điểm -> Mở app xem Điểm tổng (Vòng tròn tiến độ), danh sách câu hỏi đã bị hỏi kèm kết quả (Tốt/Chưa đạt), và đọc nhận xét tổng hợp từ AI. |

---

## Chương 4: Yêu cầu phi chức năng (NFR)

### 4.1. Hiệu năng & Khả năng đáp ứng (Performance)
*   **Đồng bộ dữ liệu:** Thời gian trích xuất dữ liệu từ GitHub API và Google Docs API không vượt quá `5 giây` để tránh màn hình loading quá lâu.
*   **Thời gian sinh AI:** Các request gửi sang LLM (sinh câu hỏi, tổng hợp nhận xét) phải được stream (trả về từng từ) hoặc hoàn tất dưới `3 giây`.
*   **Hoạt động nền:** Chế độ Vấn đáp phải có tính năng "Keep Screen On" (Ngăn tắt màn hình tự động) để giảng viên không bị gián đoạn.

### 4.2. Bảo mật & An toàn dữ liệu (Security)
*   **Quản lý Token:** Các token OAuth của GitHub và Google phải được mã hóa và lưu trữ an toàn, không hiển thị dưới dạng plain-text trên client.
*   **Toàn vẹn dữ liệu:** Biên bản kết quả vấn đáp (bao gồm điểm số, hình ảnh xác thực sinh viên) sau khi được giảng viên bấm "Hoàn tất" sẽ bị đóng băng (Read-only), không cho phép chỉnh sửa để đảm bảo minh bạch.

### 4.3. Tính khả dụng & Khả năng tương thích (Usability)
*   **Thao tác một tay:** Các nút CTA chính (Bắt đầu vấn đáp, Chốt điểm, Slider) phải được đặt ở nửa dưới màn hình để giảng viên dễ thao tác bằng ngón cái.
*   **Hỗ trợ offline cục bộ:** Nếu mạng chập chờn trong lúc chấm điểm, hệ thống phải cache (lưu tạm) các thao tác tick chọn, nhận xét và tự động đồng bộ (sync) lên server khi có mạng lại.

---

## Chương 5: Yêu cầu Giao diện & Trải nghiệm (UI/UX)

### 5.1. Ngôn ngữ thiết kế (Design Language)
*   **Phong cách:** Hiện đại, sạch sẽ (Clean), sử dụng cấu trúc Thẻ (Card-based).
*   **Màu sắc quy chuẩn:**
    *   Màu chủ đạo (Primary): Xanh dương đậm (Đại diện cho sự học thuật, chuyên nghiệp).
    *   Màu cảnh báo/Lỗi (Danger): Đỏ (Áp dụng cho Code Burst, Commit rác).
    *   Màu thành công (Success): Xanh lá (Đã liên kết tài khoản, Commit đạt chuẩn).
*   **Hiệu ứng (Animation):** Áp dụng hiệu ứng vòng tròn tiến độ (Circular Progress) khi hiển thị điểm số và % đóng góp để tăng độ trực quan.

### 5.2. Nguyên tắc Mobile-First: Triết lý "Zero-Typing"
Phân hệ giảng viên trong phòng thi phải được thiết kế để loại bỏ 95% thao tác gõ bàn phím:
1.  **Checkboxes:** Chạm để chọn câu hỏi vấn đáp.
2.  **Chips/Tags:** Chạm để chọn các nhận xét định sẵn (`[Trả lời lưu loát]`, `[Chép code]`).
3.  **Slider:** Trượt ngón tay để chốt điểm số từ 0 - 10.
4.  **Gestures (Cử chỉ):** Vuốt màn hình sang trái/phải để chuyển tiếp nhanh giữa các sinh viên trong một nhóm.
5.  **Phần cứng:** Nút Mic kích hoạt Voice-to-Text; Nút Camera kích hoạt chụp ảnh đối chiếu sinh viên.

---

## Chương 6: Ràng buộc & Hướng phát triển

### 6.1. Ràng buộc dự án
*   **Nhân lực & Thời gian:** Đội ngũ phát triển chỉ gồm 3 thành viên, cần ưu tiên hoàn thiện các luồng (Flows) cốt lõi (Tạo lớp -> Nhập nhóm -> Phân tích -> Vấn đáp) trước khi làm các tính năng phụ.
*   **Giới hạn API:** Các API miễn phí của LLM (như Gemini) có giới hạn số lượng token mỗi phút (Rate limit). Cần thiết kế thuật toán làm sạch (clean up) mã nguồn, chỉ gửi đi những file code/commit quan trọng nhất để AI đọc, tránh lỗi vượt quá context length.

### 6.2. Hướng phát triển tương lai (Future Scope)
*   **Plagiarism Checker (Kiểm tra Đạo văn):** Mở rộng hệ thống để đối chiếu mã nguồn (Cross-check) giữa các nhóm khác nhau trong cùng một lớp học môn Kỹ thuật phần mềm.
*   **Export Biên bản:** Hỗ trợ giảng viên xuất toàn bộ kết quả khóa học ra định dạng Excel (.xlsx) hoặc PDF có chữ ký số để nộp về Phòng Đào tạo Đại học Thủy Lợi.