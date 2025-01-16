import 'package:flutter/material.dart';
import 'inspectionform_view.dart';
import '../models/inspection_model.dart';
import '../services/inspection_service.dart';
import 'package:intl/intl.dart';
import 'inspectiondetails_view.dart';

class InspectionList extends StatefulWidget {
  const InspectionList({super.key});

  @override
  _InspectionListState createState() => _InspectionListState();
}

class _InspectionListState extends State<InspectionList> {
  List<Inspection> _inspections = [];

  @override
  void initState() {
    super.initState();
    _fetchInspections();
  }

  Future<void> _fetchInspections() async {
    final inspections = await InspectionService.readInspection();
    setState(() {
      _inspections = inspections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Inspections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchInspections,
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // Adjust the radius as needed
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _inspections.length,
        itemBuilder: (context, index) {
          final inspection = _inspections[index];
          return ListTile(
            title: Text(DateFormat('d-M-yyyy')
                .format(inspection.date)),
            subtitle: Text('Inspector: ${inspection.inspector}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InspectionDetailsView(inspection: inspection),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(inspection),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InspectionForm()))
              .then((_) => _fetchInspections());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(Inspection inspection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete ${inspection.date}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                String message =
                    await InspectionService.deleteInspection(inspection.id!);
                _fetchInspections();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
