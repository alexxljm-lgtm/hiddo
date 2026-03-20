import 'dart:math';
import '../constants/word_pool.dart';

List<String> generateRandomItems({int count = 5}) {
  final random = Random();

  final shuffled = List<String>.from(wordPool)..shuffle(random);

  return shuffled.take(count).toList();
}