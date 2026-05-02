import 'package:belajar_flutter_hit_api/services/api_service.dart';
import 'package:flutter/material.dart';

class ConsultationFormView extends StatefulWidget {
  final int? id;
  final String? name;
  final String? date;
  final String? poli;
  final String? complaint;

  const ConsultationFormView({
    super.key,
    this.id,
    this.name,
    this.date,
    this.poli,
    this.complaint,
  });

  @override
  State<ConsultationFormView> createState() => _ConsultationFormViewState();
}

class _ConsultationFormViewState extends State<ConsultationFormView> {
  final _nameController = TextEditingController();
  final _complaintController = TextEditingController();
  final ApiService apiService = ApiService();

  String? selectedPoli;
  DateTime? selectedDate;

  List<String> poliList = ["Poli Umum", "Poli Gigi", "Poli Anak", "Poli Kulit"];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _complaintController.text = widget.complaint ?? '';
    selectedPoli = widget.poli;
    if (widget.date != null) {
      selectedDate = DateTime.parse(widget.date!);
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submit() async {
    setState(() => isLoading = true);

    try {
      if (widget.id == null) {
        await apiService.createConsultations(
          _nameController.text,
          selectedDate!,
          selectedPoli!,
          _complaintController.text,
        );
      } else {
        await apiService.updateConsultation(
          widget.id!,
          _nameController.text,
          selectedDate!,
          selectedPoli!,
          _complaintController.text,
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Daftar Antrian' : 'Edit Antrian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama Pasien",
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Pilih Tanggal'
                        : selectedDate.toString().split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Pilih Poli",
                border: OutlineInputBorder(),
              ),
              value: selectedPoli,
              items: poliList.map((poli) {
                return DropdownMenuItem(value: poli, child: Text(poli));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPoli = value;
                });
              },
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _complaintController,
              decoration: const InputDecoration(
                labelText: "Keluhan",
                // border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading ? CircularProgressIndicator() : Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
