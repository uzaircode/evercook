part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initRecipe();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  serviceLocator.registerLazySingleton(() => firebase);
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerLazySingleton(() => ThemeTestBloc());
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
      () => UserSignUpUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLoginUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUserUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SignOutUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RecoverPasswordUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUserUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SignInWithGoogleUseCase(
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
        signOut: serviceLocator(),
        recoverPassword: serviceLocator(),
        updateUser: serviceLocator(),
        signInWithGoogle: serviceLocator(),
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
      () => UploadRecipeUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllRecipesUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteRecipeUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditRecipeUseCase(
        serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => RecipeBloc(
        uploadRecipe: serviceLocator(),
        getAllRecipes: serviceLocator(),
        deleteRecipe: serviceLocator(),
        editRecipe: serviceLocator(),
      ),
    );
}
