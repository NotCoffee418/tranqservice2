import './models/route_config.dart';
import './screens/playlist_screen.dart';
import './screens/history_screen.dart';
import './screens/settings.screen.dart';

class Config {

  static const String appName = 'TranqService2';

  // Define all routes in the TopNav
  static final List<RouteConfig> topNavRoutes = [
    RouteConfig(title: PlaylistScreen.title, screenBuilder: () => PlaylistScreen()),
    RouteConfig(title: HistoryScreen.title, screenBuilder: () => HistoryScreen()),
    RouteConfig(title: SettingsScreen.title, screenBuilder: () => SettingsScreen()),
  ];
}
