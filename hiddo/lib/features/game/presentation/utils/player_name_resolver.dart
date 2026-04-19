import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlayerNameResolver {
  static final Map<String, String> _cache = {};

  static Future<String> resolve(String userId) async {
    final cached = _cache[userId];
    if (cached != null && cached.isNotEmpty) return cached;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid == userId) {
      final ownName = currentUser.displayName?.trim();
      if (ownName != null && ownName.isNotEmpty) {
        _cache[userId] = ownName;
        return ownName;
      }
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final displayName = snapshot.data()?['displayName'] as String?;

      if (displayName != null && displayName.trim().isNotEmpty) {
        _cache[userId] = displayName.trim();
        return displayName.trim();
      }
    } catch (_) {
      // Si no hay permisos de lectura o el doc no existe, devolvemos uid.
    }

    return userId;
  }
}
