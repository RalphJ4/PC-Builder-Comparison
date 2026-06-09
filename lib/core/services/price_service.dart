import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/price_snapshot.dart';
import 'local_mock_data.dart';

class PriceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PriceSnapshot>> getPriceHistory(String componentId) async {
    try {
      final snap = await _firestore
          .collection('price_history')
          .doc(componentId)
          .collection('snapshots')
          .orderBy('recordedAt', descending: true)
          .limit(50)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        return PriceSnapshot(
          shopee: (data['shopee'] as num?)?.toDouble(),
          lazada: (data['lazada'] as num?)?.toDouble(),
          manila: (data['manila'] as num?)?.toDouble(),
          manilaStoreName: data['manilaStore'] as String? ?? '',
          timestamp: (data['recordedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAlerts({String? type}) async {
    try {
      Query query = _firestore
          .collection('alerts')
          .orderBy('createdAt', descending: true)
          .limit(100);

      if (type != null && type != 'all') {
        query = query.where('type', isEqualTo: type);
      }

      final snap = await query.get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id;
          return data;
        }).toList();
      }
    } catch (_) {}

    final all = LocalMockData.getAlerts();
    if (type == null || type == 'all') return all;
    return all.where((a) => a['type'] == type).toList();
  }

  Future<List<Map<String, dynamic>>> getAllComponents() async {
    try {
      final snapshot = await _firestore
          .collection('price_history')
          .limit(50)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data() as Map);
          data['id'] = doc.id;
          return data;
        }).toList();
      }
    } catch (_) {}

    return LocalMockData.getComponents();
  }

  Future<void> toggleWatchlistLocally(String key, Map<String, dynamic> component) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList('watchlist') ?? [];
    final existing = json.indexWhere((e) => e.contains(key));
    if (existing >= 0) {
      json.removeAt(existing);
    } else {
      json.add(jsonEncode(component));
    }
    await prefs.setStringList('watchlist', json);
  }

  Future<bool> isWatchedLocally(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList('watchlist') ?? [];
    return json.any((e) => e.contains(key));
  }

  Future<List<String>> getWatchedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList('watchlist') ?? [];
    return json.map((e) {
      try {
        final m = jsonDecode(e) as Map<String, dynamic>;
        return m['id'] as String? ?? '';
      } catch (_) {
        return '';
      }
    }).where((id) => id.isNotEmpty).toList();
  }
}
