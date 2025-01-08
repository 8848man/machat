import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final cancelCompleterProvider = Provider<Completer<void>>((ref) {
  return Completer<void>();
});
