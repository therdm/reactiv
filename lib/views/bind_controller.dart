
class BindController<S> {
  final S controller;
  final bool autoDispose;

  BindController({
    required this.controller,
    this.autoDispose = true,
  });
}