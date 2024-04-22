part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initRecipe();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )

    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )

    //Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initRecipe() {
  // Datasource
  serviceLocator
    ..registerFactory<RecipeRemoteDataSource>(
      () => RecipeRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )

    //Repository
    ..registerFactory<RecipeRepository>(
      () => RecipeRepositoryImpl(
        serviceLocator(),
      ),
    )

    //Usecases
    ..registerFactory(
      () => UploadRecipe(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllRecipes(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteRecipe(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateRecipe(
        serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => RecipeBloc(
        uploadRecipe: serviceLocator(),
        getAllRecipes: serviceLocator(),
        deleteRecipe: serviceLocator(),
        updateRecipe: serviceLocator(),
      ),
    );
}
