import 'package:final_flutter/features/admin/data/model/agency/agency_complaints/paginated_agency_complaints/paginated_agency_complaints_model.dart';

abstract class AgencyComplaintsRepository {
  Future<PaginatedAgencyComplaints> getAgencyComplaints(
    int agencyId, {
    required int page,
    int perPage = 15,
  });
}
