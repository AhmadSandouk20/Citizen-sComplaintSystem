import 'package:flutter/material.dart';

import '../../../../agencies/domain/entities/agency_entity.dart';
import '../../../../agencies/presentation/widgets/agency_selector.dart';

class AgencyStep extends StatelessWidget {
  final List<AgencyEntity> agencies;
  final AgencyEntity? selectedAgency;
  final ValueChanged<AgencyEntity> onSelected;

  const AgencyStep({
    super.key,
    required this.agencies,
    required this.selectedAgency,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'اختر الجهة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('اختر الجهة الحكومية التي تتعلق بها الشكوى'),
        const SizedBox(height: 24),

        AgencySelector(
          agencies: agencies,
          selectedAgency: selectedAgency,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
