import 'package:flutter/material.dart';
import 'package:tubes_apb/models/app_notification_model.dart';
import 'package:tubes_apb/services/api_service.dart';
import 'package:tubes_apb/widgets/app_header.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const Color primaryRed = Color(0xFFD32F2F);

  static const Color titleRed = Color(0xFFE51C23);

  static const Color softRed = Color(0xFFFFE3E3);

  String selectedFilter = 'Semua';

  late Future<List<AppNotificationModel>> notificationsFuture;

  List<AppNotificationModel> notifications = [];

  final List<String> filters = const ['Semua', 'Belum Dibaca', 'Sudah Dibaca'];

  @override
  void initState() {
    super.initState();

    notificationsFuture = ApiService.instance.getNotifications();
  }

  Future<void> _refreshNotifications() async {
    final newFuture = ApiService.instance.getNotifications();

    setState(() {
      notificationsFuture = newFuture;
    });

    final result = await newFuture;

    if (!mounted) {
      return;
    }

    setState(() {
      notifications = result;
    });
  }

  void _retryLoad() {
    setState(() {
      notificationsFuture = ApiService.instance.getNotifications();
    });
  }

  List<AppNotificationModel> _filteredNotifications() {
    switch (selectedFilter) {
      case 'Belum Dibaca':
        return notifications.where((item) => !item.isRead).toList();

      case 'Sudah Dibaca':
        return notifications.where((item) => item.isRead).toList();

      default:
        return notifications;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;

      case 'warning':
        return Colors.orange;

      case 'error':
        return primaryRed;

      case 'info':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle_rounded;

      case 'warning':
        return Icons.hourglass_top_rounded;

      case 'error':
        return Icons.cancel_rounded;

      case 'info':
        return Icons.info_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  String _getStatusText(String type) {
    switch (type) {
      case 'success':
        return 'Berhasil';

      case 'warning':
        return 'Menunggu';

      case 'error':
        return 'Ditolak';

      case 'info':
        return 'Informasi';

      default:
        return 'Notifikasi';
    }
  }

  String _getActionText(String type) {
    switch (type) {
      case 'success':
        return 'Pengajuan atau proses peminjaman telah berhasil diproses.';

      case 'warning':
        return 'Pengajuan masih menunggu verifikasi atau tindakan dari admin.';

      case 'error':
        return 'Periksa kembali informasi pengajuan atau alasan penolakan.';

      case 'info':
        return 'Informasi ini membantu memantau status peminjaman ruangan.';

      default:
        return 'Periksa detail notifikasi untuk informasi lebih lanjut.';
    }
  }

  Widget _filterChip(String label) {
    final selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(right: 9),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? titleRed : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? titleRed : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    final total = notifications.length;

    final unread = notifications.where((item) => !item.isRead).length;

    final success = notifications
        .where((item) => item.type == 'success')
        .length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktivitas Peminjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$total notifikasi • $unread belum dibaca • $success berhasil',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard(AppNotificationModel item) {
    final color = _getColor(item.type);

    return InkWell(
      onTap: () async {
        await _openNotification(item);
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFFFF8F8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: item.isRead
                ? color.withOpacity(0.08)
                : titleRed.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(_getIcon(item.type), color: color, size: 28),
                ),
                if (!item.isRead)
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: titleRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: item.isRead
                                ? FontWeight.w700
                                : FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(item.type),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.isRead ? 'Sudah dibaca' : 'Belum dibaca',
                        style: TextStyle(
                          color: item.isRead ? Colors.grey[500] : titleRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNotification(AppNotificationModel item) async {
    AppNotificationModel selectedItem = item;

    if (!item.isRead) {
      try {
        final updated = await ApiService.instance.markNotificationAsRead(
          item.id,
        );

        selectedItem = updated;

        if (!mounted) {
          return;
        }

        setState(() {
          notifications = notifications.map((notification) {
            if (notification.id == item.id) {
              return updated;
            }

            return notification;
          }).toList();
        });
      } on ApiException catch (error) {
        if (!mounted) {
          return;
        }

        _showMessage(error.message);
      } catch (error) {
        if (!mounted) {
          return;
        }

        _showMessage('Terjadi kesalahan saat membuka notifikasi.');
      }
    }

    if (!mounted) {
      return;
    }

    _showNotificationDetail(selectedItem);
  }

  void _showNotificationDetail(AppNotificationModel item) {
    final color = _getColor(item.type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.50,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(item.type),
                            color: color,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _detailRow(
                    icon: Icons.verified_rounded,
                    label: 'Status',
                    value: _getStatusText(item.type),
                    color: color,
                  ),
                  _detailRow(
                    icon: Icons.access_time_filled_rounded,
                    label: 'Waktu',
                    value: item.time,
                    color: titleRed,
                  ),
                  _detailRow(
                    icon: Icons.notifications_active_rounded,
                    label: 'Kategori',
                    value: 'Peminjaman',
                    color: Colors.blue,
                  ),
                  _detailRow(
                    icon: Icons.mark_email_read_rounded,
                    label: 'Status Dibaca',
                    value: item.isRead ? 'Sudah dibaca' : 'Belum dibaca',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: softRed,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_rounded, color: titleRed),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _getActionText(item.type),
                            style: const TextStyle(
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: titleRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Tutup Detail',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator(color: primaryRed));
  }

  Widget _errorState(Object? error) {
    final message = error is ApiException
        ? error.message
        : 'Terjadi kesalahan saat mengambil notifikasi.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 14),
            const Text(
              'Gagal memuat notifikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _retryLoad,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 14),
            const Text(
              'Belum ada notifikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            Text(
              selectedFilter == 'Semua'
                  ? 'Status peminjaman ruangan akan muncul di sini.'
                  : 'Tidak ada notifikasi dengan filter $selectedFilter.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Notifikasi',
              subtitle: 'Pantau informasi dan status peminjaman',
              icon: Icons.notifications_rounded,
              showBackButton: true,
            ),
            Expanded(
              child: FutureBuilder<List<AppNotificationModel>>(
                future: notificationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _loadingState();
                  }

                  if (snapshot.hasError) {
                    return _errorState(snapshot.error);
                  }

                  if (notifications.isEmpty && snapshot.data != null) {
                    notifications = snapshot.data!;
                  }

                  final filtered = _filteredNotifications();

                  return Column(
                    children: [
                      _summaryCard(),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 46,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          children: filters.map(_filterChip).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: filtered.isEmpty
                            ? _emptyState()
                            : RefreshIndicator(
                                color: primaryRed,
                                onRefresh: _refreshNotifications,
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    20,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    return _notificationCard(filtered[index]);
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
