import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qlm_guardian_app_v5/core/theme/app_colors.dart';
import '../../../data/models/admin_guardian_model.dart';
import '../../screens/guardians/guardian_details_screen.dart';
import '../../screens/add_edit_guardian_screen.dart';

class GuardianListCard extends StatefulWidget {
  final AdminGuardianModel guardian;
  final VoidCallback? onTap;
  final VoidCallback? onRefresh;
  final Widget? customActions; // E.g., Renew/History buttons

  const GuardianListCard({
    super.key,
    required this.guardian,
    this.onTap,
    this.onRefresh,
    this.customActions,
  });

  @override
  State<GuardianListCard> createState() => _GuardianListCardState();
}

class _GuardianListCardState extends State<GuardianListCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = _parseColor(widget.guardian.employmentStatusColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          key: ValueKey(widget.guardian.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.5,
            children: [
              SlidableAction(
                onPressed: (context) {
                  // TODO: Renew Logic
                },
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                icon: Icons.autorenew,
                label: 'تجديد',
              ),
              SlidableAction(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEditGuardianScreen(guardian: widget.guardian),
                    ),
                  ).then((result) {
                    if (result == true) {
                      widget.onRefresh?.call();
                    }
                  });
                },
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.white,
                icon: Icons.edit_outlined,
                label: 'تعديل',
              ),
            ],
          ),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  // TODO: Delete Logic
                },
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: 'حذف',
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  widget.onTap ??
                  () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [_buildHeader(statusColor), _buildExpandedBody()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color statusColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + Status Ring
        Hero(
          tag: 'guardian_avatar_${widget.guardian.id}',
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                  backgroundImage: widget.guardian.photoUrl != null
                      ? NetworkImage(widget.guardian.photoUrl!)
                      : null,
                  onBackgroundImageError: widget.guardian.photoUrl != null
                      ? (exception, stackTrace) {}
                      : null,
                  child: widget.guardian.photoUrl == null
                      ? Icon(Icons.person, color: statusColor, size: 30)
                      : null,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Infos
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.guardian.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontFamily: 'Tajawal',
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  // Identity Status
                  _buildCircularStatusIndicator(
                    label: 'الهوية',
                    days: widget.guardian.identityDays,
                  ),
                  const SizedBox(width: 8),
                  // License Status
                  _buildCircularStatusIndicator(
                    label: 'الترخيص',
                    days: widget.guardian.licenseDays,
                  ),
                  const SizedBox(width: 8),
                  // Profession Card Status
                  _buildCircularStatusIndicator(
                    label: 'المهنة',
                    days: widget.guardian.cardDays,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Caret Icon
        Column(
          children: [
            _buildStatusBadge(
              widget.guardian.employmentStatus ?? 'غير محدد',
              statusColor,
            ),
            const SizedBox(height: 8),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedBody() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isExpanded
          ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                // Jurisdiction Areas
                _buildJurisdictionAreas(),
                const SizedBox(height: 16),

                // Quick Action Icons
                _buildQuickActions(context),
                const SizedBox(height: 16),
                // Removed Progress Bars from here as they are now in the header
                // Action Buttons
                widget.customActions ??
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GuardianDetailsScreen(
                                guardian: widget.guardian,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              widget.onRefresh?.call();
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'عرض الملف الكامل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCircularStatusIndicator({required String label, int? days}) {
    Color indicatorColor = Colors.grey;
    String dayText = '---';
    double progress = 0.0;

    if (days != null) {
      if (days < 0) {
        indicatorColor = AppColors.error;
        dayText = 'منتهي';
        progress = 1.0;
      } else {
        dayText = days > 99 ? 'مجدد' : days.toString();
        // Calculate progress and color based on 30 days scale
        // > 60 days: Full Green
        // 60-31 days: Green with orange starting
        // < 31 days: Orange turning to Red

        if (days > 60) {
          indicatorColor = AppColors.success;
          progress = 1.0;
        } else if (days > 30) {
          // Transitions from Orange to Green over 30 days
          // days = 60 -> 100% Green, days = 31 -> ~100% Orange
          final fraction = (days - 30) / 30.0; // 0.0 to 1.0
          indicatorColor =
              Color.lerp(AppColors.warning, AppColors.success, fraction) ??
              AppColors.success;
          progress = 1.0;
        } else {
          // Transitions from Red to Orange over 30 days
          // days = 30 -> 100% Orange, days = 0 -> 100% Red
          final fraction = days / 30.0; // 0.0 to 1.0
          indicatorColor =
              Color.lerp(AppColors.error, AppColors.warning, fraction) ??
              AppColors.warning;
          // Progress circle reduces from 1.0 (at 30 days) to 0.0 (at 0 days)
          progress = fraction.clamp(0.0, 1.0);
        }
      }
    }

    return Column(
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
              ),
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
              Center(
                child: Text(
                  dayText,
                  style: TextStyle(
                    fontSize: dayText == 'مجدد' || dayText == 'منتهي' ? 8 : 10,
                    fontWeight: FontWeight.bold,
                    color: indicatorColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Color _parseColor(String? colorName) {
    if (colorName == null) return Colors.grey;
    switch (colorName.toLowerCase()) {
      case 'success':
      case 'green':
        return AppColors.success;
      case 'danger':
      case 'error':
      case 'red':
        return AppColors.error;
      case 'warning':
      case 'orange':
        return AppColors.warning;
      case 'info':
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildJurisdictionAreas() {
    final villagesText =
        widget.guardian.villages?.map((e) => e.name).join('، ') ??
        'لا توجد قرى';
    final localitiesText =
        widget.guardian.localities?.map((e) => e.name).join('، ') ??
        'لا توجد محلات';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          Icons.push_pin_outlined,
          'العزلة',
          widget.guardian.mainDistrictName ?? 'غير محدد',
          iconColor: Colors.deepPurple,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.location_city_outlined,
          'القرى',
          villagesText,
          iconColor: Colors.teal,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.home_work_outlined,
          'المحلات',
          localitiesText,
          iconColor: Colors.orange.shade700,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color iconColor = AppColors.primary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            fontFamily: 'Tajawal',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Call Action
        _buildActionIconButton(
          icon: Icons.phone_outlined,
          label: 'اتصال',
          color: AppColors.success,
          onTap: () async {
            if (widget.guardian.phone == null ||
                widget.guardian.phone!.isEmpty) {
              _showSnackBar(context, 'لا يوجد رقم هاتف متاح');
              return;
            }
            final Uri launchUri = Uri(
              scheme: 'tel',
              path: widget.guardian.phone,
            );
            try {
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              } else {
                _showSnackBar(context, 'لا يمكن إجراء الاتصال');
              }
            } catch (e) {
              _showSnackBar(context, 'حدث خطأ أثناء محاولة الاتصال');
            }
          },
        ),

        // WhatsApp Action
        _buildActionIconButton(
          icon: Icons.wechat_outlined,
          label: 'واتساب',
          color: Colors.green.shade600,
          onTap: () async {
            if (widget.guardian.phone == null ||
                widget.guardian.phone!.isEmpty) {
              _showSnackBar(context, 'لا يوجد رقم هاتف متاح');
              return;
            }

            // Format phone number for WhatsApp (remove leading 0 if starting with 0, or just use as is)
            String whatsappNum = widget.guardian.phone!.replaceAll(
              RegExp(r'\s+'),
              '',
            );
            // Assume local numbers start with 7 or 07, assuming +967 for Yemen context since Arabic
            if (whatsappNum.startsWith('0')) {
              whatsappNum = whatsappNum.substring(1);
            }
            if (whatsappNum.startsWith('7')) {
              whatsappNum = '967$whatsappNum';
            }

            final Uri whatsappUri = Uri.parse(
              'whatsapp://send?phone=$whatsappNum',
            );
            try {
              if (await canLaunchUrl(whatsappUri)) {
                await launchUrl(whatsappUri);
              } else {
                // Fallback to web WhatsApp URL if app not installed
                final Uri webWhatsappUri = Uri.parse(
                  'https://wa.me/$whatsappNum',
                );
                if (await canLaunchUrl(webWhatsappUri)) {
                  await launchUrl(
                    webWhatsappUri,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  _showSnackBar(context, 'تطبيق واتساب غير مثبت');
                }
              }
            } catch (e) {
              _showSnackBar(context, 'تطبيق واتساب غير مثبت');
            }
          },
        ),

        // Share Action
        _buildActionIconButton(
          icon: Icons.share_outlined,
          label: 'مشاركة',
          color: Colors.blue,
          onTap: () {
            final String shareText =
                '''
بيانات الأمين الشرعي:
الاسم: ${widget.guardian.name}
العزلة: ${widget.guardian.mainDistrictName ?? 'غير محدد'}
رقم الهاتف: ${widget.guardian.phone ?? 'غير متوفر'}
رقم الترخيص: ${widget.guardian.licenseNumber ?? 'غير متوفر'}
''';
            Share.share(shareText, subject: 'مشاركة بيانات الأمين');
          },
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildActionIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}
