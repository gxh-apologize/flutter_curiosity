class AppInfoModel {
  String phoneBrand;
  String packageName;
  String versionName;
  int versionCode;
  String appName;
  String systemVersion;
  double statusBarHeight;

  ///only android
  ///
  String cacheDir;
  String directoryMusic;
  String directoryAlarms;
  String directoryDocuments;
  int firstInstallTime;
  String phoneModel;
  String directoryMovies;
  String directoryPictures;
  String filesDir;
  String directoryDCIM;
  String directoryNotifications;
  String directoryRINGTONES;
  String directoryDownloads;
  String externalCacheDir;
  String externalFilesDir;
  String directoryPODCASTS;
  String externalStorageDirectory;
  int sdkVersion;
  int lastUpdateTime;
  int buildNumber;
  double navigationBarHeight;

  ///only ios
  ///
  String cachesDirectory;
  String homeDirectory;
  String pinimumOSVersion;
  String platformVersion;
  String sdkBuild;
  String documentDirectory;
  String temporaryDirectory;
  double statusBarWidth;
  String libraryDirectory;
  String platformName;
  String systemName;

  AppInfoModel({this.cacheDir,
    this.versionName,
    this.directoryMusic,
    this.systemVersion,
    this.buildNumber,
    this.directoryAlarms,
    this.directoryDocuments,
    this.firstInstallTime,
    this.phoneModel,
    this.phoneBrand,
    this.packageName,
    this.directoryMovies,
    this.directoryPictures,
    this.filesDir,
    this.directoryDCIM,
    this.appName,
    this.navigationBarHeight,
    this.directoryNotifications,
    this.directoryRINGTONES,
    this.directoryDownloads,
    this.versionCode,
    this.externalCacheDir,
    this.externalFilesDir,
    this.directoryPODCASTS,
    this.externalStorageDirectory,
    this.sdkVersion,
    this.cachesDirectory,
    this.homeDirectory,
    this.pinimumOSVersion,
    this.platformVersion,
    this.sdkBuild,
    this.documentDirectory,
    this.temporaryDirectory,
    this.statusBarWidth,
    this.libraryDirectory,
    this.statusBarHeight,
    this.platformName,
    this.systemName,
    this.lastUpdateTime});

  AppInfoModel.fromJson(Map<String, dynamic> json) {
    cacheDir = json['cacheDir'];
    versionName = json['versionName'].toString();
    directoryMusic = json['DIRECTORY_MUSIC'];
    systemVersion = json['systemVersion'];
    buildNumber = json['buildNumber'];
    navigationBarHeight = json['navigationBarHeight'];
    directoryAlarms = json['DIRECTORY_ALARMS'];
    directoryDocuments = json['DIRECTORY_DOCUMENTS'];
    firstInstallTime = json['firstInstallTime'];
    phoneModel = json['phoneModel'];
    phoneBrand = json['phoneBrand'];
    packageName = json['packageName'];
    directoryMovies = json['DIRECTORY_MOVIES'];
    directoryPictures = json['DIRECTORY_PICTURES'];
    filesDir = json['filesDir'];
    directoryDCIM = json['DIRECTORY_DCIM'];
    appName = json['appName'];
    directoryNotifications = json['DIRECTORY_NOTIFICATIONS'];
    directoryRINGTONES = json['DIRECTORY_RINGTONES'];
    directoryDownloads = json['DIRECTORY_DOWNLOADS'];
    versionCode = json['versionCode'];
    externalCacheDir = json['externalCacheDir'];
    externalFilesDir = json['externalFilesDir'];
    directoryPODCASTS = json['DIRECTORY_PODCASTS'];
    externalStorageDirectory = json['externalStorageDirectory'];
    sdkVersion = json['sdkVersion'];
    lastUpdateTime = json['lastUpdateTime'];
    cachesDirectory = json['cachesDirectory'];
    homeDirectory = json['homeDirectory'];
    pinimumOSVersion = json['pinimumOSVersion'];
    platformVersion = json['platformVersion'];
    sdkBuild = json['sdkBuild'];
    documentDirectory = json['documentDirectory'];
    temporaryDirectory = json['temporaryDirectory'];
    statusBarWidth = json['statusBarWidth'];
    libraryDirectory = json['libraryDirectory'];
    statusBarHeight = json['statusBarHeight'];
    platformName = json['platformName'];
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cacheDir'] = this.cacheDir;
    data['versionName'] = this.versionName;
    data['directory_music'] = this.directoryMusic;
    data['systemVersion'] = this.systemVersion;
    data['buildNumber'] = this.buildNumber;
    data['directory_alarms'] = this.directoryAlarms;
    data['directory_documents'] = this.directoryDocuments;
    data['firstInstallTime'] = this.firstInstallTime;
    data['phoneModel'] = this.phoneModel;
    data['phoneBrand'] = this.phoneBrand;
    data['packageName'] = this.packageName;
    data['directory_movies'] = this.directoryMovies;
    data['directory_pictures'] = this.directoryPictures;
    data['filesDir'] = this.filesDir;
    data['directory_dcim'] = this.directoryDCIM;
    data['appName'] = this.appName;
    data['directory_notifications'] = this.directoryNotifications;
    data['directory_ringtones'] = this.directoryRINGTONES;
    data['directory_downloads'] = this.directoryDownloads;
    data['versionCode'] = this.versionCode;
    data['externalCacheDir'] = this.externalCacheDir;
    data['externalFilesDir'] = this.externalFilesDir;
    data['directory_podcasts'] = this.directoryPODCASTS;
    data['externalStorageDirectory'] = this.externalStorageDirectory;
    data['sdkVersion'] = this.sdkVersion;
    data['lastUpdateTime'] = this.lastUpdateTime;
    data['cachesDirectory'] = this.cachesDirectory;
    data['homeDirectory'] = this.homeDirectory;
    data['pinimumOSVersion'] = this.pinimumOSVersion;
    data['platformVersion'] = this.platformVersion;
    data['sdkBuild'] = this.sdkBuild;
    data['documentDirectory'] = this.documentDirectory;
    data['temporaryDirectory'] = this.temporaryDirectory;
    data['statusBarWidth'] = this.statusBarWidth;
    data['libraryDirectory'] = this.libraryDirectory;
    data['statusBarHeight'] = this.statusBarHeight;
    data['platformName'] = this.platformName;
    data['systemName'] = this.systemName;
    data['navigationBarHeight'] = this.navigationBarHeight;
    return data;
  }
}
