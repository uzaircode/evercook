part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initRecipe();
  _initIngredientWiki();

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

    //Bloc
    ..registerLazySingleton(
      () => RecipeBloc(
        uploadRecipe: serviceLocator(),
        getAllRecipes: serviceLocator(),
        deleteRecipe: serviceLocator(),
      ),
    );
}

void _initIngredientWiki() {
  // Datasource
  serviceLocator
    ..registerFactory<IngredientWikiRemoteDataSource>(
      () => IngredientWikiRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<IngredientWikiRepository>(
      () => IngredientWikiRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetAllIngredientWikiUseCase(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => IngredientWikiBloc(
        getAllIngredientsWiki: serviceLocator(),
      ),
    );
}
