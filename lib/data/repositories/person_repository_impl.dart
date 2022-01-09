import 'package:rick_and_morty_app/core/error/exception.dart';
import 'package:rick_and_morty_app/core/platform/network_info.dart';
import 'package:rick_and_morty_app/data/datasource/person_local_data_source.dart';
import 'package:rick_and_morty_app/data/datasource/person_remote_data_source.dart';
import 'package:rick_and_morty_app/data/models/person_model.dart';
import 'package:rick_and_morty_app/domain/entities/person_entity.dart';
import 'package:rick_and_morty_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_app/domain/repositories/person_repositories.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return _getPersons(() => remoteDataSource.getAllPersons(page));
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return _getPersons(() => remoteDataSource.searchPerson(query));
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPerson) async {
    if (await networkInfo.isConneced) {
      try {
        final remotePerson = await getPerson();
        localDataSource.personToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPerson = await localDataSource.getLastPersonFromCache();
        return Right(localPerson);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
