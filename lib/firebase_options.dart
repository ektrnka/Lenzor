// Р¤Р°Р№Р» РєРѕРЅС„РёРіСѓСЂР°С†РёРё Firebase.
// Р’РђР–РќРћ: Р—Р°РїСѓСЃС‚РёС‚Рµ РІ РєРѕСЂРЅРµ РїСЂРѕРµРєС‚Р°: dart run flutterfire_cli:flutterfire configure
// Р­С‚Рѕ СЃРѕР·РґР°СЃС‚/РѕР±РЅРѕРІРёС‚ СЌС‚РѕС‚ С„Р°Р№Р» СЃ СЂРµР°Р»СЊРЅС‹РјРё РґР°РЅРЅС‹РјРё РІР°С€РµРіРѕ Firebase-РїСЂРѕРµРєС‚Р°.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAalY1aLWZLv3ZSlKj4VWRG7sQVVIRgFxA',
      appId: '1:51430576041:android:1bf944a1d83a317d5efeb8',
      messagingSenderId: '51430576041',
      projectId: 'lenzor-b6a29',
      authDomain: 'lenzor-b6a29.firebaseapp.com',
      storageBucket: 'lenzor-b6a29.firebasestorage.app',
    );
  }
}

