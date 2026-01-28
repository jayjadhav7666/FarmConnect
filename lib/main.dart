import 'package:farmconnect/presentation/screens/dashboard_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:farmconnect/injectable_init.dart';
import 'package:farmconnect/presentation/bloc/farmer_bloc.dart';
import 'package:farmconnect/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('farmers');
  await initServiceLocator();

  runApp(const FarmConnectApp());
}

class FarmConnectApp extends StatelessWidget {
  const FarmConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<FarmerBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const DashboardScreen(),
      ),
    );
  }
}
