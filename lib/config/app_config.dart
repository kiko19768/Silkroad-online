class AppConfig {
  // App information
  static const String appName = 'الفتح: طريق الانتقام';
  static const String appVersion = '0.1.0';
  
  // API endpoints
  static const String apiBaseUrl = 'https://api.arabic-mmorpg.com';
  static const String wsBaseUrl = 'wss://ws.arabic-mmorpg.com';
  
  // Game settings
  static const int defaultFps = 60;
  static const double defaultVolume = 0.7;
  
  // Cache settings
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB
  
  // Authentication
  static const int sessionTimeoutMinutes = 60;
  static const int pinLength = 6;
  
  // Game mechanics
  static const int maxPlayerLevel = 100;
  static const int maxSkillLevel = 10;
  static const int maxGuildLevel = 20;
  static const int maxInventorySlots = 100;
  static const int maxEquipmentSlots = 12;
  
  // Performance
  static const bool enableHighQualityGraphics = true;
  static const bool enableShadows = true;
  static const bool enableParticleEffects = true;
  
  // Debug
  static const bool enableDebugInfo = false;
  static const bool enablePerformanceMonitoring = false;
}