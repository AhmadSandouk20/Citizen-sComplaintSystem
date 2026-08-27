import 'package:flutter/material.dart';

import '../../domain/entities/agency_entity.dart';

class AgencySelector extends StatefulWidget {
  final List<AgencyEntity> agencies;
  final AgencyEntity? selectedAgency;
  final ValueChanged<AgencyEntity> onSelected;

  const AgencySelector({
    super.key,
    required this.agencies,
    required this.selectedAgency,
    required this.onSelected,
  });

  @override
  State<AgencySelector> createState() => _AgencySelectorState();
}

class _AgencySelectorState extends State<AgencySelector> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  List<AgencyEntity> get _filteredAgencies {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.agencies;
    }

    return widget.agencies.where((agency) {
      final name = agency.name.toLowerCase();
      final category = agency.category?.toLowerCase() ?? '';
      final city = agency.city?.toLowerCase() ?? '';

      return name.contains(query) ||
          category.contains(query) ||
          city.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final agencies = _filteredAgencies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'البحث عن جهة',
            hintText: 'اكتب اسم الجهة',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        if (agencies.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('لا توجد جهات مطابقة')),
          )
        else
          ...agencies.map(
            (agency) => _AgencyItem(
              agency: agency,
              selected: widget.selectedAgency?.id == agency.id,
              onTap: () {
                widget.onSelected(agency);
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _AgencyItem extends StatelessWidget {
  final AgencyEntity agency;
  final bool selected;
  final VoidCallback onTap;

  const _AgencyItem({
    required this.agency,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(selected ? Icons.check : Icons.account_balance_outlined),
        ),
        title: Text(agency.name),
        subtitle: _buildSubtitle(),
        trailing: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
        ),
      ),
    );
  }

  Widget? _buildSubtitle() {
    final values = <String>[
      if (agency.category?.isNotEmpty == true) agency.category!,
      if (agency.city?.isNotEmpty == true) agency.city!,
    ];

    if (values.isEmpty) {
      return null;
    }

    return Text(values.join(' • '));
  }
}
