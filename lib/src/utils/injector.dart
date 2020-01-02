class Injector {
  final Map<Type, dynamic> _singletoneMap = {};

  void register<T>(T instance) {
    _singletoneMap[T] = instance;
  }

  T get<T>() {
    return _singletoneMap[T];
  }
}

final injector = Injector();
