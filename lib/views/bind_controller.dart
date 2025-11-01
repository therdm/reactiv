class BindController<S> {
  final S Function() controller;
  final bool autoDispose;
  final bool lazyBind;

  BindController({
    required this.controller,
    this.autoDispose = true,
    this.lazyBind = true,
  });
}
