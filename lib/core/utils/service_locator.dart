import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:arabic_mmorpg/core/network/api_client.dart';
import 'package:arabic_mmorpg/core/network/websocket_client.dart';
import 'package:arabic_mmorpg/data/datasources/auth_data_source.dart';
import 'package:arabic_mmorpg/data/datasources/character_data_source.dart';
import 'package:arabic_mmorpg/data/datasources/game_data_source.dart';
import 'package:arabic_mmorpg/data/repositories/auth_repository_impl.dart';
import 'package:arabic_mmorpg/data/repositories/character_repository_impl.dart';
import 'package:arabic_mmorpg/data/repositories/game_repository_impl.dart';
import 'package:arabic_mmorpg/domain/repositories/auth_repository.dart';
import 'package:arabic_mmorpg/domain/repositories/character_repository.dart';
import 'package:arabic_mmorpg/domain/repositories/game_repository.dart';
import 'package:arabic_mmorpg/domain/usecases/auth/login_usecase.dart';
import 'package:arabic_mmorpg/domain/usecases/auth/register_usecase.dart';
import 'package:arabic_mmorpg/domain/usecases/auth/logout_usecase.dart';
import 'package:arabic_mmorpg/domain/usecases/character/create_character_usecase.dart';
import 'package:arabic_mmorpg/domain/usecases/character/get_characters_usecase.dart';
import 'package:arabic_mmorpg/domain/usecases/game/connect_to_game_usecase.dart';
import 'package:arabic_mmorpg/presentation/bloc/auth/auth_bloc.dart';
import 'package:arabic_mmorpg/presentation/bloc/character/character_bloc.dart';
import 'package:arabic_mmorpg/presentation/bloc/game/game_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  
  sl.registerSingleton<Dio>(Dio());
  
  // Core
  sl.registerSingleton<ApiClient>(ApiClient(sl<Dio>()));
  sl.registerSingleton<WebSocketClient>(WebSocketClient());
  
  // Data sources
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(
    apiClient: sl<ApiClient>(),
    sharedPreferences: sl<SharedPreferences>(),
  ));
  
  sl.registerSingleton<CharacterDataSource>(CharacterDataSourceImpl(
    apiClient: sl<ApiClient>(),
  ));
  
  sl.registerSingleton<GameDataSource>(GameDataSourceImpl(
    apiClient: sl<ApiClient>(),
    webSocketClient: sl<WebSocketClient>(),
  ));
  
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    authDataSource: sl<AuthDataSource>(),
  ));
  
  sl.registerSingleton<CharacterRepository>(CharacterRepositoryImpl(
    characterDataSource: sl<CharacterDataSource>(),
  ));
  
  sl.registerSingleton<GameRepository>(GameRepositoryImpl(
    gameDataSource: sl<GameDataSource>(),
  ));
  
  // Use cases
  sl.registerSingleton<LoginUseCase>(LoginUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(
    authRepository: sl<AuthRepository>(),
  ));
  
  sl.registerSingleton<CreateCharacterUseCase>(CreateCharacterUseCase(
    characterRepository: sl<CharacterRepository>(),
  ));
  
  sl.registerSingleton<GetCharactersUseCase>(GetCharactersUseCase(
    characterRepository: sl<CharacterRepository>(),
  ));
  
  sl.registerSingleton<ConnectToGameUseCase>(ConnectToGameUseCase(
    gameRepository: sl<GameRepository>(),
  ));
  
  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(
    loginUseCase: sl<LoginUseCase>(),
    registerUseCase: sl<RegisterUseCase>(),
    logoutUseCase: sl<LogoutUseCase>(),
  ));
  
  sl.registerFactory<CharacterBloc>(() => CharacterBloc(
    createCharacterUseCase: sl<CreateCharacterUseCase>(),
    getCharactersUseCase: sl<GetCharactersUseCase>(),
  ));
  
  sl.registerFactory<GameBloc>(() => GameBloc(
    connectToGameUseCase: sl<ConnectToGameUseCase>(),
  ));
}