import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rick_and_morty_app/core/platform/network_info.dart';
import 'package:rick_and_morty_app/data/datasource/person_local_data_source.dart';
import 'package:rick_and_morty_app/data/datasource/person_remote_data_source.dart';
import 'package:rick_and_morty_app/data/repositories/person_repository_impl.dart';
import 'package:rick_and_morty_app/domain/repositories/person_repositories.dart';
import 'package:rick_and_morty_app/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty_app/domain/usecases/search_person.dart';
import 'package:rick_and_morty_app/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty_app/presentation/bloc/search_bloc/search_block.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));

  sl.registerFactory(() => GetAllPersons(sl()));
  sl.registerFactory(() => SearchPerson(sl()));

  sl.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<PersonRemoteDataSource>(
      () => PersonRemoteDataSourceImpl(client: http.Client()));
  sl.registerLazySingleton<PersonLocalDataSource>(
      () => PersonLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
