import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(const GalleryState()) {
    on<GalleryRequested>(_onGalleryRequested);
  }

  static const List<Color> _palette = <Color>[
    Color(0xFF6F4E37),
    Color(0xFFD7CCC8),
    Color(0xFFA1887F),
    Color(0xFF795548),
    Color(0xFF4E342E),
    Color(0xFFBCAAA4),
    Color(0xFF8D6E63),
    Color(0xFF5D4037),
    Color(0xFF3E2723),
  ];

  Future<void> _onGalleryRequested(
    GalleryRequested event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: GalleryStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(status: GalleryStatus.ready, colors: _palette));
  }
}
