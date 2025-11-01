class BindController<S> {
  final S Function() controller;
  final bool autoDispose;

  BindController({
    required this.controller,
    this.autoDispose = true,
  });
}
