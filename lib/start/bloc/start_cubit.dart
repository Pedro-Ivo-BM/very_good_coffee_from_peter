import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartState {
  const StartState({required this.accentColor});

  final Color accentColor;
}

class StartCubit extends Cubit<StartState> {
  StartCubit() : super(StartState(accentColor: _palette.first));

  static const List<Color> _palette = <Color>[
    Color(0xFFBCAAA4),
    Color(0xFF8D6E63),
    Color(0xFF6F4E37),
    Color(0xFF4E342E),
    Color(0xFFD7CCC8),
  ];

  final Random _random = Random();

  void shuffleAccent() {
    final nextColor = _palette[_random.nextInt(_palette.length)];
    if (nextColor == state.accentColor) {
      final index = (_palette.indexOf(nextColor) + 1) % _palette.length;
      emit(StartState(accentColor: _palette[index]));
      return;
    }
    emit(StartState(accentColor: nextColor));
  }
}
