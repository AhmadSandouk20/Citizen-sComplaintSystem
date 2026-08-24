import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';
import 'package:final_flutter/features/admin/data/model/agency/paginated_agencies_model/paginated_agencies_model.dart';

abstract class AgencyRepository {
  Future<PaginatedAgencies> getAgencies({int page = 1, int perPage = 15});
  Future<AgencyModel> getAgencyDetails(int id);
  Future<AgencyModel> addAgency(AgencyModel newAgency);
  Future<AgencyModel> updateAgency(int id, AgencyModel updatedModel);

  Future<void> deleteAgency(int id);
}
