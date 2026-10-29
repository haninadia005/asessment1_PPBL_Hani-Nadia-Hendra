import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/prediksi_page.dart';
import 'pages/beranda_page.dart';
import 'pages/tentang_page.dart';
import 'pages/input_prediksi_page.dart';
import 'pages/statistik_page.dart';
import 'pages/pengaturan_page.dart';
import 'state/prediksi_provider.dart';

class AppRoutes {
  static const beranda = '/';
  static const tentang = '/tentang';
  static const inputPrediksi = '/inputprediksi';
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PrediksiProvider(),
      child: const AgriClimaApp(),
    ),
  );
}

class AgriClimaApp extends StatefulWidget {
  const AgriClimaApp({super.key});

  @override
  State<AgriClimaApp> createState() => _AgriClimaAppState();
}

class _AgriClimaAppState extends State<AgriClimaApp> {
  bool modeGelap = false;

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFE91E63);
    const pinkTua = Color(0xFFAD1457);
    const pinkMuda = Color(0xFFF8BBD0);
    const latarPink = Color(0xFFFFF5F8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriClima LSTM',
      themeMode: modeGelap ? ThemeMode.dark : ThemeMode.light,

      // TEMA TERANG: PINK PASTEL
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: pink,
              brightness: Brightness.light,
            ).copyWith(
              primary: pink,
              onPrimary: Colors.white,
              secondary: const Color(0xFFF06292),
              surface: Colors.white,
              onSurface: pinkTua,
            ),
        scaffoldBackgroundColor: latarPink,
        appBarTheme: const AppBarTheme(
          backgroundColor: pinkMuda,
          foregroundColor: pinkTua,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: pink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: pink,
          foregroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFFFCE4EC),
          indicatorColor: pinkMuda,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: pink, width: 2),
          ),
        ),
      ),

      // TEMA GELAP: PINK GELAP
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pink,
          brightness: Brightness.dark,
        ).copyWith(primary: pinkMuda, secondary: const Color(0xFFF48FB1)),
        scaffoldBackgroundColor: const Color(0xFF21151B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4A1930),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF33212A),
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: pink,
          foregroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF33212A),
          indicatorColor: Color(0xFF6D2947),
        ),
      ),

      initialRoute: AppRoutes.beranda,
      routes: {
        AppRoutes.beranda: (_) => KerangkaNavigasi(
          modeGelap: modeGelap,
          onUbahTema: (nilai) {
            setState(() => modeGelap = nilai);
          },
        ),
        AppRoutes.tentang: (_) => const TentangPage(),
        AppRoutes.inputPrediksi: (_) => const InputPrediksiPage(),
      },
    );
  }
}

class KerangkaNavigasi extends StatefulWidget {
  final bool modeGelap;
  final ValueChanged<bool> onUbahTema;

  const KerangkaNavigasi({
    super.key,
    required this.modeGelap,
    required this.onUbahTema,
  });

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int tabAktif = 0;

  final List<String> namaTab = [
    'Beranda',
    'Prediksi',
    'Statistik',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    final halaman = [
      BerandaPage(
        onTentang: () => Navigator.pushNamed(context, AppRoutes.tentang),
      ),
      const PrediksiPage(),
      const StatistikPage(),
      PengaturanPage(
        modeGelap: widget.modeGelap,
        onUbahTema: widget.onUbahTema,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('AgriClima - ${namaTab[tabAktif]}')),
      body: IndexedStack(index: tabAktif, children: halaman),
      floatingActionButton: tabAktif == 1
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.inputPrediksi),
              icon: const Icon(Icons.add),
              label: const Text('Prediksi Baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabAktif,
        onDestinationSelected: (index) {
          setState(() => tabAktif = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Consumer<PrediksiProvider>(
              builder: (context, provider, child) {
                final jumlah = provider.perluTindakan;
                return Badge(
                  isLabelVisible: jumlah > 0,
                  label: Text('$jumlah'),
                  child: const Icon(Icons.edit_note_outlined),
                );
              },
            ),
            selectedIcon: Consumer<PrediksiProvider>(
              builder: (context, provider, child) {
                final jumlah = provider.perluTindakan;
                return Badge(
                  isLabelVisible: jumlah > 0,
                  label: Text('$jumlah'),
                  child: const Icon(Icons.edit_note),
                );
              },
            ),
            label: 'Prediksi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
