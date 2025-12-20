import 'package:flutter/material.dart';
import 'package:rollit/services/review.service.dart';

Future<void> showRateAppDialog(BuildContext context) async {
  if (!context.mounted) return;

  await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withAlpha(100),
    builder: (context) {
      return Dialog(
        backgroundColor: const Color.fromARGB(255, 53, 24, 87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⭐ Icon badge
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD36E), Color(0xFFFFB800)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                "Tu t’amuses sur RollIt? 🎲",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                "Une note aide énormément à faire grandir l’app\net à ajouter encore plus de fun ✨",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              // Actions
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      ReviewService.markAsPostponed();
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      "Plus tard",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 167.0),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF4FD8), Color(0xFF7C4DFF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                          await ReviewService.markAsAsked();
                          await ReviewService.requestReview();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Noter l’app ⭐",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
