import '../entities/agency_entity.dart';

abstract class AgencyRepository {
  Future<List<AgencyEntity>> getAgencies();
}
