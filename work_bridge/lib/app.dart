import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

class WorkBridgeApp extends StatelessWidget {
  const WorkBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WorkBridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
