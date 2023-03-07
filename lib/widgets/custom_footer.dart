import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
}

class CustomFooter extends StatefulWidget {
  final StepsProvider stepsProvider;
  final UserProvider userProvider;

  const CustomFooter({
    required this.stepsProvider,
    required this.userProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter>
    with WidgetsBindingObserver {
  Future<int> openApp() async {
    int steps = 0;
    List<HealthDataPoint> healthDataList = [];
    await Permission.activityRecognition.request().isGranted;
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();
    int? lastTime = await getPrefsInt('lastTime');
    if (lastTime != null) {
      startTime = DateTime.fromMillisecondsSinceEpoch(lastTime);
    }
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
    ];
    bool accessWasGranted = await health.requestAuthorization(types);
    if (accessWasGranted) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startTime,
          endTime,
          types,
        );
        healthDataList.addAll(healthData);
      } catch (e) {
        if (kDebugMode) {
          print('Caught exception in getHealthDataFromTypes: $e');
        }
      }
      healthDataList = HealthFactory.removeDuplicates(healthDataList);
      for (var e in healthDataList) {
        steps += e.value.hashCode;
      }
    }
    await removePrefs('lastTime');
    return steps;
  }

  Future closeApp() async {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    await setPrefsInt('lastTime', nowTimestamp);
  }

  void changeApp(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await closeApp();
        break;
      case AppLifecycleState.paused:
        await closeApp();
        break;
      case AppLifecycleState.resumed:
        int getSteps = await openApp();
        if (getSteps != 0) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Center(child: Text('お疲れ様！')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$getSteps 歩の運動を計測しました。本アプリに加算します。',
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(),
                ],
              ),
            ),
          );
          widget.stepsProvider.create(
            user: widget.userProvider.user!,
            stepsNum: getSteps,
          );
        }
        break;
      case AppLifecycleState.detached:
        await closeApp();
        break;
    }
  }

  void _init() async {
    int getSteps = await openApp();
    if (getSteps != 0) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Center(child: Text('お疲れ様！')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$getSteps 歩の運動を計測しました。本アプリに加算します。',
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Container(),
            ],
          ),
        ),
      );
      widget.stepsProvider.create(
        user: widget.userProvider.user!,
        stepsNum: getSteps,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    changeApp(state);
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 0);
  }
}
