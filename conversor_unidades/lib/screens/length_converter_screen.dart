import 'package:flutter/material.dart';
import 'package:conversor_unidades/widgets/converter_widget.dart';

class LengthConverterScreen extends StatelessWidget {
  const LengthConverterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ConverterWidget(
      units: {
        'Milímetros': 0.001,
        'Centímetros': 0.01,
        'Decímetro': 0.1,
        'Metros': 1.0,
        'Decámetros': 10.0,
        'Hectrómetros': 100.0,
        'Kilómetros': 1000.0,
        'Millas': 1609.34,
        'Pulgadas': 0.0254,
      },
    );
  }
}
