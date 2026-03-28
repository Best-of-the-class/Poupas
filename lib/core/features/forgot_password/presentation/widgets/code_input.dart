import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInput extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;

  const CodeInput({super.key, this.length = 5, this.onCompleted});

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final List<String> _code = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _code.addAll(List.generate(widget.length, (_) => ''));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      _code[index] = value;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty) {
      _code[index] = '';
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    String fullCode = _code.join();
    if (fullCode.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(fullCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 55,
          height: 60,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onChanged(value, index),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFFE32626),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE32626),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE32626),
                  width: 2.5,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
