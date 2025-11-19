part of 'gallery_bloc.dart';

sealed class GalleryEvent {
  const GalleryEvent();
}

final class GalleryRequested extends GalleryEvent {
  const GalleryRequested();
}
