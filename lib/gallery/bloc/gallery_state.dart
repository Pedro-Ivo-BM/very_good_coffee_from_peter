part of 'gallery_bloc.dart';

enum GalleryStatus { initial, loading, ready }

class GalleryState {
  const GalleryState({
    this.status = GalleryStatus.initial,
    this.colors = const [],
  });

  final GalleryStatus status;
  final List<Color> colors;

  GalleryState copyWith({GalleryStatus? status, List<Color>? colors}) {
    return GalleryState(
      status: status ?? this.status,
      colors: colors ?? this.colors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GalleryState) return false;
    return other.status == status && _listEquals(other.colors, colors);
  }

  @override
  int get hashCode => Object.hash(status, Object.hashAll(colors));
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
