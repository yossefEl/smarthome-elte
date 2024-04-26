import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import 'package:stmart_home_elte/src/features/shared/presentation/providers/conntectivity_providers.dart';

import '../providers/room_provider.dart';
import '../../../../core/theme/themes.dart';
import '../components/energy_info_card.dart';
import '../components/device_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    final rooms = ref.watch(roomsProvider);
    final currentPage = useState(0);
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(builder: (context) {
          // ref.watch(roomsProvider).when(
          // loading: () => const Center(child: CircularProgressIndicator()),
          // error: (error, stack) => _buildWhenErrorWidget(),
          // data: (rooms) {
          if (rooms.isEmpty) {
            return _buildWhenErrorWidget();
          }
          return Column(
            children: [
              const TopHomeEneryInfoCard(),
              Expanded(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _buildTabViewBar(rooms, currentPage, pageController),
                    ),
                    Expanded(
                      child: PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            currentPage.value = index;
                          },
                          children: List.generate(rooms.length, (index) {
                            final room = rooms[index];
                            final devices = room.devices;
                            return Builder(builder: (context) {
                              return EasyRefresh(
                                onRefresh: () async {
                                  await ref.read(roomsProvider.notifier).get();
                                },
                                child: Builder(builder: (context) {
                                  return CustomScrollView(
                                    slivers: <Widget>[
                                      SliverToBoxAdapter(
                                        child: _buildRoomInfoCard(room, context),
                                      ),
                                      SliverPadding(
                                        padding: const EdgeInsets.only(top: 10),
                                        sliver: SliverMasonryGrid.count(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childCount: devices.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return DeviceInfoWidget(device: devices[index]);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            });
                          })),
                    )
                  ],
                ),
              )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRoomInfoCard(RoomModel room, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: AppTheme.primaryDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${room.name} current status",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 19), // const TextStyle(fontSize: 16, color: AppColors.text),
          ),
          Divider(color: Colors.grey.shade300),
          Text(
            room.description!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 16), // const TextStyle(fontSize: 16, color: AppColors.text),
          ),
          const SizedBox(height: 4),
          _buildRoomInfo(context, 'Brightness: ${room.brightness}%', FluentIcons.brightness_low_48_regular),
          _buildRoomInfo(context, 'Occupancy: ${room.occupancy}%', FluentIcons.person_28_regular),
          _buildRoomInfo(context, 'Oxygen Level: ${room.oxygenLevel}%', FluentIcons.table_freeze_column_16_filled),
          _buildRoomInfo(context, 'Temperature: ${room.temperature}°C', FluentIcons.temperature_24_regular),
        ],
      ),
    );
  }

  Widget _buildTabViewBar(List<RoomModel> rooms, ValueNotifier<int> currentPage, PageController pageController) {
    return SizedBox(
      height: 40,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          for (final room in rooms)
            Builder(builder: (context) {
              final selected = currentPage.value == rooms.indexOf(room);
              final selectedTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16); // const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

              final unselectedTextStyle = selectedTextStyle?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.normal,
                  fontSize: 16); // const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  showCheckmark: false,
                  selectedColor: AppColors.primaryColor,
                  onSelected: (selected) {
                    currentPage.value = rooms.indexOf(room);
                    pageController.animateToPage(
                      rooms.indexOf(room),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  label: Text(room.name!, style: selected ? selectedTextStyle : unselectedTextStyle),
                  selected: currentPage.value == rooms.indexOf(room),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRoomInfo(
    BuildContext context,
    String infoText,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 24)),
          const SizedBox(width: 8),
          Text(infoText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.text, fontSize: 16)), // const TextStyle(fontSize: 16, color: AppColors.text),
        ],
      ),
    );
  }

  SizedBox _buildWhenErrorWidget() {
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FluentIcons.info_48_regular, size: 48, color: AppColors.text),
          const Text('No rooms found', style: TextStyle(color: AppColors.text, fontSize: 16)),
          const SizedBox(height: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Refresh"),
            onPressed: () {
              ref.read(roomsProvider.notifier).get();
            },
          ),
        ],
      ),
    );
  }
}
