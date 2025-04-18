import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  Future<Map<String, String>> _readAll() async {
    var map = <String, String>{};
    try {
      map = await _storage.readAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      print(e);
    }
    return map;
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      // _readAll();
    } catch (e) {
      print(e);
    }
  }

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(key: key)) ?? "";
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print(e);
    }
  }



  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      print(e);
    }
  }

  // IOSOptions _getIOSOptions() => const IOSOptions(
  //   accessibility: IOSAccessibility.first_unlock,
  // );

  IOSOptions _getIOSOptions() => IOSOptions(accountName: AppleOptions.defaultAccountName);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}

class SecureTesting extends StatefulWidget {
  const SecureTesting({Key? key}) : super(key: key);

  @override
  State<SecureTesting> createState() => _SecureTestingState();
}

class _SecureTestingState extends State<SecureTesting> {
  SecureStorage storage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readData();
    });
    print("storage._readAll() ${storage._readAll()}");
  }

  readData() async {
    final data = await storage._readAll();
    final data1 = await storage.readSecureData("data1");
    print("data.entries ${data.entries}");
    data.entries.map((e) {
      print("key data ${e.key}");
      print("value data ${e.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 100,),
            InkWell(onTap: (){
                storage.deleteAll();
                storage.writeSecureData("data1", "value1");
            },child: Text("Write")),
            SizedBox(height: 20,),
            InkWell(onTap: (){
              readData();
            },child: Text("Read")),
            SizedBox(height: 20,),
            InkWell(onTap: (){

            },child: Text("Write")),
          ],
        ),
      ),
    );
  }
}
