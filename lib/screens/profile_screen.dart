import 'dart:async';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/domain_localization_extensions.dart';
import '../l10n/l10n_extensions.dart';
import '../services/lens_data_service.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../services/notification_service.dart';
import '../models/lens_data.dart';
import '../widgets/primary_gradient_button.dart';
import '../utils/intl_locale.dart';

class ProfileScreen extends StatefulWidget {
  final LensDataService dataService;
  final VoidCallback? onDataChanged;

  const ProfileScreen({
    Key? key,
    required this.dataService,
    this.onDataChanged,
  }) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late LensInfo _lensInfo;
  late List<VisionCheck> _visionChecks;
  late Map<String, dynamic> _cycleStatistics;

  final AuthService _auth = AuthService();
  final SyncService _sync = SyncService();
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _authSubscription = _auth.authStateChanges.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void refreshData() {
    setState(() {
      _loadData();
    });
  }

  void _loadData() {
    _lensInfo = widget.dataService.getLensInfo();
    _visionChecks = widget.dataService.getVisionChecks();
    _cycleStatistics = widget.dataService.getCycleStatistics();
  }

  @override
  Widget build(BuildContext context) {
    // рџџЎ РђР”РђРџРўРР’РќРћРЎРўР¬: РћРїСЂРµРґРµР»СЏРµРј СЂР°Р·РјРµСЂ СЌРєСЂР°РЅР°
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;
    final padding = isNarrowScreen ? 16.0 : 24.0;
    final dateFormattingLocale =
        intlDateFormattingLocale(Localizations.localeOf(context));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isNarrowScreen),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: padding,
                  bottom: 100,
                ),
                child: Column(
                  children: [
                    _buildAuthSection(isNarrowScreen),
                    const SizedBox(height: 20),
                    _buildStatisticsCards(isNarrowScreen),
                    const SizedBox(height: 20),
                    _buildLensDetails(
                        _lensInfo, isNarrowScreen, dateFormattingLocale),
                    const SizedBox(height: 20),
                    _buildVisionHistory(
                        _visionChecks, isNarrowScreen, dateFormattingLocale),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isNarrowScreen) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profileTitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.profileSubtitle,
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 11 : 12,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(0.82),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthSection(bool isNarrowScreen) {
    final isSignedIn = _auth.isSignedIn;
    final canSync = _sync.canSync;

    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLowest
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSignedIn ? Icons.cloud_done : Icons.cloud_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: isNarrowScreen ? 22 : 24,
              ),
              const SizedBox(width: 10),
              Text(
                context.l10n.profileAccount,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          if (isSignedIn) ...[
            Row(
              children: [
                if (_auth.photoUrl != null)
                  CircleAvatar(
                    radius: isNarrowScreen ? 18 : 22,
                    backgroundImage: NetworkImage(_auth.photoUrl!),
                  )
                else
                  Container(
                    width: (isNarrowScreen ? 36 : 44),
                    height: (isNarrowScreen ? 36 : 44),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                      size: isNarrowScreen ? 20 : 24,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _auth.displayName ?? context.l10n.profileUser,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_auth.userEmail != null)
                        Text(
                          _auth.userEmail!,
                          style: TextStyle(
                            fontSize: isNarrowScreen ? 11 : 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isNarrowScreen ? 12 : 16),
            Row(
              children: [
                if (canSync)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final errorMsg = await _sync.sync(widget.dataService);
                        if (mounted) {
                          setState(() => _loadData());
                          if (widget.onDataChanged != null) {
                            widget.onDataChanged!();
                          }
                          if (errorMsg != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${context.l10n.error}: $errorMsg'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      child: const Icon(Icons.sync, size: 18),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: const StadiumBorder(),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                if (canSync) const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showSignOutDialog(isNarrowScreen),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(context.l10n.profileSignOut),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              context.l10n.profileSignInHint,
              style: TextStyle(
                fontSize: isNarrowScreen ? 12 : 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: PrimaryGradientButton(
                onPressed: () => _showSignInDialog(isNarrowScreen),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login, size: 20),
                    SizedBox(width: 10),
                    Text(context.l10n.profileSignInGoogle),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSignInDialog(bool isNarrowScreen) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      ),
    );
    try {
      final user = await _auth.signInWithGoogle();
      if (mounted) Navigator.pop(context);
      if (user != null && mounted) {
        final hasLocal = widget.dataService.hasLocalData();
        final hasCloud = await _sync.hasCloudData();

        if (hasLocal && hasCloud) {
          final choice = await _showSignInMigrationDialog(isNarrowScreen);
          if (!mounted) return;
          if (choice == 'local') {
            await _sync.pushToCloud(widget.dataService);
          } else if (choice == 'cloud') {
            await _sync.pullFromCloud(widget.dataService);
          }
        } else if (hasLocal && !hasCloud) {
          await _sync.pushToCloud(widget.dataService);
        } else if (!hasLocal && hasCloud) {
          await _sync.pullFromCloud(widget.dataService);
        }

        setState(() {});
        if (widget.onDataChanged != null) widget.onDataChanged!();
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.profileSyncError(e.toString().split('\n').first),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<String?> _showSignInMigrationDialog(bool isNarrowScreen) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.onboardingDataConflictTitle),
        content: Text(context.l10n.onboardingDataConflictMessage),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cloud'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.onboardingUseCloudData),
          ),
          PrimaryGradientButton(
            onPressed: () => Navigator.pop(context, 'local'),
            child: Text(context.l10n.onboardingKeepDeviceData),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(bool isNarrowScreen) async {
    final hasLocal = widget.dataService.hasLocalData();
    if (!hasLocal) {
      await _auth.signOut();
      if (mounted) setState(() {});
      return;
    }
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.profileSignOutDataTitle),
        content: Text(
          context.l10n.profileSignOutDataMessage,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.profileDeleteFromDevice),
          ),
          PrimaryGradientButton(
            onPressed: () => Navigator.pop(context, 'keep'),
            child: Text(context.l10n.profileKeepOnDevice),
          ),
        ],
      ),
    );
    if (choice == 'delete') {
      await NotificationService().cancelAllNotifications();
      await widget.dataService.clearUserData();
      if (widget.onDataChanged != null) widget.onDataChanged!();
    }
    await _auth.signOut();
    if (mounted) setState(() {});
  }

  Widget _buildStatisticsCards(bool isNarrowScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildStatisticCard(
            icon: Icons.bar_chart_outlined,
            value: _cycleStatistics['totalCycles'].toString(),
            label: context.l10n.profileStatisticsTotalCycles,
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
            isNarrowScreen: isNarrowScreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatisticCard(
            icon: Icons.calendar_today_outlined,
            value: _cycleStatistics['averageDaysPerCycle'].toString(),
            label: context.l10n.profileStatisticsAverageDays,
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary],
            isNarrowScreen: isNarrowScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> colors,
    required bool isNarrowScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLowest
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: isNarrowScreen ? 36 : 40,
            height: isNarrowScreen ? 36 : 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                size: isNarrowScreen ? 20 : 22,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: isNarrowScreen ? 10 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isNarrowScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isNarrowScreen ? 11 : 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLensDetails(
      LensInfo lensInfo, bool isNarrowScreen, String dateFormattingLocale) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 20 : 24),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLowest
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.profileLensInfoTitle,
            style: TextStyle(
              fontSize: isNarrowScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          Container(
            padding: EdgeInsets.all(isNarrowScreen ? 14 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.profileLensType,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 12 : 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lensInfo.type.localizedLabel(context.l10n),
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lensInfo.type.days} ${context.l10n.dayWord(lensInfo.type.days)}',
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 11 : 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.visibility_outlined,
                  size: isNarrowScreen ? 28 : 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          _buildDetailRow(
              context.l10n.profileBrand, lensInfo.brand, isNarrowScreen),
          _buildDetailRow(
            context.l10n.profileWearingPeriod,
            '${lensInfo.type.days} ${context.l10n.dayWord(lensInfo.type.days)}',
            isNarrowScreen,
          ),
          _buildDetailRow(
            context.l10n.profileBaseCurve,
            '${lensInfo.bcLeft} mm / ${lensInfo.bcRight} mm',
            isNarrowScreen,
          ),
          _buildDetailRow(
            context.l10n.profileDiameter,
            '${lensInfo.diaLeft} mm / ${lensInfo.diaRight} mm',
            isNarrowScreen,
          ),
          if (lensInfo.firstUseDate != null)
            _buildDetailRow(
              context.l10n.profileFirstUseDate,
              DateFormat('d MMMM yyyy', dateFormattingLocale)
                  .format(lensInfo.firstUseDate!),
              isNarrowScreen,
            ),
          _buildVisionRow(isNarrowScreen),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryGradientButton(
              onPressed: () => _showEditLensDialog(),
              padding: EdgeInsets.symmetric(
                vertical: isNarrowScreen ? 16 : 18,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: isNarrowScreen ? 16 : 18),
                  SizedBox(width: isNarrowScreen ? 8 : 10),
                  Text(
                    context.l10n.profileChangeLensType,
                    style: TextStyle(fontSize: isNarrowScreen ? 14 : 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isNarrowScreen) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isNarrowScreen ? 12 : 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isNarrowScreen ? 12 : 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isNarrowScreen ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildVisionRow(bool isNarrowScreen) {
    if (_visionChecks.isEmpty) {
      return _buildDetailRow(context.l10n.profileVision,
          context.l10n.profileNoVisionData, isNarrowScreen);
    }
    final latest = _visionChecks.reduce(
      (a, b) => a.date.isAfter(b.date) ? a : b,
    );
    final leftStr = _formatVisionValue(
      latest.leftSph,
      latest.leftCyl,
      latest.leftAxis,
    );
    final rightStr = _formatVisionValue(
      latest.rightSph,
      latest.rightCyl,
      latest.rightAxis,
    );
    return _buildDetailRow(
      context.l10n.profileVision,
      '${context.l10n.calendarLeftEye}: $leftStr • ${context.l10n.calendarRightEye}: $rightStr',
      isNarrowScreen,
    );
  }

  Widget _buildVisionHistory(
    List<VisionCheck> visionChecks,
    bool isNarrowScreen,
    String dateFormattingLocale,
  ) {
    visionChecks.sort((a, b) => b.date.compareTo(a.date));

    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 20 : 24),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLowest
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.profileVisionCheckTitle,
            style: TextStyle(
              fontSize: isNarrowScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          if (visionChecks.isEmpty)
            _buildEmptyVisionState(isNarrowScreen)
          else
            ...visionChecks.map(
              (check) => _buildVisionEntry(
                  check, isNarrowScreen, dateFormattingLocale),
            ),
          SizedBox(height: isNarrowScreen ? 12 : 16),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isNarrowScreen ? 320 : 380,
              ),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryGradientButton(
                  onPressed: () => _showAddVisionCheckDialog(),
                  padding: EdgeInsets.symmetric(
                    vertical: isNarrowScreen ? 16 : 18,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: isNarrowScreen ? 16 : 18,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: isNarrowScreen ? 8 : 10),
                      Text(
                        context.l10n.profileAddCheck,
                        style: TextStyle(fontSize: isNarrowScreen ? 14 : 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyVisionState(bool isNarrowScreen) {
    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Theme.of(context).colorScheme.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.visibility_outlined,
            size: isNarrowScreen ? 36 : 40,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: isNarrowScreen ? 10 : 12),
          Text(
            context.l10n.profileNoVisionRecords,
            style: TextStyle(
              fontSize: isNarrowScreen ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isNarrowScreen ? 6 : 8),
          Text(
            context.l10n.profileAddFirstCheckHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isNarrowScreen ? 11 : 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVisionEntry(
    VisionCheck check,
    bool isNarrowScreen,
    String dateFormattingLocale,
  ) {
    final leftSph = _formatSph(check.leftSph);
    final leftAstig = _formatAstigmatism(check.leftCyl, check.leftAxis);
    final rightSph = _formatSph(check.rightSph);
    final rightAstig = _formatAstigmatism(check.rightCyl, check.rightAxis);

    return Container(
      padding: EdgeInsets.all(isNarrowScreen ? 14 : 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Theme.of(context).colorScheme.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  DateFormat('d MMMM yyyy', dateFormattingLocale)
                      .format(check.date),
                  style: TextStyle(
                    fontSize: isNarrowScreen ? 12 : 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat('HH:mm', dateFormattingLocale)
                          .format(check.date),
                      style: TextStyle(
                        fontSize: isNarrowScreen ? 10 : 11,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _confirmDeleteVisionCheck(check),
                    child: Icon(
                      Icons.close,
                      size: isNarrowScreen ? 18 : 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isNarrowScreen ? 10 : 12),
          Row(
            children: [
              Expanded(
                child: _buildEyeInfo(
                  context.l10n.calendarLeftEye,
                  leftSph,
                  leftAstig,
                  isNarrowScreen,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFE2E8F0),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildEyeInfo(
                  context.l10n.calendarRightEye,
                  rightSph,
                  rightAstig,
                  isNarrowScreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEyeInfo(String label, String sphText, String? astigmatismText,
      bool isNarrowScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility_outlined,
                size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isNarrowScreen ? 11 : 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          sphText,
          style: TextStyle(
            fontSize: isNarrowScreen ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          softWrap: true,
        ),
        if (astigmatismText != null && astigmatismText.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            astigmatismText,
            style: TextStyle(
              fontSize: isNarrowScreen ? 11 : 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
          ),
        ],
      ],
    );
  }

  String _formatSph(double sph) {
    return '${sph >= 0 ? '+' : ''}${sph.toStringAsFixed(2)}';
  }

  String? _formatAstigmatism(double? cyl, int? axis) {
    if (cyl != null && axis != null) {
      final cylText = '${cyl >= 0 ? '+' : ''}${cyl.toStringAsFixed(2)}';
      return '$cylText / $axisВ°';
    } else if (cyl != null) {
      final cylText = '${cyl >= 0 ? '+' : ''}${cyl.toStringAsFixed(2)}';
      return cylText;
    }
    return null;
  }

  String _formatVisionValue(double sph, double? cyl, int? axis) {
    final sphText = _formatSph(sph);
    final astig = _formatAstigmatism(cyl, axis);
    return astig != null ? '$sphText / $astig' : sphText;
  }

  Future<void> _confirmDeleteVisionCheck(VisionCheck check) async {
    final dateFormattingLocale =
        intlDateFormattingLocale(Localizations.localeOf(context));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(
          context.l10n.profileDeleteVisionCheckMessage(
            DateFormat('d.MM.yyyy', dateFormattingLocale).format(check.date),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: const StadiumBorder(),
              alignment: Alignment.center,
            ),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.dataService.deleteVisionCheck(check);
      setState(() {
        _visionChecks = widget.dataService.getVisionChecks();
      });
      if (widget.onDataChanged != null) {
        widget.onDataChanged!();
      }
    }
  }

  void _showEditLensDialog() {
    final lensInfo = widget.dataService.getLensInfo();
    LensType selectedType = lensInfo.type;
    final brandController = TextEditingController(text: lensInfo.brand);
    final bcLeftController =
        TextEditingController(text: lensInfo.bcLeft.toStringAsFixed(1));
    final bcRightController =
        TextEditingController(text: lensInfo.bcRight.toStringAsFixed(1));
    final diaLeftController =
        TextEditingController(text: lensInfo.diaLeft.toStringAsFixed(1));
    final diaRightController =
        TextEditingController(text: lensInfo.diaRight.toStringAsFixed(1));

    // рџџЎ РђР”РђРџРўРР’РќРћРЎРўР¬
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                context.l10n.profileLensSetup,
                style: TextStyle(fontSize: isNarrowScreen ? 18 : 20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.profileContactLensType,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: LensType.values.map((type) {
                        final isSelected = selectedType == type;
                        return InkWell(
                          onTap: () {
                            setDialogState(() {
                              selectedType = type;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isNarrowScreen ? 12 : 16,
                              vertical: isNarrowScreen ? 10 : 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  type.localizedLabel(context.l10n),
                                  style: TextStyle(
                                    fontSize: isNarrowScreen ? 12 : 13,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${type.days} ${context.l10n.dayWord(type.days)}',
                                  style: TextStyle(
                                    fontSize: isNarrowScreen ? 10 : 11,
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withOpacity(0.9)
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: brandController,
                      decoration: InputDecoration(
                        labelText: context.l10n.profileLensBrand,
                        labelStyle:
                            TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                        border: const OutlineInputBorder(),
                        hintText: context.l10n.profileLensBrandHint,
                        hintStyle:
                            TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                      ),
                      style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.profileBaseCurveWithCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: bcLeftController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l10n.profileLeftMm,
                              labelStyle:
                                  TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                              border: const OutlineInputBorder(),
                              hintText: '8.4',
                            ),
                            style:
                                TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: bcRightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l10n.profileRightMm,
                              labelStyle:
                                  TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                              border: const OutlineInputBorder(),
                              hintText: '8.4',
                            ),
                            style:
                                TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.profileDiameterWithCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isNarrowScreen ? 14 : 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: diaLeftController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l10n.profileLeftMm,
                              labelStyle:
                                  TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                              border: const OutlineInputBorder(),
                              hintText: '14.0',
                            ),
                            style:
                                TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: diaRightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: context.l10n.profileRightMm,
                              labelStyle:
                                  TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                              border: const OutlineInputBorder(),
                              hintText: '14.0',
                            ),
                            style:
                                TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withOpacity(0.16),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                      ),
                      child: Text(
                        context.l10n.profileLensTypeChangeWarning,
                        style: TextStyle(
                          fontSize: isNarrowScreen ? 11 : 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                    alignment: Alignment.center,
                  ),
                  child: Text(context.l10n.cancel),
                ),
                PrimaryGradientButton(
                  onPressed: () async {
                    final newInfo = LensInfo(
                      brand: brandController.text.trim().isEmpty
                          ? 'Acuvue Oasys'
                          : brandController.text,
                      type: selectedType,
                      bcLeft: double.tryParse(
                              bcLeftController.text.replaceAll(',', '.')) ??
                          8.4,
                      bcRight: double.tryParse(
                              bcRightController.text.replaceAll(',', '.')) ??
                          8.4,
                      diaLeft: double.tryParse(
                              diaLeftController.text.replaceAll(',', '.')) ??
                          14.0,
                      diaRight: double.tryParse(
                              diaRightController.text.replaceAll(',', '.')) ??
                          14.0,
                      firstUseDate: lensInfo.firstUseDate,
                    );

                    await widget.dataService.saveLensInfo(newInfo);

                    setState(() {
                      _lensInfo = newInfo;
                    });

                    if (widget.onDataChanged != null) {
                      widget.onDataChanged!();
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(context.l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddVisionCheckDialog() {
    final leftSphController = TextEditingController();
    final rightSphController = TextEditingController();
    final leftCylController = TextEditingController();
    final rightCylController = TextEditingController();
    final leftAxisController = TextEditingController();
    final rightAxisController = TextEditingController();

    // рџџў РџР РђР’РР›Рћ [file:12] 1.4: РџСЂРµРґР·Р°РїРѕР»РЅРµРЅРёРµ РёР· РїРѕСЃР»Рµdays РїСЂРѕРІРµСЂРєРё
    final lastCheck = _visionChecks.isNotEmpty ? _visionChecks.first : null;
    if (lastCheck != null) {
      leftSphController.text = lastCheck.leftSph.toStringAsFixed(2);
      rightSphController.text = lastCheck.rightSph.toStringAsFixed(2);
      if (lastCheck.leftCyl != null) {
        leftCylController.text = lastCheck.leftCyl!.toStringAsFixed(2);
      }
      if (lastCheck.rightCyl != null) {
        rightCylController.text = lastCheck.rightCyl!.toStringAsFixed(2);
      }
      if (lastCheck.leftAxis != null) {
        leftAxisController.text = lastCheck.leftAxis!.toString();
      }
      if (lastCheck.rightAxis != null) {
        rightAxisController.text = lastCheck.rightAxis!.toString();
      }
    }

    // рџџЎ РђР”РђРџРўРР’РќРћРЎРўР¬
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;

    showDialog(
      context: context,
      builder: (context) {
        final dateFormattingLocale =
            intlDateFormattingLocale(Localizations.localeOf(context));
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.l10n.profileVisionCheckTitle,
            style: TextStyle(fontSize: isNarrowScreen ? 18 : 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profileCheckDate,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isNarrowScreen ? 14 : 15,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('d MMMM yyyy, HH:mm', dateFormattingLocale)
                        .format(DateTime.now()),
                    style: TextStyle(
                      fontSize: isNarrowScreen ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.profileOpticalPowerSph,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isNarrowScreen ? 14 : 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: leftSphController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarLeftEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '-2.50',
                          prefixText: 'SPH: ',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: rightSphController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarRightEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '-2.75',
                          prefixText: 'SPH: ',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.profileCylinderCyl,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isNarrowScreen ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: leftCylController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarLeftEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '-0.75',
                          prefixText: 'CYL: ',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: rightCylController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarRightEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '-1.00',
                          prefixText: 'CYL: ',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.profileAxis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isNarrowScreen ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: leftAxisController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarLeftEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '180',
                          prefixText: 'AXIS: ',
                          suffixText: 'В°',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: rightAxisController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.l10n.calendarRightEye,
                          labelStyle:
                              TextStyle(fontSize: isNarrowScreen ? 12 : 13),
                          border: const OutlineInputBorder(),
                          hintText: '170',
                          prefixText: 'AXIS: ',
                          suffixText: 'В°',
                        ),
                        style: TextStyle(fontSize: isNarrowScreen ? 13 : 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EDDA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    context.l10n.profileAstigmatismHint,
                    style: TextStyle(
                      fontSize: isNarrowScreen ? 10 : 11,
                      color: const Color(0xFF155724),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: const StadiumBorder(),
                alignment: Alignment.center,
              ),
              child: Text(context.l10n.cancel),
            ),
            PrimaryGradientButton(
              onPressed: () async {
                // рџџў Р’РђР›РР”РђР¦РРЇ [file:12] 1.4
                final leftSph = double.tryParse(
                    leftSphController.text.replaceAll(',', '.'));
                final rightSph = double.tryParse(
                    rightSphController.text.replaceAll(',', '.'));
                final leftCyl = leftCylController.text.trim().isNotEmpty
                    ? double.tryParse(
                        leftCylController.text.replaceAll(',', '.'))
                    : null;
                final rightCyl = rightCylController.text.trim().isNotEmpty
                    ? double.tryParse(
                        rightCylController.text.replaceAll(',', '.'))
                    : null;
                final leftAxis = leftAxisController.text.trim().isNotEmpty
                    ? int.tryParse(leftAxisController.text)
                    : null;
                final rightAxis = rightAxisController.text.trim().isNotEmpty
                    ? int.tryParse(rightAxisController.text)
                    : null;

                if (leftSph == null || rightSph == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.profileFillSphError),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  return;
                }

                // рџџў Р’РђР›РР”РђР¦РРЇ: CYL в†’ AXIS РѕР±СЏР·Р°С‚РµР»РµРЅ
                if (leftCyl != null &&
                    (leftAxis == null || leftAxis < 0 || leftAxis > 180)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.profileLeftAxisError),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  return;
                }

                if (rightCyl != null &&
                    (rightAxis == null || rightAxis < 0 || rightAxis > 180)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.profileRightAxisError),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  return;
                }

                final check = VisionCheck(
                  date: DateTime.now(),
                  leftSph: leftSph,
                  rightSph: rightSph,
                  leftCyl: leftCyl,
                  rightCyl: rightCyl,
                  leftAxis: leftAxis,
                  rightAxis: rightAxis,
                );

                await widget.dataService.saveVisionCheck(check);

                setState(() {
                  _visionChecks = widget.dataService.getVisionChecks();
                });

                if (widget.onDataChanged != null) {
                  widget.onDataChanged!();
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
  }
}




