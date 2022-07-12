typedef InstanceCreator<T> = T Function();

class EaseInjector {
  EaseInjector._();
  static final EaseInjector _instanceInjector = EaseInjector._();
  factory EaseInjector() => _instanceInjector;

  final Map<Type, dynamic> _dependencies = {};

  void register<T extends Object>(
    InstanceCreator<T> instance, {
    bool isSingleton = true,
  }) {
    _dependencies[T] = _InstanceGenerator(instance, isSingleton);
  }

  T get<T extends Object>() {
    final instance = _dependencies[T]?.getInstance();
    if (instance != null && instance is T) {
      return instance;
    }
    throw Exception('Instance ${T.toString()} not found');
  }

  call<T extends Object>() => get<T>();
}

class _InstanceGenerator<T> {
  T? _instance;
  bool _isInitialGet = true;

  final InstanceCreator<T> _instanceCreator;
  _InstanceGenerator(this._instanceCreator, bool isSingleton)
      : _isInitialGet = isSingleton;

  T? getInstance() {
    if (_isInitialGet) {
      _instance = _instanceCreator();
      _isInitialGet = true;
    }
    return _instance ?? _instanceCreator();
  }
}
