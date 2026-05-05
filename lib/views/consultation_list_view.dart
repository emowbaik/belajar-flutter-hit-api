import 'package:belajar_flutter_hit_api/models/consultation.dart';
import 'package:belajar_flutter_hit_api/services/api_service.dart';
import 'package:belajar_flutter_hit_api/views/consultation_form_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultationListView extends StatefulWidget {
  const ConsultationListView({super.key});

  @override
  State<ConsultationListView> createState() => _ConsultationListViewState();
}

class _ConsultationListViewState extends State<ConsultationListView> {
  final ApiService apiService = ApiService();
  late Future<List<Consultation>> consultations;

  @override
  void initState() {
    super.initState();

    consultations = apiService.getConsultations();
  }

  void refreshData() {
    setState(() {
      consultations = apiService.getConsultations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Antrian Klinik')),
      body: FutureBuilder<List<Consultation>>(
        future: consultations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                child: ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(10),

                  leading: Text(DateFormat("dd MMM").format(item.date)),
                  title: Text(item.name),
                  subtitle: Text("${item.poli} - ${item.complaint}"),
                  trailing: Text(
                    "${item.queueNumber}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConsultationFormView(
                          id: item.id,
                          name: item.name,
                          date: DateFormat("yyyy-MM-dd").format(item.date),
                          complaint: item.complaint,
                          poli: item.poli,
                        ),
                      ),
                    );
                    if (result == true) {
                      refreshData();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ConsultationFormView()),
          );
          if (result == true) {
            refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
