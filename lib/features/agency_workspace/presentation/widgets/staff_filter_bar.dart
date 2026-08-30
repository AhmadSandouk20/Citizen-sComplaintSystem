import 'package:flutter/material.dart';

class StaffFilterBar extends StatefulWidget {
  final String initialStatus;
  final String initialPriority;
  final String initialDateFrom;
  final String initialDateTo;

  final void Function({
    required String status,
    required String priority,
    required String dateFrom,
    required String dateTo,
  })
  onApply;

  final VoidCallback onClear;

  const StaffFilterBar({
    super.key,
    required this.initialStatus,
    required this.initialPriority,
    required this.initialDateFrom,
    required this.initialDateTo,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<StaffFilterBar> createState() => _StaffFilterBarState();
}

class _StaffFilterBarState extends State<StaffFilterBar> {
  String _status = '';
  String _priority = '';

  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();

    _status = widget.initialStatus;
    _priority = widget.initialPriority;

    _dateFrom = DateTime.tryParse(widget.initialDateFrom);

    _dateTo = DateTime.tryParse(widget.initialDateTo);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _dateFrom : _dateTo;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      if (isFrom) {
        _dateFrom = picked;
      } else {
        _dateTo = picked;
      }
    });
  }

  void _clear() {
    setState(() {
      _status = '';
      _priority = '';
      _dateFrom = null;
      _dateTo = null;
    });

    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'الحالة',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('كل الحالات')),
                  DropdownMenuItem(value: 'new', child: Text('جديدة')),
                  DropdownMenuItem(
                    value: 'in_progress',
                    child: Text('قيد المعالجة'),
                  ),
                  DropdownMenuItem(value: 'resolved', child: Text('تم الحل')),
                  DropdownMenuItem(value: 'rejected', child: Text('مرفوضة')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value ?? '';
                  });
                },
              ),
            ),

            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: 'الأولوية',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('كل الأولويات')),
                  DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                  DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
                  DropdownMenuItem(value: 'high', child: Text('عالية')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value ?? '';
                  });
                },
              ),
            ),

            OutlinedButton.icon(
              onPressed: () {
                _pickDate(isFrom: true);
              },
              icon: const Icon(Icons.date_range),
              label: Text(
                _dateFrom == null ? 'من تاريخ' : _formatDate(_dateFrom),
              ),
            ),

            OutlinedButton.icon(
              onPressed: () {
                _pickDate(isFrom: false);
              },
              icon: const Icon(Icons.date_range),
              label: Text(_dateTo == null ? 'إلى تاريخ' : _formatDate(_dateTo)),
            ),

            FilledButton.icon(
              onPressed: () {
                widget.onApply(
                  status: _status,
                  priority: _priority,
                  dateFrom: _formatDate(_dateFrom),
                  dateTo: _formatDate(_dateTo),
                );
              },
              icon: const Icon(Icons.filter_alt),
              label: const Text('تطبيق'),
            ),

            TextButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.clear),
              label: const Text('مسح الفلاتر'),
            ),
          ],
        ),
      ),
    );
  }
}
