import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class ConverterWidget extends StatefulWidget {
  final Map<String, double> units;

  const ConverterWidget({Key? key, required this.units}) : super(key: key);

  @override
  State<ConverterWidget> createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget> with SingleTickerProviderStateMixin {
  String? _fromUnit;
  String? _toUnit;
  String _inputValue = '';
  double? _convertedValue;
  late AnimationController _swapController;
  late Animation<double> _rotationAnimation;
  bool _showConversionMessage = false;

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.units.keys.first;
    _toUnit = widget.units.keys.elementAt(1);
    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Duración más rápida
    );

    _rotationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeOut)), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.45).chain(CurveTween(curve: Curves.easeInOut)), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 0.45, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)), weight: 15),
    ]).animate(_swapController);
  }

  @override
  void dispose() {
    _swapController.dispose();
    super.dispose();
  }

  // Actualiza la conversión para mostrar más decimales
  void _convert() {
    if (_inputValue.isEmpty) {
      setState(() => _convertedValue = null);
      return;
    }
    final fromFactor = widget.units[_fromUnit] ?? 1.0;
    final toFactor = widget.units[_toUnit] ?? 1.0;
    final inputDouble = double.tryParse(_inputValue) ?? 0.0;

    setState(() {
      _convertedValue = inputDouble * (fromFactor / toFactor);
      _showConversionMessage = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showConversionMessage = false;
      });
    });
  }


  void _swapUnits() {
    // Cambiar las unidades de inmediato
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _convert();

    // Ejecutar la animación
    _swapController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final allUnits = widget.units.keys.toList();
    final availableToUnits = widget.units.keys.where((unit) => unit != _fromUnit).toList();

    String _formatConvertedValue(double? value) {
      if (value == null) return '';

      // Redondea a 10 decimales para evitar errores de coma flotante
      final rounded = double.parse(value.toStringAsFixed(10));

      // Si es entero, mostrar sin decimales
      if (rounded == rounded.toInt()) {
        return '${rounded.toInt()} $_toUnit';
      } else {
        // Si no, mostrar hasta 4 decimales, quitando ceros innecesarios
        return '${rounded.toStringAsFixed(10).replaceAll(RegExp(r'\.?0*$'), '')} $_toUnit';
      }
    }



    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          // Primera sección
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: 'Unidad de origen',
                value: _fromUnit,
                items: allUnits,
                onChanged: (value) {
                  setState(() {
                    _fromUnit = value;
                    // si el destino coincide, lo actualizamos
                    if (_fromUnit == _toUnit) {
                      _toUnit = allUnits.firstWhere((u) => u != _fromUnit);
                    }
                  });
                  _convert();
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Valor a convertir',
                onChanged: (value) {
                  setState(() {
                    _inputValue = value;
                  });
                  _convert();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Botón de intercambio con animación
          Center(
            child: RotationTransition(
              turns: _rotationAnimation,
              child: IconButton(
                icon: const Icon(Icons.swap_vert, size: 36, color: Colors.blueAccent),
                onPressed: _swapUnits,
                tooltip: 'Intercambiar unidades',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Segunda sección
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: 'Unidad de destino',
                value: _toUnit,
                items: availableToUnits,
                onChanged: (value) {
                  setState(() {
                    _toUnit = value;
                  });
                  _convert();
                },
              ),
              const SizedBox(height: 16),

              // Resultado convertido centrado
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _convertedValue == null
                    ? const SizedBox.shrink()
                    : Center(  // Center para centrar en todo el ancho de la pantalla
                  child: Column(
                    key: ValueKey(_convertedValue),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Resultado convertido:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(
                        _formatConvertedValue(_convertedValue),
                        style: const TextStyle(fontSize: 26, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((unit) {
        return DropdownMenuItem(value: unit, child: Text(unit));
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite decimales
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
