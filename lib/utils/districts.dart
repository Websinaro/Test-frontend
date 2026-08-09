import '../localization/app_language.dart';

class KDistrict {
  final String key;
  final String label;
  final String labelMl;
  final double lat;
  final double lon;

  const KDistrict(this.key, this.label, this.labelMl, this.lat, this.lon);
}

/// Must stay in sync with the backend's `data/kerala_districts.py`.
const List<KDistrict> kKeralaDistricts = [
  KDistrict('thiruvananthapuram', 'Thiruvananthapuram', 'തിരുവനന്തപുരം', 8.5241, 76.9366),
  KDistrict('kollam', 'Kollam', 'കൊല്ലം', 8.8932, 76.6141),
  KDistrict('pathanamthitta', 'Pathanamthitta', 'പത്തനംതിട്ട', 9.2648, 76.7870),
  KDistrict('alappuzha', 'Alappuzha', 'ആലപ്പുഴ', 9.4981, 76.3388),
  KDistrict('kottayam', 'Kottayam', 'കോട്ടയം', 9.5916, 76.5222),
  KDistrict('idukki', 'Idukki', 'ഇടുക്കി', 9.8500, 77.1000),
  KDistrict('ernakulam', 'Ernakulam', 'എറണാകുളം', 9.9816, 76.2999),
  KDistrict('thrissur', 'Thrissur', 'തൃശ്ശൂർ', 10.5276, 76.2144),
  KDistrict('palakkad', 'Palakkad', 'പാലക്കാട്', 10.7867, 76.6548),
  KDistrict('malappuram', 'Malappuram', 'മലപ്പുറം', 11.0510, 76.0711),
  KDistrict('kozhikode', 'Kozhikode', 'കോഴിക്കോട്', 11.2588, 75.7804),
  KDistrict('wayanad', 'Wayanad', 'വയനാട്', 11.6854, 76.1320),
  KDistrict('kannur', 'Kannur', 'കണ്ണൂർ', 11.8745, 75.3704),
  KDistrict('kasaragod', 'Kasaragod', 'കാസർഗോഡ്', 12.4996, 74.9869),
];

KDistrict? findDistrict(String key) {
  for (final d in kKeralaDistricts) {
    if (d.key == key) return d;
  }
  return null;
}

/// [lang] is optional so existing call sites keep compiling; pass the
/// current [AppLanguage] wherever it's available so district names switch
/// between English and Malayalam along with the rest of the screen.
String districtLabel(String key, [AppLanguage? lang]) {
  final d = findDistrict(key);
  if (d != null) return lang?.code == 'ml' ? d.labelMl : d.label;
  if (key.isEmpty) return lang?.code == 'ml' ? 'അജ്ഞാതം' : 'Unknown';
  return key[0].toUpperCase() + key.substring(1);
}
