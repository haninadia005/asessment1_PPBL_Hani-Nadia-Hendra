
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/prediksi_provider.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PrediksiProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.analytics_outlined,
              color: Colors.pink,
            ),
            title: const Text('Total Prediksi'),
            subtitle: Text('${data.total} prediksi'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.thermostat,
              color: Colors.pink,
            ),
            title: const Text('Rata-rata Suhu'),
            subtitle: Text(
              '${data.rataSuhu.toStringAsFixed(1)} °C',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.grass,
              color: Colors.pink,
            ),
            title: const Text('Petak 1'),
            subtitle: Text(
              '${data.jumlahPerPetak['Petak 1'] ?? 0} data',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.eco_outlined,
              color: Colors.pink,
            ),
            title: const Text('Petak 2'),
            subtitle: Text(
              '${data.jumlahPerPetak['Petak 2'] ?? 0} data',
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Riwayat Prediksi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAD1457),
          ),
        ),
        const SizedBox(height: 8),

        if (data.riwayat.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Belum ada data prediksi.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...data.riwayat.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFCE4EC),
                  child: Icon(
                    Icons.eco,
                    color: Color(0xFFAD1457),
                  ),
                ),
                title: Text(
                  '${item.tanaman} - ${item.petak}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Kelembapan udara: '
                  '${item.kelembapanUdara}%\n'
                  'Kelembapan tanah: '
                  '${item.kelembapanTanah}%\n'
                  'Status: ${item.status}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
      ],
    );
  }
}
