import 'package:evercook/core/secrets/app_secrets.dart';
import 'package:evercook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:evercook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:evercook/features/auth/domain/repositories/auth_repository.dart';
import 'package:evercook/features/auth/domain/usecases/user_sign_up.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // Datasource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  //Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  //Usecases
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  //Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
