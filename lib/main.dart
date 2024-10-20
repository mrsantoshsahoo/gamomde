import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const FullScreenApp());
}

class FullScreenApp extends StatelessWidget {
  const FullScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Start hide control center, home bar
    // MsFullScreen.enterFullScreen();
    /// Start Full screen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    /// Exit Full screen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    /// Start DeviceOrientation landscape
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    /// Start DeviceOrientation portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Screen Mode Example'),backgroundColor: Colors.indigo,),
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => MsFullScreen.enterFullScreen(msType: MsType.top),
              child: const Text('Hide Top Edge'),
            ),
            ElevatedButton(
              onPressed: () =>
                  MsFullScreen.enterFullScreen(msType: MsType.bottom),
              child: const Text('Hide Bottom Edge'),
            ),
            ElevatedButton(
              onPressed: () => MsFullScreen.enterFullScreen(),
              child: const Text('Hide Both Edges'),
            ),
          ],
        ),
      ),
    );
  }
}

enum MsType { top, bottom, both }

class MsFullScreen {
  static const platform = MethodChannel('ms_full_screen_mode');

  static Future<void> enterFullScreen({MsType msType = MsType.both}) async {
    try {
      await platform.invokeMethod('enterFullScreen', {'edge': msType.name});
    } on PlatformException catch (e) {
      debugPrint("Failed to enter full screen: '${e.message}'.");
    }
  }
}
