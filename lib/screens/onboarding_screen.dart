// screens/onboarding_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/l10n_extensions.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../services/lens_data_service.dart';
import '../theme/neon_theme.dart';
import '../widgets/primary_gradient_button.dart';

/// Экран первого запуска: приветствие и возможность входа через Google
class OnboardingScreen extends StatefulWidget {
  final LensDataService dataService;
  final VoidCallback onComplete;

  const OnboardingScreen({
    Key? key,
    required this.dataService,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AuthService _auth = AuthService();
  final SyncService _sync = SyncService();

  bool _isLoading = false;
  String? _errorMessage;

  ColorScheme get _scheme => Theme.of(context).colorScheme;
  NeonThemeTokens get _neon => context.neon;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _auth.signInWithGoogle();
      if (user != null && mounted) {
        await _auth.setOnboardingCompleted();
        if (_sync.canSync) {
          try {
            final hasLocal = widget.dataService.hasLocalData();
            final hasCloud = await _sync.hasCloudData();
            if (hasLocal && hasCloud) {
              final choice = await _showSignInMigrationDialog();
              if (mounted && choice == 'local') {
                await _sync.pushToCloud(widget.dataService);
              } else if (mounted && choice == 'cloud') {
                await _sync.pullFromCloud(widget.dataService);
              }
            } else if (hasLocal && !hasCloud) {
              await _sync.pushToCloud(widget.dataService);
            } else if (!hasLocal && hasCloud) {
              await _sync.pullFromCloud(widget.dataService);
            }
          } catch (e) {
            debugPrint('Sign-in sync failed: $e');
          }
        }
        if (mounted) widget.onComplete();
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = context.l10n.onboardingSignInFailed(
            e.toString().split('\n').first,
          );
        });
      }
    }
  }

  Future<String?> _showSignInMigrationDialog() async {
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
              foregroundColor: _scheme.primary,
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

  void _skipAndContinue() async {
    await _auth.setSkippedAuth();
    await _auth.setOnboardingCompleted();
    if (mounted) {
      widget.onComplete();
    }
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required Widget child,
    double height = 52,
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: PrimaryGradientButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: (height - 22) / 2,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 360;
    final padding = isNarrowScreen ? 20.0 : 32.0;

    return Scaffold(
      backgroundColor: _neon.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Иконка профиля
              Container(
                width: isNarrowScreen ? 100 : 120,
                height: isNarrowScreen ? 100 : 120,
                decoration: BoxDecoration(
                  gradient: _neon.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _neon.glowColor.withValues(alpha: 0.45),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 56,
                  color: _neon.onPrimary,
                ),
              ),
              SizedBox(height: isNarrowScreen ? 24 : 32),
              Text(
                context.l10n.appName,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: _scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.onboardingSubtitle,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 14 : 16,
                  color: _scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 2),
              Text(
                context.l10n.onboardingSignInPrompt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isNarrowScreen ? 14 : 15,
                  color: _scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              _buildButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _neon.onPrimary,
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/google_logo.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              context.l10n.onboardingSignInGoogle,
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 15 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              _buildButton(
                onPressed: _isLoading ? null : _skipAndContinue,
                height: 60,
                child: Center(
                  child: Text(
                    context.l10n.onboardingContinueWithoutAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isNarrowScreen ? 15 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _scheme.error.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: _scheme.error,
                    ),
                  ),
                ),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}




