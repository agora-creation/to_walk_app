import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/steps.dart';
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
  Future _open() async {
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();
    int? timestamp = await getPrefsInt('lastTime');
    if (timestamp != null) {
      startTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    await removePrefs('lastTime');
    if (startTime == endTime) return;
    await Permission.activityRecognition.request().isGranted;
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
    ];
    bool accessWasGranted = await health.requestAuthorization(types);
    List<HealthDataPoint> healthDataList = [];
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
      int stepsSum = 0;
      List<StepsModel> stepsList = [];
      for (var e in healthDataList) {
        String valueStr = e.value.toString();
        double valueDouble = double.parse(valueStr);
        stepsSum += valueDouble.round();
        StepsModel steps = StepsModel.fromMap({
          'id': randomString(24),
          'userId': widget.userProvider.user?.id ?? '',
          'stepsNum': valueDouble.round(),
          'updatedAt': e.dateTo,
          'createdAt': e.dateTo
        });
        stepsList.add(steps);
      }
      if (stepsList.isNotEmpty) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Center(child: Text('???????????????')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$stepsSum ????????????????????????????????????',
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ).then((value) async {
          await widget.stepsProvider.create(stepsList: stepsList);
        });
      }
    }
  }

  Future _close() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await setPrefsInt('lastTime', timestamp);
  }

  void _change(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await _close();
        break;
      case AppLifecycleState.paused:
        await _close();
        break;
      case AppLifecycleState.resumed:
        await _open();
        break;
      case AppLifecycleState.detached:
        await _close();
        break;
    }
  }

  void _init() async {
    await _open();
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
    _change(state);
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 0);
  }
}
