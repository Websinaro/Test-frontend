import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sos_provider.dart';
import '../theme/app_colors.dart';

class SosButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SosButton({super.key, required this.onPressed});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sos = context.watch<SosProvider>();
    final isActive = sos.status == SosStatus.active;
    final isSending = sos.status == SosStatus.sending;

    return GestureDetector(
      onTap: isSending ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final ringScale = isActive ? 1.0 + (_pulse.value * 0.5) : 1.0;
          final ringOpacity = isActive ? (1.0 - _pulse.value) * 0.5 : 0.0;

          return SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isActive)
                  Transform.scale(
                    scale: ringScale,
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.alertDarkRed.withValues(alpha: ringOpacity),
                      ),
                    ),
                  ),
                child!,
              ],
            ),
          );
        },
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.alertDarkRed : AppColors.alertRed,
            border: Border.all(color: AppColors.background, width: 4),
            boxShadow: [
              BoxShadow(
                color: (isActive ? AppColors.alertDarkRed : AppColors.alertRed).withValues(alpha: 0.5),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: isSending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                : Text(
                    isActive ? 'ACTIVE' : 'SOS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}