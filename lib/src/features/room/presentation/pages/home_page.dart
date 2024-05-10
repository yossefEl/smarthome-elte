import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stmart_home_elte/src/shared/presentation/components/responsive_view.dart';
import 'package:stmart_home_elte/src/shared/presentation/providers/conntectivity_providers.dart';

import '../providers/room_provider.dart';
import '../../../../core/theme/themes.dart';
import 'views/mobile_home_body.dart';
import 'views/simulator_view.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});
  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(roomsProvider.notifier).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(connectivityStreamProvider).when(
          error: (eror, str) => ref.read(connectivityStateProvider.notifier).state = false,
          data: (results) => ref.read(connectivityStateProvider.notifier).state = results.contains(ConnectivityResult.none),
          loading: () => null, //do nothing
        );

    final pageController = usePageController();
    return Scaffold(
      backgroundColor: AppColors.background,
      drawerScrimColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: false,
        leadingWidth: 56,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Youssef', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffA0A0A0),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const Icon(Icons.notifications, color: AppColors.primaryColor, size: 32),
          IconButton(
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.white, size: 28)),
          const SizedBox(width: 16),
        ],
      ),
      body: ResponsiveView(
          mobile: MobileHomePageBody(
            pageController: pageController,
          ),
          tablet: Row(
            children: [
              Expanded(
                flex: 1,
                child: MobileHomePageBody(
                  pageController: pageController,
                ),
              ),
              const Expanded(
                flex: 1,
                child: SimulatorView(),
              ),
            ],
          )),
    );
  }
}
