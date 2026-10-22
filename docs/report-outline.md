# Đề cương báo cáo thực hành (tối thiểu 10 trang)

> Đây là đề cương để hoàn thiện bằng thông tin sinh viên và ảnh chụp từ lần triển khai thực tế. Không trình bày số liệu hoặc kết quả chưa tự kiểm chứng.

## Trang 1 — Bìa

- Tên trường, khoa, môn học
- Tên đề tài: Triển khai và quản trị WordPress bằng Docker Compose
- Họ tên, mã số sinh viên, lớp
- Giảng viên hướng dẫn, địa điểm và thời gian

## Trang 2 — Mục tiêu và phạm vi

Nêu yêu cầu bài thực hành, mục tiêu triển khai, phạm vi các dịch vụ và giới hạn của môi trường demo. Giải thích vì sao chọn WordPress, MySQL và các thành phần quan sát hệ thống.

## Trang 3 — Kiến trúc tổng thể

Mô tả luồng truy cập `Browser -> Nginx -> WordPress -> MySQL`, các thành phần phpMyAdmin, Prometheus, Grafana, cAdvisor, exporters, Loki và Promtail. Chèn sơ đồ kiến trúc tự vẽ và giải thích hai Docker network cùng các named volume.

## Trang 4 — Docker Compose và ứng dụng

Mô tả các service, image, biến môi trường, volume và dependency. Chụp màn hình `docker compose ps`; mô tả các bước tạo WordPress administrator và kết quả trang chủ thực tế.

## Trang 5 — Database và phpMyAdmin

Giải thích MySQL, database/user ứng dụng, tài khoản metrics với quyền giới hạn, lưu trữ dữ liệu. Chụp phpMyAdmin hiển thị database WordPress và mô tả cách xác nhận WordPress kết nối database.

## Trang 6 — Nginx reverse proxy và HTTPS

Giải thích chuyển hướng HTTP sang HTTPS, proxy headers, chứng chỉ tự ký và các response security headers. Chụp trang web qua `https://localhost`, kết quả kiểm tra header và cấu hình Nginx liên quan.

## Trang 7 — Prometheus và Grafana

Mô tả scrape interval, Prometheus targets, cAdvisor, Nginx exporter và MySQL exporter. Chụp targets ở trạng thái `UP` và dashboard `WordPress deployment lab` có dữ liệu thực. Giải thích các truy vấn PromQL đang sử dụng.

## Trang 8 — Loki, Promtail và LogQL

Mô tả nguồn log Nginx, Promtail positions, Loki và luồng gửi log. Chụp Explore với ít nhất ba truy vấn: tất cả log Nginx, lọc HTTP 404, lọc HTTP 5xx. Tạo request tương ứng trước khi chụp để có dữ liệu.

## Trang 9 — Hardening và kiểm thử

Phân tích network isolation, không publish cổng MySQL, biến môi trường không commit, quyền DB, security headers và các mount read-only. Ghi các bước kiểm tra, vấn đề gặp phải và cách xử lý, chỉ dựa trên kết quả của chính lần chạy.

## Trang 10 — Kết luận và hướng phát triển

Đánh giá yêu cầu nào đã hoàn thành, bài học vận hành, giới hạn còn lại và kế hoạch cải tiến. Có thể đề xuất chứng chỉ tin cậy cho môi trường thật, backup, cảnh báo Grafana và giám sát thêm ứng dụng.

## Phụ lục (nếu cần)

- Các lệnh Compose đã dùng
- Các truy vấn PromQL/LogQL
- Cấu hình đã chọn lọc (không đưa mật khẩu, `.env`, private key)
- Danh sách minh chứng và thời điểm chụp
