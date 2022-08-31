import 'dart:async';

import 'package:packagekit/packagekit.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:software/package_state.dart';
import 'package:software/services/package_service.dart';

class PackageInstallerModel extends SafeChangeNotifier {
  final PackageService _service;
  StreamSubscription<PackageState>? _packageStateSub;
  StreamSubscription<String>? _summarySub;
  StreamSubscription<String>? _urlSub;
  StreamSubscription<String>? _licenseSub;
  StreamSubscription<String>? _sizeSub;
  StreamSubscription<String>? _descriptionSub;
  StreamSubscription<String>? _changeLogSub;
  StreamSubscription<String>? _issuedSub;
  StreamSubscription<PackageKitGroup>? _groupController;
  StreamSubscription<bool>? _isInstalledSub;
  StreamSubscription<int?>? _percentageSub;
  StreamSubscription<PackageKitPackageId?>? _idSub;

  PackageInstallerModel(this._service, {required this.path})
      : _percentage = 0,
        _status = '',
        _license = '',
        _size = '',
        _summary = '',
        _url = '',
        _errorMessage = '',
        _packageState = PackageState.ready;

  final String path;

  void init() async {
    _service.getDetailsAboutLocalPackage(path: path);

    _idSub = _service.processedId.listen((event) {
      id = event;
    });
    _summarySub = _service.summary.listen((event) {
      summary = event;
    });
    _urlSub = _service.url.listen((event) {
      url = event;
    });
    _licenseSub = _service.license.listen((event) {
      license = event;
    });
    _sizeSub = _service.size.listen((event) {
      size = event;
    });
    _descriptionSub = _service.description.listen((event) {
      description = event;
    });
    _changeLogSub = _service.changelog.listen((event) {
      changelog = event;
    });
    _issuedSub = _service.issued.listen((event) {
      issued = event;
    });
    _groupController = _service.group.listen((event) {
      group = event;
    });
    _isInstalledSub = _service.isInstalled.listen((event) {
      isInstalled = event;
    });
    _percentageSub = _service.packagePercentage.listen((event) {
      percentage = event;
    });
  }

  @override
  void dispose() {
    _idSub?.cancel();
    _packageStateSub?.cancel();
    _summarySub?.cancel();
    _urlSub?.cancel();
    _licenseSub?.cancel();
    _sizeSub?.cancel();
    _descriptionSub?.cancel();
    _changeLogSub?.cancel();
    _issuedSub?.cancel();
    _groupController?.cancel();
    _isInstalledSub?.cancel();
    _percentageSub?.cancel();
    super.dispose();
  }

  PackageKitPackageId? _id;
  PackageKitPackageId? get id => _id;
  set id(PackageKitPackageId? value) {
    if (value == _id) return;
    _id = value;
    notifyListeners();
  }

  PackageState? _packageState;
  PackageState? get packageState => _packageState;
  set packageState(PackageState? value) {
    if (value == _packageState) return;
    _packageState = value;
    notifyListeners();
  }

  // The group this package belongs to.
  PackageKitGroup? _group;
  PackageKitGroup? get group => _group;
  set group(PackageKitGroup? value) {
    if (value == _group) return;
    _group = value;
    notifyListeners();
  }

  // The multi-line package description in markdown syntax.
  String? _description;
  String get description => _description ?? '';
  set description(String value) {
    if (value == _description) return;
    _description = value;
    notifyListeners();
  }

  /// The one line package summary, e.g. "Clipart for OpenOffice"
  String _summary;
  String get summary => _summary;
  set summary(String value) {
    if (value == _summary) return;
    _summary = value;
    notifyListeners();
  }

  // The upstream project homepage.
  String _url;
  String get url => _url;
  set url(String value) {
    if (value == _url) return;
    _url = value;
    notifyListeners();
  }

  /// The license string, e.g. GPLv2+
  String _license;
  String get license => _license;
  set license(String value) {
    if (value == _license) return;
    _license = value;
    notifyListeners();
  }

  /// The size of the package in bytes.
  String _size;
  String get size => _size;
  set size(String value) {
    if (value == _size) return;
    _size = value;
    notifyListeners();
  }

  /// Progress of the installation/removal
  int? _percentage;
  int? get percentage => _percentage;
  set percentage(int? value) {
    if (value == _percentage) return;
    _percentage = value;
    notifyListeners();
  }

  /// Status of the transaction
  String _status;
  String get status => _status;
  set status(String value) {
    if (value == _status) return;
    _status = value;
    notifyListeners();
  }

  String _errorMessage;
  String get errorMessage => _errorMessage;
  set errorMessage(String value) {
    if (value == _errorMessage) return;
    _errorMessage = value;
    notifyListeners();
  }

  String _changelog = '';
  String get changelog => _changelog;
  set changelog(String value) {
    if (value == _changelog) return;
    _changelog = value;
    notifyListeners();
  }

  String _issued = '';
  String get issued => _issued;
  set issued(String value) {
    if (value == _issued) return;
    _issued = value;
    notifyListeners();
  }

  bool _isInstalled = false;
  bool get isInstalled => _isInstalled;
  set isInstalled(bool value) {
    if (value == _isInstalled) return;
    _isInstalled = value;
    notifyListeners();
  }

  /// Removes with package with [packageId]
  void remove({required PackageKitPackageId packageId}) =>
      _service.remove(packageId: packageId);

  /// Installs with package with [packageId]
  void install({required PackageKitPackageId packageId}) =>
      _service.install(packageId: packageId);

  /// Install the local package from [path]
  void installLocalFile() => _service.installLocalFile(path: path);
}
