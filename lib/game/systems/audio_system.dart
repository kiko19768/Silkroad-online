import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/game/game_engine.dart';

class AudioSystem extends Component with HasGameRef<GameEngine> {
  // Audio settings
  double musicVolume = 0.5;
  double sfxVolume = 0.7;
  bool isMusicEnabled = true;
  bool isSfxEnabled = true;
  
  // Current music
  String? currentMusic;
  
  // Audio pools
  final Map<String, int> _sfxPools = {};
  
  // Current ambient and weather sounds
  String? currentAmbientSound;
  String? currentWeatherSound;
  
  // Audio settings
  static const int maxPoolSize = 5;
  static const int maxConcurrentSfx = 8;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load settings from app config
    musicVolume = AppConfig.musicVolume;
    sfxVolume = AppConfig.sfxVolume;
    isMusicEnabled = AppConfig.isMusicEnabled;
    isSfxEnabled = AppConfig.isSfxEnabled;
    
    // Initialize audio pools
    _initializeAudioPools();
    
    // Preload common sound effects
    await _preloadCommonSfx();
  }
  
  void _initializeAudioPools() {
    // Create pools for common sound effects
    _sfxPools['attack'] = 0;
    _sfxPools['hit'] = 0;
    _sfxPools['skill'] = 0;
    _sfxPools['levelUp'] = 0;
    _sfxPools['death'] = 0;
    _sfxPools['portal'] = 0;
    _sfxPools['item'] = 0;
    _sfxPools['button'] = 0;
  }
  
  Future<void> _preloadCommonSfx() async {
    // Preload common sound effects
    await FlameAudio.audioCache.loadAll([
      'sfx/attack.mp3',
      'sfx/hit.mp3',
      'sfx/skill.mp3',
      'sfx/level_up.mp3',
      'sfx/death.mp3',
      'sfx/portal.mp3',
      'sfx/item.mp3',
      'sfx/button.mp3',
    ]);
  }
  
  // Play background music
  void playBackgroundMusic(String musicPath) {
    if (!isMusicEnabled) return;
    
    // Stop current music if playing
    if (currentMusic != null) {
      FlameAudio.bgm.stop();
    }
    
    // Play new music
    FlameAudio.bgm.play(musicPath, volume: musicVolume);
    currentMusic = musicPath;
  }
  
  // Stop background music
  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
    currentMusic = null;
  }
  
  // Pause background music
  void pauseBackgroundMusic() {
    FlameAudio.bgm.pause();
  }
  
  // Resume background music
  void resumeBackgroundMusic() {
    if (!isMusicEnabled || currentMusic == null) return;
    
    FlameAudio.bgm.resume();
  }
  
  // Set music volume
  void setMusicVolume(double volume) {
    musicVolume = volume.clamp(0.0, 1.0);
    FlameAudio.bgm.audioPlayer.setVolume(musicVolume);
    
    // Save to app config
    AppConfig.musicVolume = musicVolume;
  }
  
  // Set SFX volume
  void setSfxVolume(double volume) {
    sfxVolume = volume.clamp(0.0, 1.0);
    
    // Save to app config
    AppConfig.sfxVolume = sfxVolume;
  }
  
  // Enable/disable music
  void toggleMusic(bool enabled) {
    isMusicEnabled = enabled;
    
    if (isMusicEnabled) {
      resumeBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
    
    // Save to app config
    AppConfig.isMusicEnabled = isMusicEnabled;
  }
  
  // Enable/disable SFX
  void toggleSfx(bool enabled) {
    isSfxEnabled = enabled;
    
    // Save to app config
    AppConfig.isSfxEnabled = isSfxEnabled;
  }
  
  // Play sound effect
  void playSfx(String sfxPath) {
    if (!isSfxEnabled) return;
    
    // Check if pool exists
    final String sfxName = sfxPath.split('/').last.split('.').first;
    if (_sfxPools.containsKey(sfxName)) {
      // Check if pool is full
      if (_sfxPools[sfxName]! >= maxPoolSize) {
        return;
      }
      
      // Increment pool count
      _sfxPools[sfxName] = _sfxPools[sfxName]! + 1;
      
      // Play sound effect
      FlameAudio.play(
        sfxPath,
        volume: sfxVolume,
      ).then((_) {
        // Decrement pool count
        _sfxPools[sfxName] = _sfxPools[sfxName]! - 1;
      });
    } else {
      // Play sound effect without pooling
      FlameAudio.play(
        sfxPath,
        volume: sfxVolume,
      );
    }
  }
  
  // Play attack sound
  void playAttackSound() {
    playSfx('sfx/attack.mp3');
  }
  
  // Play hit sound
  void playHitSound() {
    playSfx('sfx/hit.mp3');
  }
  
  // Play skill sound
  void playSkillSound(String skillId) {
    // Check if skill has custom sound
    final String sfxPath = 'sfx/skills/$skillId.mp3';
    
    // Play sound effect
    playSfx(sfxPath);
  }
  
  // Play level up sound
  void playLevelUpSound() {
    playSfx('sfx/level_up.mp3');
  }
  
  // Play death sound
  void playDeathSound() {
    playSfx('sfx/death.mp3');
  }
  
  // Play portal sound
  void playPortalSound() {
    playSfx('sfx/portal.mp3');
  }
  
  // Play item sound
  void playItemSound() {
    playSfx('sfx/item.mp3');
  }
  
  // Play button sound
  void playButtonSound() {
    playSfx('sfx/button.mp3');
  }
  
  // Weather and environment sounds
  
  // Play weather sound
  void playWeatherSound(String weatherType, {double volume = 1.0}) {
    if (!isSfxEnabled) return;
    
    // Stop current weather sound if playing
    stopWeatherSound();
    
    // Play new weather sound
    final String weatherPath = 'sfx/weather/${weatherType}.mp3';
    FlameAudio.loopLongAudio(weatherPath, volume: sfxVolume * volume);
    currentWeatherSound = weatherType;
  }
  
  // Stop weather sound
  void stopWeatherSound() {
    if (currentWeatherSound != null) {
      FlameAudio.stopLongAudio('sfx/weather/${currentWeatherSound!}.mp3');
      currentWeatherSound = null;
    }
  }
  
  // Update weather sound volume
  void updateWeatherSoundVolume(double intensity) {
    if (currentWeatherSound != null && isSfxEnabled) {
      FlameAudio.audioLongPlayers[currentWeatherSound!]?.setVolume(sfxVolume * intensity);
    }
  }
  
  // Play thunder sound
  void playThunderSound() {
    if (!isSfxEnabled) return;
    
    // Random thunder sound (1-3)
    final int thunderNum = 1 + (DateTime.now().millisecondsSinceEpoch % 3);
    playSfx('sfx/weather/thunder_${thunderNum}.mp3');
  }
  
  // Play ambient sound
  void playAmbientSound(String ambientType) {
    if (!isSfxEnabled) return;
    
    // Stop current ambient sound if playing
    stopAmbientSound();
    
    // Play new ambient sound
    final String ambientPath = 'sfx/ambient/${ambientType}.mp3';
    FlameAudio.loopLongAudio(ambientPath, volume: sfxVolume * 0.3);
    currentAmbientSound = ambientType;
  }
  
  // Stop ambient sound
  void stopAmbientSound() {
    if (currentAmbientSound != null) {
      FlameAudio.stopLongAudio('sfx/ambient/${currentAmbientSound!}.mp3');
      currentAmbientSound = null;
    }
  }
  
  // Update ambient sound volume
  void updateAmbientSoundVolume(double volume) {
    if (currentAmbientSound != null && isSfxEnabled) {
      FlameAudio.audioLongPlayers[currentAmbientSound!]?.setVolume(sfxVolume * volume);
    }
  }
}