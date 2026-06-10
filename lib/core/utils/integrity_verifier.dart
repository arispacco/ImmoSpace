import 'dart:convert';
import 'package:flutter/material.dart';

class IntegrityVerifier {
  // Base64 encoded credentials to make it harder to detect via simple global search in text editor
  // QXJpc3RpZGU= is Base64 for "Aristide"
  static const String _signatureBase64 = "QXJpc3RpZGU=";
  
  // SHA-256 style mock hash validating project fingerprint
  static const String projectFingerprint = "5A8F71E86E2B961D02E5C8A79B3298CD483D8AA0A30B";

  static String get developerName {
    try {
      return utf8.decode(base64.decode(_signatureBase64));
    } catch (_) {
      return "Aristide";
    }
  }

  /// Verifies a search query or input code to unlock the hidden proof of work.
  static bool verifySecretCode(String code) {
    final cleanCode = code.trim().toLowerCase();
    return cleanCode == '/verify-owner-aristide' ||
           cleanCode == 'aristide-immospace-2026' ||
           cleanCode == 'show-developer';
  }

  /// Displays the premium authorship certificate modal
  static void showAuthorshipCertificate(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Certificate',
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1E30), Color(0xFF0F0F16)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF00E6FF).withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E6FF).withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Holographic Badge Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00E6FF).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF00E6FF), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF00E6FF),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  const Text(
                    'CERTIFICATE OF ORIGINALITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Divider
                  Container(
                    height: 1,
                    width: 100,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 20),
                  
                  // Body Certificate Text
                  Text(
                    'This is to certify that the architecture, layout, logic design, and source code of the ImmoSpace Application belong exclusively to the original creator:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Creator Name (Decoded dynamically)
                  Text(
                    developerName.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF8A84FF),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Color(0xFF8A84FF),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Meta Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildMetaRow('System Name', 'ImmoSpace Mobile v1.0'),
                        const SizedBox(height: 6),
                        _buildMetaRow('Ownership Hash', projectFingerprint.substring(0, 16) + '...'),
                        const SizedBox(height: 6),
                        _buildMetaRow('Status', 'Original Author Verified'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dismiss button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E6FF).withOpacity(0.15),
                        foregroundColor: const Color(0xFF00E6FF),
                        side: const BorderSide(color: Color(0xFF00E6FF), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close Verification',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
