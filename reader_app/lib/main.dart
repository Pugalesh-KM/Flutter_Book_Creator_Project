import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/reader_cubit.dart';
import 'screens/reader_home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ReaderApp());
}

class ReaderApp extends StatelessWidget {
  const ReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReaderCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reader App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.dmSansTextTheme(),
          colorSchemeSeed: Colors.indigo,
        ),
        home: const ReaderHome(),
      ),
    );
  }
}
