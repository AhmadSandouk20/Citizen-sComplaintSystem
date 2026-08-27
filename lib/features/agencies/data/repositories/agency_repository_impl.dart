import '../../domain/entities/agency_entity.dart';
import '../../domain/repositories/agency_repository.dart';
import '../data_sources/agency_remote_data_source.dart';

class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyRemoteDataSource remoteDataSource;

  AgencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AgencyEntity>> getAgencies() {
    return remoteDataSource.getAgencies();
  }
}
