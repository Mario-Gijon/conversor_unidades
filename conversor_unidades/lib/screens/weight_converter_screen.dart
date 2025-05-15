import 'package:flutter/material.dart';
import 'package:conversor_unidades/widgets/converter_widget.dart';

class WeightConverterScreen extends StatelessWidget {
  const WeightConverterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ConverterWidget(
      units: {
        'Miligramo': 0.001,
        'Decigramo': 0.01,
        'Gramos': 1.0,
        'Kilogramos': 1000.0,
        'Libras': 453.592,
        'Onzas': 28.3495,
        'Toneladas': 1e6,
        'Quilates': 0.2
      },
    );
  }
}
