import 'package:evercook/core/secrets/app_secrets.dart';
import 'package:evercook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:evercook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:evercook/features/auth/domain/repository/auth_repository.dart';
import 'package:evercook/features/auth/domain/usecases/user_sign_up.dart';
import 'package:evercook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
