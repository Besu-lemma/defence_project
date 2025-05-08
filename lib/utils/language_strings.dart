// lib/utils/language_strings.dart

/// Currently selected language code: 'en', 'am', or 'om'
String currentLang = 'en';

/// Call this when the user picks a new language
void setLanguage(String lang) {
  currentLang = lang;
}

/// Lookup helper: returns translated text or the key if missing
String tr(String key) => _localized[currentLang]?[key] ?? key;

/// All UI strings for English, Amharic, and Afaan Oromo
const Map<String, Map<String, String>> _localized = {
  'en': {
    // MainScreen & Drawer
    'settings': 'Settings',
    'title': 'Smart Irrigation',
    'home': 'Home',
    'controller': 'Controller',
    'history': 'History',
    'send_feedback': 'Send Feedback',
    'notifications': 'Notifications',
    'change_pin': 'Change PIN',

    // Bottom nav labels
    'pump_control': 'Pump Control',

    // ControlScreen
    'water_tank_status': 'Water Tank Status',
    'tank_empty_title': 'Tank Empty',
    'tank_empty_msg': 'The tank is empty so you can\'t turn on the pump',
    'ok': 'OK',
    'confirm_pump_title': 'Confirm Pump Activation',
    'confirm_pump_msg': 'Are you sure you want to turn on the pump?',
    'cancel': 'Cancel',
    'turn_on': 'Turn On',
    'soil_moisture': 'Soil Moisture',
    'water_level': 'Water Level',
    'temperature': 'Temperature',
    'humidity': 'Humidity',
    'weather_conditions': 'WEATHER CONDITIONS',
    'pump_active': 'Pump Active',
    'pump_inactive': 'Pump Inactive',
    'manual_override': 'Manual override active (30 min)',

    // PinLockScreen
    'welcome': 'Welcome!',
    'to': 'to',
    'app_name': 'MesnoTech',
    'enter_pin': 'Enter PIN',
    'reset': 'Reset',

    // ChangePinScreen
    'incorrect_pin': 'Incorrect PIN!',
    'pin_4_digits': 'PIN must be 4 digits!',
    'pins_no_match': 'PINs do not match!',
    'pin_changed': 'PIN changed successfully!',
    'current_pin': 'Current PIN',
    'new_pin': 'New PIN',
    'confirm_pin': 'Confirm New PIN',

    // HistoryScreen
    'no_history': 'No history available yet.',
    'details': 'Details:',

    // Misc
    'to_home': 'Back',
    //notification
    'clear_history': 'Clear History',
  'no_notifications': 'No notifications available',
  },
  'am': {
    // MainScreen & Drawer
    'settings': 'ቅድመ ተከታታይ',
    'title': 'ስማርት የመረብ ስርዓት',
    'home': 'አሞሌ',
    'controller': 'መቆጣጠሪያ',
    'history': 'ታሪክ',
    'send_feedback': 'አስተያየት ላክ',
    'notifications': 'ማስታወቂያዎች',
    'change_pin': 'ፒን ቀይር',

    // Bottom nav labels
    'pump_control': 'መቆለፊያ መቆጣጠሪያ',

    // ControlScreen
    'water_tank_status': 'የውሃ ታንክ ሁኔታ',
    'tank_empty_title': 'ታንኩ ባዶ ነው',
    'tank_empty_msg': 'ታንኩ ባዶ ነው ስለዚህ መቆለፊያ እንዳትከፈት አትችሉ',
    'ok': 'እሺ',
    'confirm_pump_title': 'መቆለፊያ ማብራት ተፈላጊ?',
    'confirm_pump_msg': 'መቆለፊያን ማብራት ይፈልጋሉ?',
    'cancel': 'ሰርዝ',
    'turn_on': 'አብራሪ',
    'soil_moisture': 'የምድር ሕጥብ',
    'water_level': 'የውሃ አፍልት',
    'temperature': 'ሙቀት',
    'humidity': 'እርጥብ',
    'weather_conditions': 'የአየር ሁኔታ',
    'pump_active': 'መቆለፊያ ተከፈቷል',
    'pump_inactive': 'መቆለፊያ አልተከፈተም',
    'manual_override': 'ማኑዋል በደንብ ተጠናቀቀ (30 ደቂቃ)',

    // PinLockScreen
    'welcome': 'እንኳን ደህና መጡ!',
    'to': 'ወደ',
    'app_name': 'MesnoTech',
    'enter_pin': 'ፒን ያስገቡ',
    'reset': 'ዳግም',

    // ChangePinScreen
    'incorrect_pin': 'ፒን ትክክል አይደለም!',
    'pin_4_digits': 'ፒን 4 ቁጥር መሆን አለበት!',
    'pins_no_match': 'ፒኑ አተመጠጠ!',
    'pin_changed': 'ፒኑ በተሳካ ሁኔታ ተቀይሯል!',
    'current_pin': 'የአሁኑ ፒን',
    'new_pin': 'አዲስ ፒን',
    'confirm_pin': 'አዲሱን ያረጋግጡ',

    // HistoryScreen
    'no_history': 'እስካሁን ምንም ታሪክ የለም።',
    'details': 'ዝርዝር:',

    // Misc
    'to_home': 'መለስ',
    //notification
      'clear_history': 'ታሪኩን ቀይር',
  'no_notifications': 'ማስታወቂያ የለም',
  },
  'om': {
    // MainScreen & Drawer
    'settings': 'KUTAA GULAALCHAA',
    'title': 'Irrigaashinii Siisaamaa',
    'home': 'Mana',
    'controller': 'To’ataa',
    'history': 'Seenaa',
    'send_feedback': 'Yaada Ergi',
    'notifications': 'Beeksisa',
    'change_pin': 'PIN Jijjiiri',

    // Bottom nav labels
    'pump_control': 'To’annoo Pampi',

    // ControlScreen
    'water_tank_status': 'Haala Tankii Bishaanii',
    'tank_empty_title': 'Tankiin Dufaadha',
    'tank_empty_msg': 'Tankiin dufaadha; pampi banuun hin danda’amu',
    'ok': 'TOLE',
    'confirm_pump_title': 'Pampi banuu barbaadda?',
    'confirm_pump_msg': 'Pampi akka banuu barbaaddu mirkaneessi?',
    'cancel': 'HAMMA',
    'turn_on': 'BANU',
    'soil_moisture': 'Qullubbii Lafaa',
    'water_level': 'Sadarkaa Bishaanii',
    'temperature': 'Ho’aa',
    'humidity': 'Humidaatii',
    'weather_conditions': 'Haala Qilleensaa',
    'pump_active': 'Pampi Hojii irra jira',
    'pump_inactive': 'Pampi Hojii irra hin jirtu',
    'manual_override': 'Hojii Dirqama (daqiiqaa 30)',

    // PinLockScreen
    'welcome': 'Baga nagaan dhuftan!',
    'to': 'gara',
    'app_name': 'MesnoTech',
    'enter_pin': 'PIN galchi',
    'reset': 'DEEBI’I',

    // ChangePinScreen
    'incorrect_pin': 'PIN sirrii miti!',
    'pin_4_digits': 'PIN lakkoofsa 4 qofa!',
    'pins_no_match': 'PINs hin walfakkaatan!',
    'pin_changed': 'PIN milkaa’inaan jijjiirame!',
    'current_pin': 'PIN ammaa',
    'new_pin': 'PIN haaraa',
    'confirm_pin': 'PIN haarawa mirkaneessi',

    // HistoryScreen
    'no_history': 'Seenaa tokko illee hin jiru.',
    'details': 'Faayila:',

    // Misc
    'to_home': 'Deebi’i',
    //notification
      'clear_history': 'Seenaa Haqi',
  'no_notifications': 'Beeksisa hin jiru',
  },
};
