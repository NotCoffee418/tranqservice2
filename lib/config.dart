import './models/route_config.dart';
import './screens/playlist_screen.dart';
import './screens/history_screen.dart';
import './screens/settings.screen.dart';

class Config {

  // Display name of the app
  static const String appName = 'TranqService2';

  // Name of working directory inside appdata or local share
  // let because unit tests need to set this
  static String workingDirName = 'TranqService2';

  // Define all routes in the TopNav
  static final List<RouteConfig> topNavRoutes = [
    RouteConfig(title: PlaylistScreen.title, screenBuilder: () => PlaylistScreen()),
    RouteConfig(title: HistoryScreen.title, screenBuilder: () => HistoryScreen()),
    RouteConfig(title: SettingsScreen.title, screenBuilder: () => SettingsScreen()),
  ];
}
