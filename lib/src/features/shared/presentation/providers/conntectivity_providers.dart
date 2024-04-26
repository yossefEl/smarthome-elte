import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStreamProvider = StreamProvider((ref) => Connectivity().onConnectivityChanged);
final connectivityStateProvider = StateProvider<bool>((ref) => false);
