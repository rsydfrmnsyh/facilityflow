import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inspection_model.dart';
import '../services/inspection_service.dart';

class InspectionForm extends StatefulWidget {
  final Inspection? inspection;

  const InspectionForm({super.key, this.inspection});

  @override
  _InspectionFormState createState() => _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  TextEditingController? inspector;
  TextEditingController? date;
  TextEditingController? facility;
  String? status;
  TextEditingController? details;

  @override
  void initState() {
    inspector = TextEditingController(
      text: widget.inspection == null ? '' : widget.inspection!.inspector,
    );
    date = TextEditingController(
      text: widget.inspection == null ? '' : DateFormat('d-M-yyyy').format(widget.inspection!.date),
    );
    facility = TextEditingController(
      text: widget.inspection == null ? '' : widget.inspection!.facility,
    );
    details = TextEditingController(
      text: widget.inspection == null ? '' : widget.inspection!.details,
    );
    status = widget.inspection?.status ?? 'good';
    super.initState();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (date!.text.isNotEmpty) {
      initialDate = DateFormat('d-M-yyyy').parse(date!.text);
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('d-M-yyyy').format(pickedDate);
      date!.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: inspector,
              decoration: InputDecoration(
                labelText: 'Inspector Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: GestureDetector(
              onTap: () => selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: date,
                  decoration: InputDecoration(
                    labelText: 'Inspection Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: DropdownButtonFormField<String>(
              value: facility?.text.isEmpty ?? true ? null : facility!.text,
              decoration: InputDecoration(
                labelText: 'Facility',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['Emergency Room', 'Nursery', 'Operating Theater', 'ICU', 'Pharmacy']
                  .map((facilityOption) => DropdownMenuItem<String>(
                        value: facilityOption,
                        child: Text(facilityOption),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  facility!.text = value ?? '';
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: DropdownButtonFormField<String>(
              value: status,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['good', 'bad']
                  .map((statusOption) => DropdownMenuItem<String>(
                        value: statusOption,
                        child: Text(statusOption),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  status = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: details,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Details',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                ),
                onPressed: () {
                  submitForm();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    Inspection inspectionData = Inspection(
      id: widget.inspection?.id,
      inspector: inspector!.text,
      date: DateFormat('d-M-yyyy').parse(date!.text),
      facility: facility!.text,
      status: status!,
      details: details!.text,
    );

    String message = await InspectionService.createInspection(inspectionData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context, 'save');
  }
}
