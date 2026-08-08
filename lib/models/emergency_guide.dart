import 'package:flutter/material.dart';

/// Static, offline-first survival reference shown in the Emergency Guide.
/// This intentionally ships as bundled data (not an API call) so it's still
/// readable with no signal - the moment it's most likely to be needed.
///
/// Every piece of guidance is stored in both English and Malayalam
/// (KSDMA/NDMA-style public safety phrasing) so the reader can switch
/// language and still see the full guide, instantly and offline.
class DisasterGuide {
  final String id;
  final String name;
  final String nameMl;
  final String shortDescription;
  final String shortDescriptionMl;
  final IconData icon;
  final Color color;

  /// What to prepare / watch for before it happens.
  final List<String> before;
  final List<String> beforeMl;

  /// What to actually do while it is happening.
  final List<String> during;
  final List<String> duringMl;

  /// What to do once it has passed.
  final List<String> after;
  final List<String> afterMl;

  /// Short, high-signal "never do this" list - kept separate from [during]
  /// so it can be rendered with stronger visual warning styling.
  final List<String> dontDo;
  final List<String> dontDoMl;

  /// Core survival facts: how much time you typically have, what kit to
  /// keep ready, key numbers to know, etc.
  final List<GuideFact> survivalData;

  const DisasterGuide({
    required this.id,
    required this.name,
    required this.nameMl,
    required this.shortDescription,
    required this.shortDescriptionMl,
    required this.icon,
    required this.color,
    required this.before,
    required this.beforeMl,
    required this.during,
    required this.duringMl,
    required this.after,
    required this.afterMl,
    required this.dontDo,
    required this.dontDoMl,
    required this.survivalData,
  });

  String nameFor(bool malayalam) => malayalam ? nameMl : name;
  String descriptionFor(bool malayalam) => malayalam ? shortDescriptionMl : shortDescription;
  List<String> beforeFor(bool malayalam) => malayalam ? beforeMl : before;
  List<String> duringFor(bool malayalam) => malayalam ? duringMl : during;
  List<String> afterFor(bool malayalam) => malayalam ? afterMl : after;
  List<String> dontDoFor(bool malayalam) => malayalam ? dontDoMl : dontDo;
}

class GuideFact {
  final String label;
  final String labelMl;
  final String value;
  final String valueMl;
  final IconData icon;

  const GuideFact({
    required this.label,
    required this.labelMl,
    required this.value,
    required this.valueMl,
    required this.icon,
  });

  String labelFor(bool malayalam) => malayalam ? labelMl : label;
  String valueFor(bool malayalam) => malayalam ? valueMl : value;
}

/// All disaster types relevant to Kerala / coastal-monsoon India, plus the
/// broadly-applicable ones (earthquake, heatwave, fire). Content is written
/// to match Kerala State Disaster Management Authority (KSDMA) and NDMA
/// public guidance at a summary level.
class EmergencyGuideData {
  EmergencyGuideData._();

  static const List<DisasterGuide> guides = [
    DisasterGuide(
      id: 'flood',
      name: 'Flood',
      nameMl: 'വെള്ളപ്പൊക്കം',
      shortDescription: 'Rising water from heavy rain, dam release or overflowing rivers',
      shortDescriptionMl: 'കനത്ത മഴ, അണക്കെട്ട് തുറക്കൽ അല്ലെങ്കിൽ നദികൾ കരകവിയുന്നത് മൂലമുള്ള ജലനിരപ്പ് ഉയരൽ',
      icon: Icons.water_rounded,
      color: Color(0xFF3B82F6),
      survivalData: [
        GuideFact(
          label: 'Typical warning time', labelMl: 'സാധാരണ മുന്നറിയിപ്പ് സമയം',
          value: '6–48 hrs (monsoon/dam alerts)', valueMl: '6–48 മണിക്കൂർ (മൺസൂൺ/ഡാം അലർട്ടുകൾ)',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'Danger water depth', labelMl: 'അപകടകരമായ ജലനിരപ്പ്',
          value: '15 cm can knock you down', valueMl: '15 സെ.മീ. നിങ്ങളെ വീഴ്ത്താം',
          icon: Icons.height_rounded,
        ),
        GuideFact(
          label: 'Vehicle danger', labelMl: 'വാഹന അപകടം',
          value: '30 cm can sweep away a car', valueMl: '30 സെ.മീ. കാർ ഒഴുകിപ്പോകാം',
          icon: Icons.directions_car_filled_rounded,
        ),
        GuideFact(
          label: 'Go-bag essentials', labelMl: 'എമർജൻസി ബാഗ്',
          value: 'ID copies, meds, torch, whistle, water', valueMl: 'ID പകർപ്പുകൾ, മരുന്ന്, ടോർച്ച്, വിസിൽ, വെള്ളം',
          icon: Icons.backpack_rounded,
        ),
      ],
      before: [
        'Keep an emergency kit ready: torch, power bank, whistle, medicines, copies of ID/documents in a waterproof pouch.',
        'Know your district\'s flood alert level (Green/Yellow/Orange/Red) and check it daily during monsoon in the WeBAlert Weather tab.',
        'Identify the nearest relief camp / high ground and the safest route to it before water rises.',
        'Move vehicles, important documents and valuables to an upper floor if you\'re in a known flood-prone area.',
        'Charge phones and power banks fully whenever a Yellow alert or higher is issued for your district.',
      ],
      beforeMl: [
        'ടോർച്ച്, പവർ ബാങ്ക്, വിസിൽ, മരുന്നുകൾ, ID/രേഖകളുടെ പകർപ്പുകൾ വാട്ടർപ്രൂഫ് ബാഗിൽ സൂക്ഷിക്കുക.',
        'നിങ്ങളുടെ ജില്ലയിലെ വെള്ളപ്പൊക്ക അലർട്ട് ലെവൽ (Green/Yellow/Orange/Red) മൺസൂൺ കാലത്ത് WeBAlert വെതർ ടാബിൽ ദിവസവും പരിശോധിക്കുക.',
        'ജലനിരപ്പ് ഉയരുന്നതിന് മുൻപ് അടുത്തുള്ള ദുരിതാശ്വാസ ക്യാമ്പും സുരക്ഷിതമായ ഉയർന്ന സ്ഥലവും അവിടേക്കുള്ള വഴിയും കണ്ടെത്തുക.',
        'വെള്ളപ്പൊക്ക സാധ്യതയുള്ള പ്രദേശത്താണെങ്കിൽ വാഹനങ്ങളും പ്രധാന രേഖകളും വിലപിടിപ്പുള്ള വസ്തുക്കളും മുകൾ നിലയിലേക്ക് മാറ്റുക.',
        'ജില്ലയിൽ Yellow അലർട്ടോ അതിന് മുകളിലോ പ്രഖ്യാപിച്ചാൽ ഫോണും പവർ ബാങ്കും പൂർണമായി ചാർജ് ചെയ്യുക.',
      ],
      during: [
        'Move immediately to higher ground or an upper floor - don\'t wait for water to reach your doorstep.',
        'Switch off the main electricity supply and gas connection before water enters the house.',
        'If trapped, go to the highest point in the building and signal for help (torch, bright cloth, whistle).',
        'Use the SOS button in WeBAlert to alert your Safety Circle and rescuers with your live location.',
        'Drink only stored or boiled water; avoid floodwater completely, even for washing.',
      ],
      duringMl: [
        'വെള്ളം വീട്ടിലേക്ക് എത്തുന്നത് വരെ കാത്തിരിക്കാതെ ഉടൻ ഉയർന്ന സ്ഥലത്തേക്കോ മുകൾ നിലയിലേക്കോ മാറുക.',
        'വെള്ളം അകത്ത് കയറുന്നതിന് മുൻപ് മെയിൻ വൈദ്യുതി, ഗ്യാസ് കണക്ഷൻ എന്നിവ ഓഫ് ചെയ്യുക.',
        'കുടുങ്ങിപ്പോയാൽ കെട്ടിടത്തിലെ ഏറ്റവും ഉയർന്ന സ്ഥലത്തേക്ക് പോയി ടോർച്ച്, തിളക്കമുള്ള തുണി, വിസിൽ എന്നിവ ഉപയോഗിച്ച് സഹായത്തിനായി സിഗ്നൽ നൽകുക.',
        'WeBAlert-ലെ SOS ബട്ടൺ ഉപയോഗിച്ച് നിങ്ങളുടെ Safety Circle-നും രക്ഷാപ്രവർത്തകർക്കും ലൈവ് ലൊക്കേഷൻ അയക്കുക.',
        'സൂക്ഷിച്ചുവച്ച അല്ലെങ്കിൽ തിളപ്പിച്ച വെള്ളം മാത്രം കുടിക്കുക; വെള്ളപ്പൊക്ക ജലം കഴുകാൻ പോലും ഉപയോഗിക്കരുത്.',
      ],
      after: [
        'Don\'t return home until authorities officially declare it safe.',
        'Avoid walking or driving through standing water - it may hide open drains, live wires or debris.',
        'Get drinking water tested or boil it before use; discard food that touched floodwater.',
        'Disinfect the house before living in it again, and watch for signs of water-borne illness for the next 1–2 weeks.',
        'Document damage with photos for insurance/relief claims before cleanup.',
      ],
      afterMl: [
        'അധികൃതർ ഔദ്യോഗികമായി സുരക്ഷിതമെന്ന് പ്രഖ്യാപിക്കുന്നത് വരെ വീട്ടിലേക്ക് മടങ്ങരുത്.',
        'കെട്ടിനിൽക്കുന്ന വെള്ളത്തിലൂടെ നടക്കുകയോ വാഹനമോടിക്കുകയോ ചെയ്യരുത് - തുറന്ന ഓടകൾ, കറന്റ് വയറുകൾ, അവശിഷ്ടങ്ങൾ ഒളിഞ്ഞിരിക്കാം.',
        'കുടിവെള്ളം പരിശോധിച്ചതിന് ശേഷമോ തിളപ്പിച്ചതിന് ശേഷമോ ഉപയോഗിക്കുക; വെള്ളപ്പൊക്ക ജലം തൊട്ട ഭക്ഷണം ഉപേക്ഷിക്കുക.',
        'വീട്ടിൽ വീണ്ടും താമസിക്കുന്നതിന് മുൻപ് അണുവിമുക്തമാക്കുക; അടുത്ത 1-2 ആഴ്ചത്തേക്ക് ജലജന്യ രോഗ ലക്ഷണങ്ങൾ ശ്രദ്ധിക്കുക.',
        'ക്ലീനപ്പിന് മുൻപ് ഇൻഷുറൻസ്/ദുരിതാശ്വാസ ക്ലെയിമുകൾക്കായി നാശനഷ്ടങ്ങളുടെ ഫോട്ടോ എടുക്കുക.',
      ],
      dontDo: [
        'Never walk or drive through moving water, even if it looks shallow.',
        'Don\'t touch electrical switches or equipment while standing in water.',
        'Don\'t drink or cook with floodwater or well water until it\'s tested.',
        'Don\'t go sightseeing near flooded rivers/dams - banks can collapse without warning.',
      ],
      dontDoMl: [
        'ഒഴുകുന്ന വെള്ളത്തിലൂടെ ഒരിക്കലും നടക്കുകയോ വാഹനമോടിക്കുകയോ ചെയ്യരുത്, ആഴം കുറവാണെന്ന് തോന്നിയാലും.',
        'വെള്ളത്തിൽ നിൽക്കുമ്പോൾ വൈദ്യുതി സ്വിച്ചുകളോ ഉപകരണങ്ങളോ തൊടരുത്.',
        'പരിശോധിക്കുന്നത് വരെ വെള്ളപ്പൊക്ക ജലമോ കിണർ വെള്ളമോ കുടിക്കുകയോ പാചകത്തിന് ഉപയോഗിക്കുകയോ ചെയ്യരുത്.',
        'വെള്ളപ്പൊക്കമുള്ള നദികൾ/ഡാമുകൾക്ക് സമീപം കാഴ്ച കാണാൻ പോകരുത് - തീരങ്ങൾ മുന്നറിയിപ്പില്ലാതെ ഇടിഞ്ഞുവീഴാം.',
      ],
    ),
    DisasterGuide(
      id: 'landslide',
      name: 'Landslide',
      nameMl: 'ഉരുൾപൊട്ടൽ',
      shortDescription: 'Sudden slope collapse on hills/highlands, common in Kerala\'s Western Ghats during heavy rain',
      shortDescriptionMl: 'കനത്ത മഴയിൽ കേരളത്തിന്റെ പശ്ചിമഘട്ട മലനിരകളിൽ സാധാരണമായ പെട്ടെന്നുള്ള മലയിടിച്ചിൽ',
      icon: Icons.terrain_rounded,
      color: Color(0xFF92400E),
      survivalData: [
        GuideFact(
          label: 'Typical warning time', labelMl: 'സാധാരണ മുന്നറിയിപ്പ് സമയം',
          value: 'Seconds to minutes - often no warning', valueMl: 'സെക്കൻഡുകൾ മുതൽ മിനിറ്റുകൾ വരെ - പലപ്പോഴും മുന്നറിയിപ്പില്ല',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'High-risk trigger', labelMl: 'ഉയർന്ന അപകട സാഹചര്യം',
          value: '>24hr continuous heavy rain on slopes', valueMl: '24 മണിക്കൂറിലധികം തുടർച്ചയായ കനത്ത മഴ ചരിവുകളിൽ',
          icon: Icons.water_drop_rounded,
        ),
        GuideFact(
          label: 'Escape direction', labelMl: 'രക്ഷപ്പെടേണ്ട ദിശ',
          value: 'Sideways, across the slope - not downhill', valueMl: 'ചരിവിന് കുറുകെ വശത്തേക്ക് - താഴേക്കല്ല',
          icon: Icons.moving_rounded,
        ),
        GuideFact(
          label: 'Warning sound', labelMl: 'മുന്നറിയിപ്പ് ശബ്ദം',
          value: 'Rumbling, cracking trees, sudden stream muddiness', valueMl: 'മുഴക്കം, മരങ്ങൾ ഒടിയുന്ന ശബ്ദം, തോട്ടിലെ വെള്ളം പെട്ടെന്ന് ചെളിനിറമാകൽ',
          icon: Icons.hearing_rounded,
        ),
      ],
      before: [
        'If you live on or below a steep slope in a landslide-prone area, know your evacuation route in advance.',
        'Watch for warning signs: new cracks in ground/walls, tilting trees or fences, doors/windows sticking suddenly.',
        'A sudden increase in stream water flow followed by a decrease, and water turning muddy, is an early warning sign.',
        'During Orange/Red alerts for hilly districts, avoid unnecessary travel and stay alert overnight - landslides often occur when people are asleep.',
        'Keep footwear and a torch by your bed during heavy-rain nights in high-risk zones.',
      ],
      beforeMl: [
        'ചരിവുള്ള കുന്നിൻ പ്രദേശത്ത് താമസിക്കുന്നവർ മുൻകൂട്ടി ഒഴിഞ്ഞുപോകാനുള്ള വഴി അറിഞ്ഞിരിക്കുക.',
        'മുന്നറിയിപ്പ് ലക്ഷണങ്ങൾ ശ്രദ്ധിക്കുക: നിലത്തും ചുവരിലും പുതിയ വിള്ളലുകൾ, മരങ്ങളോ വേലികളോ ചരിയുന്നത്, വാതിലുകൾ/ജനലുകൾ പെട്ടെന്ന് ഒട്ടിപ്പിടിക്കുന്നത്.',
        'തോട്ടിലെ ജലപ്രവാഹം പെട്ടെന്ന് കൂടിയതിന് ശേഷം കുറയുന്നതും വെള്ളം ചെളിനിറമാകുന്നതും ആദ്യ മുന്നറിയിപ്പ് ലക്ഷണമാണ്.',
        'മലയോര ജില്ലകളിൽ Orange/Red അലർട്ട് സമയത്ത് അനാവശ്യ യാത്ര ഒഴിവാക്കുക; രാത്രി ജാഗ്രത പുലർത്തുക - ആളുകൾ ഉറങ്ങുമ്പോഴാണ് പലപ്പോഴും ഉരുൾപൊട്ടൽ സംഭവിക്കുന്നത്.',
        'ഉയർന്ന അപകട മേഖലയിൽ കനത്ത മഴയുള്ള രാത്രികളിൽ ചെരിപ്പും ടോർച്ചും കിടക്കയ്ക്ക് സമീപം സൂക്ഷിക്കുക.',
      ],
      during: [
        'If you hear rumbling, cracking trees or a roaring sound, move away immediately - don\'t stop to gather belongings.',
        'Move sideways, out of the debris path, rather than trying to outrun it downhill.',
        'If escape isn\'t possible, curl into a tight ball and protect your head with your arms.',
        'Get away from the slope path and river valleys below it - debris and mud can travel much further than expected.',
        'Alert neighbours if you can do so safely; use WeBAlert SOS to share your location with your Safety Circle.',
      ],
      duringMl: [
        'മുഴക്കമോ മരം ഒടിയുന്ന ശബ്ദമോ ഇരമ്പലോ കേട്ടാൽ ഉടൻ മാറിനിൽക്കുക - സാധനങ്ങൾ എടുക്കാൻ നിൽക്കരുത്.',
        'അവശിഷ്ടങ്ങളുടെ പാതയിൽ നിന്ന് താഴേക്ക് ഓടാൻ ശ്രമിക്കുന്നതിന് പകരം വശത്തേക്ക് നീങ്ങുക.',
        'രക്ഷപ്പെടാൻ കഴിയുന്നില്ലെങ്കിൽ ശരീരം ചുരുട്ടി തലയെ കൈകൾ കൊണ്ട് സംരക്ഷിക്കുക.',
        'ചരിവിന്റെ പാതയിൽ നിന്നും താഴെയുള്ള നദീതടങ്ങളിൽ നിന്നും അകന്നു നിൽക്കുക - അവശിഷ്ടങ്ങളും ചെളിയും പ്രതീക്ഷിച്ചതിലും ദൂരം സഞ്ചരിക്കാം.',
        'സാധിക്കുമെങ്കിൽ അയൽക്കാരെ സുരക്ഷിതമായി അറിയിക്കുക; WeBAlert SOS ഉപയോഗിച്ച് നിങ്ങളുടെ Safety Circle-ന് ലൊക്കേഷൻ പങ്കുവയ്ക്കുക.',
      ],
      after: [
        'Stay away from the slide area - additional slides are common in the same spot for hours or days after.',
        'Report broken utility lines (gas, electric, water) to authorities rather than approaching them yourself.',
        'Check for injured or trapped people near the edges of the slide, without entering the debris zone yourself.',
        'Have a structural engineer inspect your home if it\'s near the slide before re-entering.',
      ],
      afterMl: [
        'മണ്ണിടിച്ചിൽ ഉണ്ടായ സ്ഥലത്ത് നിന്ന് അകന്നു നിൽക്കുക - അതേ സ്ഥലത്ത് മണിക്കൂറുകൾക്കോ ദിവസങ്ങൾക്കോ ശേഷം വീണ്ടും ഉരുൾപൊട്ടൽ സാധാരണമാണ്.',
        'പൊട്ടിയ ഗ്യാസ്, വൈദ്യുതി, ജല ലൈനുകൾ സ്വയം സമീപിക്കാതെ അധികൃതരെ അറിയിക്കുക.',
        'അവശിഷ്ട മേഖലയിൽ പ്രവേശിക്കാതെ അതിന്റെ അരികിൽ പരിക്കേറ്റവരോ കുടുങ്ങിയവരോ ഉണ്ടോയെന്ന് പരിശോധിക്കുക.',
        'വീട് അവശിഷ്ടത്തിനടുത്താണെങ്കിൽ വീണ്ടും പ്രവേശിക്കുന്നതിന് മുൻപ് ഒരു സ്ട്രക്ചറൽ എൻജിനീയറെക്കൊണ്ട് പരിശോധിപ്പിക്കുക.',
      ],
      dontDo: [
        'Never build or stay in temporary shelter directly below a steep, saturated slope.',
        'Don\'t return to a slide area to retrieve belongings - it can move again with no warning.',
        'Don\'t assume a slope is safe just because it hasn\'t slid before this monsoon.',
      ],
      dontDoMl: [
        'നനഞ്ഞ ചരിവിന്റെ താഴെ ഒരിക്കലും താൽക്കാലിക ഷെൽട്ടർ ഉണ്ടാക്കുകയോ താമസിക്കുകയോ ചെയ്യരുത്.',
        'സാധനങ്ങൾ എടുക്കാൻ ഉരുൾപൊട്ടൽ സ്ഥലത്തേക്ക് മടങ്ങിപ്പോകരുത് - മുന്നറിയിപ്പില്ലാതെ വീണ്ടും ചലിക്കാം.',
        'ഈ മൺസൂണിൽ ഇതുവരെ ഇടിഞ്ഞിട്ടില്ല എന്നതുകൊണ്ട് മാത്രം ഒരു ചരിവ് സുരക്ഷിതമാണെന്ന് കരുതരുത്.',
      ],
    ),
    DisasterGuide(
      id: 'earthquake',
      name: 'Earthquake',
      nameMl: 'ഭൂകമ്പം',
      shortDescription: 'Ground shaking from tectonic movement - low but non-zero risk across Kerala',
      shortDescriptionMl: 'ടെക്റ്റോണിക് ചലനം മൂലമുള്ള ഭൂചലനം - കേരളത്തിൽ അപകട സാധ്യത കുറവാണെങ്കിലും ഇല്ലാതില്ല',
      icon: Icons.vibration_rounded,
      color: Color(0xFFB45309),
      survivalData: [
        GuideFact(
          label: 'Shaking duration', labelMl: 'വിറയൽ ദൈർഘ്യം',
          value: 'Usually 20–60 seconds', valueMl: 'സാധാരണ 20-60 സെക്കൻഡ്',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'Action rule', labelMl: 'പ്രവർത്തന നിയമം',
          value: 'Drop, Cover, Hold On - within 1–2 sec', valueMl: 'Drop, Cover, Hold On - 1-2 സെക്കൻഡിനുള്ളിൽ',
          icon: Icons.bolt_rounded,
        ),
        GuideFact(
          label: 'Aftershocks', labelMl: 'ആഫ്റ്റർഷോക്കുകൾ',
          value: 'Can continue for hours to days', valueMl: 'മണിക്കൂറുകൾ മുതൽ ദിവസങ്ങൾ വരെ തുടരാം',
          icon: Icons.waves_rounded,
        ),
        GuideFact(
          label: 'Safe distance from building', labelMl: 'കെട്ടിടത്തിൽ നിന്നുള്ള സുരക്ഷിത ദൂരം',
          value: '~1.5x building height, if outdoors', valueMl: 'പുറത്താണെങ്കിൽ കെട്ടിടത്തിന്റെ ഉയരത്തിന്റെ ~1.5 ഇരട്ടി',
          icon: Icons.straighten_rounded,
        ),
      ],
      before: [
        'Secure heavy furniture, cupboards and water heaters to walls so they can\'t topple.',
        'Know the "Drop, Cover, Hold On" action and practise it with family, especially children.',
        'Identify safe spots in each room - under sturdy furniture, against interior walls, away from glass and tall shelves.',
        'Keep an emergency kit with water, food, torch, first-aid and a whistle accessible at all times.',
      ],
      beforeMl: [
        'ഭാരമുള്ള ഫർണിച്ചർ, അലമാരകൾ, വാട്ടർ ഹീറ്ററുകൾ എന്നിവ ചുവരിൽ ഉറപ്പിച്ച് വീഴാതെ സൂക്ഷിക്കുക.',
        '\'Drop, Cover, Hold On\' എന്ന നടപടി അറിഞ്ഞിരിക്കുകയും കുടുംബാംഗങ്ങളുമായി, പ്രത്യേകിച്ച് കുട്ടികളുമായി പരിശീലിക്കുകയും ചെയ്യുക.',
        'ഓരോ മുറിയിലും സുരക്ഷിത സ്ഥലങ്ങൾ കണ്ടെത്തുക - ബലമുള്ള ഫർണിച്ചറിനടിയിൽ, അകത്തെ ചുവരിനോട് ചേർന്ന്, ഗ്ലാസ്സിൽ നിന്നും ഉയരമുള്ള ഷെൽഫുകളിൽ നിന്നും അകലെ.',
        'വെള്ളം, ഭക്ഷണം, ടോർച്ച്, ഫസ്റ്റ് എയ്ഡ്, വിസിൽ എന്നിവയടങ്ങിയ എമർജൻസി കിറ്റ് എപ്പോഴും കൈയെത്തുന്ന ദൂരത്ത് സൂക്ഷിക്കുക.',
      ],
      during: [
        'Drop to the ground immediately, take Cover under a sturdy table/desk, and Hold On until shaking stops.',
        'If indoors, stay indoors - most injuries happen from people running outside during shaking.',
        'If outdoors, move to open ground away from buildings, trees and power lines.',
        'If driving, pull over away from bridges/overpasses and stay in the vehicle with the seatbelt on.',
        'If in bed, stay there and cover your head with a pillow rather than getting up.',
      ],
      duringMl: [
        'ഉടൻ നിലത്തേക്ക് താഴുക (Drop), ബലമുള്ള മേശയ്ക്ക് അടിയിൽ മറയുക (Cover), വിറയൽ നിൽക്കുന്നത് വരെ മുറുകെ പിടിക്കുക (Hold On).',
        'അകത്താണെങ്കിൽ അകത്ത് തന്നെ തുടരുക - വിറയലിനിടെ പുറത്തേക്ക് ഓടുന്നതാണ് മിക്ക പരിക്കുകൾക്കും കാരണം.',
        'പുറത്താണെങ്കിൽ കെട്ടിടങ്ങൾ, മരങ്ങൾ, വൈദ്യുതി ലൈനുകൾ എന്നിവയിൽ നിന്ന് അകന്ന് തുറസ്സായ സ്ഥലത്തേക്ക് നീങ്ങുക.',
        'വാഹനമോടിക്കുകയാണെങ്കിൽ പാലങ്ങൾ/ഓവർപാസുകൾ ഒഴിവാക്കി ഒതുക്കി നിർത്തി സീറ്റ് ബെൽറ്റോടെ വാഹനത്തിൽ തന്നെ ഇരിക്കുക.',
        'കിടക്കയിലാണെങ്കിൽ എഴുന്നേൽക്കാതെ അവിടെ തന്നെ കിടന്ന് തലയിണ കൊണ്ട് തല മറയ്ക്കുക.',
      ],
      after: [
        'Expect aftershocks - keep following Drop, Cover, Hold On each time the ground shakes.',
        'Check yourself and others for injuries before moving; only move an injured person if they\'re in immediate danger.',
        'Inspect for gas leaks (smell, hissing) and structural damage (cracks, tilting) before re-entering a building.',
        'Avoid using elevators, and stay away from damaged buildings, bridges and coastlines (in case of a follow-on tsunami risk).',
      ],
      afterMl: [
        'ആഫ്റ്റർഷോക്കുകൾ പ്രതീക്ഷിക്കുക - ഓരോ തവണ നിലം കുലുങ്ങുമ്പോഴും Drop, Cover, Hold On തുടരുക.',
        'മറ്റുള്ളവരെ സഹായിക്കുന്നതിന് മുൻപ് സ്വയം പരിക്കുകൾ പരിശോധിക്കുക; അടിയന്തിര ഘട്ടത്തിൽ മാത്രം പരിക്കേറ്റവരെ മാറ്റുക.',
        'വീണ്ടും കെട്ടിടത്തിൽ പ്രവേശിക്കുന്നതിന് മുൻപ് ഗ്യാസ് ചോർച്ച (മണം, ചീറ്റൽ ശബ്ദം), ഘടനാപരമായ കേടുപാടുകൾ (വിള്ളലുകൾ, ചരിവ്) എന്നിവ പരിശോധിക്കുക.',
        'ലിഫ്റ്റ് ഉപയോഗിക്കാതിരിക്കുക; തകർന്ന കെട്ടിടങ്ങൾ, പാലങ്ങൾ, തീരപ്രദേശങ്ങൾ (സുനാമി സാധ്യത) എന്നിവയിൽ നിന്ന് അകന്ന് നിൽക്കുക.',
      ],
      dontDo: [
        'Never run outside or use stairs/elevators during active shaking.',
        'Don\'t stand in a doorway - in modern buildings it\'s not safer than sturdy cover.',
        'Don\'t light matches or use open flames if you smell gas.',
      ],
      dontDoMl: [
        'വിറയലിനിടെ ഒരിക്കലും പുറത്തേക്ക് ഓടുകയോ പടികൾ/ലിഫ്റ്റ് ഉപയോഗിക്കുകയോ ചെയ്യരുത്.',
        'വാതിൽപ്പടിയിൽ നിൽക്കരുത് - ആധുനിക കെട്ടിടങ്ങളിൽ അത് സുരക്ഷിതമല്ല.',
        'ഗ്യാസ് മണം അനുഭവപ്പെട്ടാൽ തീപ്പെട്ടി കത്തിക്കുകയോ തുറന്ന തീ ഉപയോഗിക്കുകയോ ചെയ്യരുത്.',
      ],
    ),
    DisasterGuide(
      id: 'cyclone',
      name: 'Cyclone / High Wind',
      nameMl: 'ചുഴലിക്കാറ്റ് / ശക്തമായ കാറ്റ്',
      shortDescription: 'Coastal storm systems bringing destructive wind, storm surge and heavy rain',
      shortDescriptionMl: 'വിനാശകരമായ കാറ്റ്, കടൽക്ഷോഭം, കനത്ത മഴ എന്നിവയുള്ള തീരദേശ കൊടുങ്കാറ്റ് സംവിധാനങ്ങൾ',
      icon: Icons.cyclone_rounded,
      color: Color(0xFF6D28D9),
      survivalData: [
        GuideFact(
          label: 'Typical warning time', labelMl: 'സാധാരണ മുന്നറിയിപ്പ് സമയം',
          value: '24–72 hrs (IMD cyclone bulletins)', valueMl: '24-72 മണിക്കൂർ (IMD സൈക്ലോൺ ബുള്ളറ്റിനുകൾ)',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'Danger zone', labelMl: 'അപകട മേഖല',
          value: 'Coastal belt + low-lying estuaries', valueMl: 'തീരദേശ പട്ടയും താഴ്ന്ന അഴിമുഖ പ്രദേശങ്ങളും',
          icon: Icons.beach_access_rounded,
        ),
        GuideFact(
          label: 'Storm surge risk', labelMl: 'കടൽക്ഷോഭ സാധ്യത',
          value: 'Can raise sea level several metres', valueMl: 'സമുദ്രനിരപ്പ് പല മീറ്റർ ഉയരാം',
          icon: Icons.waves_rounded,
        ),
        GuideFact(
          label: 'Eye calm ≠ over', labelMl: 'ശാന്തമായ \'കണ്ണ്\' = അവസാനമല്ല',
          value: 'Winds return from opposite direction', valueMl: 'എതിർദിശയിൽ നിന്ന് കാറ്റ് വീണ്ടും വരും',
          icon: Icons.warning_amber_rounded,
        ),
      ],
      before: [
        'Follow IMD/KSDMA cyclone bulletins closely from the moment a depression is announced.',
        'Secure or bring indoors loose outdoor items (signboards, sheets, potted plants) that can become projectiles.',
        'Stock up on drinking water, non-perishable food, torches and charged power banks for several days.',
        'If you\'re in a coastal or estuary evacuation zone, move to the designated shelter as soon as evacuation is announced - don\'t wait for the storm to arrive.',
      ],
      beforeMl: [
        'ന്യൂനമർദ്ദം പ്രഖ്യാപിച്ച നിമിഷം മുതൽ IMD/KSDMA സൈക്ലോൺ ബുള്ളറ്റിനുകൾ സൂക്ഷ്മമായി പിന്തുടരുക.',
        'പറന്നുപോകാവുന്ന വസ്തുക്കൾ (ബോർഡുകൾ, ഷീറ്റുകൾ, ചെടിച്ചട്ടികൾ) സുരക്ഷിതമാക്കുകയോ അകത്തേക്ക് മാറ്റുകയോ ചെയ്യുക.',
        'കുടിവെള്ളം, കേടാകാത്ത ഭക്ഷണം, ടോർച്ച്, ചാർജ്ജ് ചെയ്ത പവർ ബാങ്ക് എന്നിവ ദിവസങ്ങളോളം കരുതിവയ്ക്കുക.',
        'തീരദേശ/അഴിമുഖ ഒഴിപ്പിക്കൽ മേഖലയിലാണെങ്കിൽ ഒഴിപ്പിക്കൽ പ്രഖ്യാപിച്ചാൽ ഉടൻ നിർദ്ദിഷ്ട ക്യാമ്പിലേക്ക് മാറുക - കൊടുങ്കാറ്റ് എത്തുന്നത് വരെ കാത്തിരിക്കരുത്.',
      ],
      during: [
        'Stay indoors, away from windows and glass doors; shelter in an interior room on the lowest safe floor.',
        'If the calm "eye" passes over, stay inside - winds will resume violently from the opposite direction shortly after.',
        'Do not go outside to inspect damage or take photos during any lull in the storm.',
        'If flooding starts, move to higher floors but stay away from the roof unless water is life-threatening.',
      ],
      duringMl: [
        'ജനലുകളിൽ നിന്നും ഗ്ലാസ് വാതിലുകളിൽ നിന്നും അകന്ന് അകത്തെ മുറിയിൽ, താഴ്ന്ന സുരക്ഷിത നിലയിൽ അഭയം തേടുക.',
        'ശാന്തമായ \'കണ്ണ്\' കടന്നുപോയാൽ അകത്ത് തന്നെ തുടരുക - തൊട്ടുപിന്നാലെ എതിർദിശയിൽ നിന്ന് ശക്തമായ കാറ്റ് വീണ്ടും വരും.',
        'കൊടുങ്കാറ്റിലെ ഏത് ഇടവേളയിലും പുറത്തിറങ്ങി നാശനഷ്ടം പരിശോധിക്കുകയോ ഫോട്ടോ എടുക്കുകയോ ചെയ്യരുത്.',
        'വെള്ളപ്പൊക്കം തുടങ്ങിയാൽ മുകൾ നിലയിലേക്ക് മാറുക, പക്ഷേ ജീവന് ഭീഷണിയില്ലെങ്കിൽ മേൽക്കൂരയിലേക്ക് പോകരുത്.',
      ],
      after: [
        'Wait for an official all-clear before going outside - fallen power lines and unstable structures are major post-cyclone hazards.',
        'Avoid floodwater and standing water; it may be electrically charged from downed lines.',
        'Watch for weakened trees and structures that can collapse even after wind has died down.',
        'Boil or treat drinking water until officials confirm supply is safe.',
      ],
      afterMl: [
        'പുറത്തിറങ്ങുന്നതിന് മുൻപ് ഔദ്യോഗിക അനുമതിക്കായി കാത്തിരിക്കുക - വീണ വൈദ്യുതി ലൈനുകളും അസ്ഥിരമായ കെട്ടിടങ്ങളും വലിയ അപകടമാണ്.',
        'കെട്ടിനിൽക്കുന്ന വെള്ളം ഒഴിവാക്കുക - അതിൽ വൈദ്യുതി പ്രവഹിക്കുന്നുണ്ടാകാം.',
        'കാറ്റ് നിന്നതിന് ശേഷവും ബലക്ഷയമുള്ള മരങ്ങളും ഘടനകളും വീഴാൻ സാധ്യതയുണ്ടെന്ന് ഓർക്കുക.',
        'അധികൃതർ സുരക്ഷിതമെന്ന് സ്ഥിരീകരിക്കുന്നത് വരെ കുടിവെള്ളം തിളപ്പിച്ചോ ശുദ്ധീകരിച്ചോ ഉപയോഗിക്കുക.',
      ],
      dontDo: [
        'Never go out during the "eye" of the storm thinking it has passed.',
        'Don\'t use candles near damaged gas lines - use torches instead.',
        'Don\'t drive through areas with downed power lines or storm debris.',
      ],
      dontDoMl: [
        'കൊടുങ്കാറ്റ് കടന്നുപോയെന്ന് കരുതി \'കണ്ണ്\' കടക്കുന്ന സമയത്ത് ഒരിക്കലും പുറത്തിറങ്ങരുത്.',
        'കേടായ ഗ്യാസ് ലൈനുകൾക്ക് സമീപം മെഴുകുതിരി ഉപയോഗിക്കരുത് - പകരം ടോർച്ച് ഉപയോഗിക്കുക.',
        'വീണ വൈദ്യുതി ലൈനുകളോ കൊടുങ്കാറ്റ് അവശിഷ്ടങ്ങളോ ഉള്ള സ്ഥലങ്ങളിലൂടെ വാഹനമോടിക്കരുത്.',
      ],
    ),
    DisasterGuide(
      id: 'lightning',
      name: 'Lightning / Thunderstorm',
      nameMl: 'മിന്നൽ / ഇടിമിന്നൽ',
      shortDescription: 'Frequent during Kerala\'s pre-monsoon and monsoon storms',
      shortDescriptionMl: 'കേരളത്തിലെ വേനൽ മഴ, മൺസൂൺ കൊടുങ്കാറ്റുകളിൽ സാധാരണം',
      icon: Icons.flash_on_rounded,
      color: Color(0xFFF59E0B),
      survivalData: [
        GuideFact(
          label: '30-30 rule', labelMl: '30-30 നിയമം',
          value: 'Thunder <30s after flash = go indoors', valueMl: 'മിന്നലിന് ശേഷം 30 സെക്കൻഡിനുള്ളിൽ ഇടിമുഴക്കം = അകത്തേക്ക് പോകുക',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'Wait after last thunder', labelMl: 'അവസാന ഇടിമുഴക്കത്തിന് ശേഷം കാത്തിരിക്കേണ്ട സമയം',
          value: '30 minutes before going back out', valueMl: 'പുറത്തിറങ്ങും മുൻപ് 30 മിനിറ്റ്',
          icon: Icons.hourglass_bottom_rounded,
        ),
        GuideFact(
          label: 'Strike distance', labelMl: 'മിന്നൽ എത്താവുന്ന ദൂരം',
          value: 'Can strike 15+ km from the storm core', valueMl: 'കൊടുങ്കാറ്റിന്റെ കേന്ദ്രത്തിൽ നിന്ന് 15+ കി.മീ. അകലെ വരെ',
          icon: Icons.social_distance_rounded,
        ),
        GuideFact(
          label: 'Safest place', labelMl: 'ഏറ്റവും സുരക്ഷിതമായ സ്ഥലം',
          value: 'Enclosed building or hard-top vehicle', valueMl: 'അടച്ചിട്ട കെട്ടിടം അല്ലെങ്കിൽ ഹാർഡ്-ടോപ്പ് വാഹനം',
          icon: Icons.home_rounded,
        ),
      ],
      before: [
        'Check WeBAlert weather alerts for thunderstorm warnings before farm work, fishing or outdoor travel.',
        'Plan outdoor activities for times when no storms are forecast, especially in open fields or near water.',
        'If you hear thunder, treat it as a signal to head indoors - don\'t wait to see lightning first.',
      ],
      beforeMl: [
        'കൃഷിപ്പണി, മീൻപിടിത്തം, യാത്ര എന്നിവയ്ക്ക് മുൻപ് WeBAlert-ലെ ഇടിമിന്നൽ മുന്നറിയിപ്പുകൾ പരിശോധിക്കുക.',
        'കൊടുങ്കാറ്റ് പ്രവചിക്കാത്ത സമയങ്ങളിൽ, പ്രത്യേകിച്ച് തുറസ്സായ വയലുകളിലും ജലാശയങ്ങൾക്കടുത്തും, പുറംപ്രവർത്തനങ്ങൾ ആസൂത്രണം ചെയ്യുക.',
        'ഇടിമുഴക്കം കേട്ടാൽ അകത്തേക്ക് പോകാനുള്ള സൂചനയായി കണക്കാക്കുക - മിന്നൽ കാണുന്നത് വരെ കാത്തിരിക്കരുത്.',
      ],
      during: [
        'Get inside a sturdy building or hard-topped vehicle immediately - avoid open sheds, tents or bus stops.',
        'Stay away from windows, plumbing and corded electronics; avoid using landline phones.',
        'If caught outdoors with no shelter, crouch low on the balls of your feet, minimising contact with the ground, and get away from tall isolated trees, poles and water.',
        'Avoid open fields, hilltops, and being the tallest object around; spread out from groups of people.',
      ],
      duringMl: [
        'ഉടൻ ബലമുള്ള കെട്ടിടത്തിലേക്കോ ഹാർഡ്-ടോപ്പ് വാഹനത്തിലേക്കോ പോകുക - തുറന്ന ഷെഡ്, ടെന്റ്, ബസ് സ്റ്റോപ്പ് എന്നിവ ഒഴിവാക്കുക.',
        'ജനലുകൾ, പ്ലംബിംഗ്, കോർഡുള്ള ഇലക്ട്രോണിക്സ് എന്നിവയിൽ നിന്ന് അകന്ന് നിൽക്കുക; ലാൻഡ്‌ലൈൻ ഫോൺ ഉപയോഗിക്കരുത്.',
        'പുറത്ത് ഷെൽട്ടർ ഇല്ലാതെ കുടുങ്ങിയാൽ പാദങ്ങളിൽ കുനിഞ്ഞിരുന്ന് നിലവുമായുള്ള സമ്പർക്കം കുറയ്ക്കുക; ഉയരമുള്ള ഒറ്റപ്പെട്ട മരങ്ങളിൽ, തൂണുകളിൽ, വെള്ളത്തിൽ നിന്ന് അകന്നു നിൽക്കുക.',
        'തുറസ്സായ വയലുകൾ, കുന്നിൻ മുകളുകൾ ഒഴിവാക്കുക; ഒറ്റപ്പെട്ട് ഉയരം കൂടിയ വസ്തുവാകാതിരിക്കുക; സംഘമായി നിൽക്കുന്നെങ്കിൽ അകന്ന് നിൽക്കുക.',
      ],
      after: [
        'Wait at least 30 minutes after the last thunderclap before resuming outdoor activity.',
        'If someone is struck by lightning, call for emergency help immediately and begin CPR if they\'re unresponsive and not breathing - a lightning victim carries no residual charge and is safe to touch.',
      ],
      afterMl: [
        'അവസാന ഇടിമുഴക്കത്തിന് ശേഷം കുറഞ്ഞത് 30 മിനിറ്റ് കാത്തിരുന്നിട്ട് മാത്രം പുറംപ്രവർത്തനങ്ങൾ പുനരാരംഭിക്കുക.',
        'ആരെങ്കിലും മിന്നലേറ്റാൽ ഉടൻ എമർജൻസി സഹായത്തിന് വിളിക്കുക; പ്രതികരണമില്ലാതെയും ശ്വാസമില്ലാതെയും ഇരിക്കുകയാണെങ്കിൽ CPR ആരംഭിക്കുക - മിന്നലേറ്റ വ്യക്തിയിൽ വൈദ്യുതി അവശേഷിക്കില്ല, തൊടുന്നത് സുരക്ഷിതമാണ്.',
      ],
      dontDo: [
        'Never shelter under a lone tree, tower or pole during a thunderstorm.',
        'Don\'t stand in open water or near metal fences/railings.',
        'Don\'t use a wired telephone or touch plumbing during a storm.',
      ],
      dontDoMl: [
        'ഇടിമിന്നൽ സമയത്ത് ഒറ്റപ്പെട്ട മരത്തിനോ ടവറിനോ തൂണിനോ അടിയിൽ ഒരിക്കലും അഭയം തേടരുത്.',
        'തുറന്ന ജലാശയത്തിലോ ലോഹ വേലിക്കടുത്തോ നിൽക്കരുത്.',
        'കൊടുങ്കാറ്റ് സമയത്ത് വയർഡ് ടെലിഫോൺ ഉപയോഗിക്കുകയോ പ്ലംബിംഗ് തൊടുകയോ ചെയ്യരുത്.',
      ],
    ),
    DisasterGuide(
      id: 'heatwave',
      name: 'Heat Wave',
      nameMl: 'ഉഷ്ണതരംഗം',
      shortDescription: 'Prolonged abnormally high temperatures, increasingly common in Kerala summers',
      shortDescriptionMl: 'കേരളത്തിലെ വേനൽക്കാലത്ത് കൂടിവരുന്ന അസാധാരണമായ ഉയർന്ന താപനില',
      icon: Icons.thermostat_rounded,
      color: Color(0xFFDC2626),
      survivalData: [
        GuideFact(
          label: 'High-risk hours', labelMl: 'ഉയർന്ന അപകട സമയം',
          value: '12 PM – 4 PM (peak sun)', valueMl: 'ഉച്ചയ്ക്ക് 12 മുതൽ 4 വരെ (പീക്ക് വെയിൽ)',
          icon: Icons.wb_sunny_rounded,
        ),
        GuideFact(
          label: 'Hydration target', labelMl: 'ജലാംശ ലക്ഷ്യം',
          value: '2.5–3 L water/day, more if outdoors', valueMl: 'പ്രതിദിനം 2.5-3 ലിറ്റർ വെള്ളം, പുറത്താണെങ്കിൽ കൂടുതൽ',
          icon: Icons.local_drink_rounded,
        ),
        GuideFact(
          label: 'Heatstroke sign', labelMl: 'ഹീറ്റ്‌സ്ട്രോക്ക് ലക്ഷണം',
          value: 'Hot dry skin + confusion = medical emergency', valueMl: 'ചൂടും വരണ്ടതുമായ ത്വക്ക് + ആശയക്കുഴപ്പം = മെഡിക്കൽ എമർജൻസി',
          icon: Icons.emergency_rounded,
        ),
        GuideFact(
          label: 'Highest-risk group', labelMl: 'ഏറ്റവും അപകട സാധ്യതയുള്ള വിഭാഗം',
          value: 'Infants, elderly, outdoor labourers', valueMl: 'കുഞ്ഞുങ്ങൾ, പ്രായമായവർ, പുറംപണിക്കാർ',
          icon: Icons.groups_rounded,
        ),
      ],
      before: [
        'Check the day\'s heat forecast and plan strenuous outdoor work for early morning or evening.',
        'Keep ORS packets or a homemade salt-sugar-water solution at home.',
        'Ensure elderly family members and infants have access to cool spaces and fluids throughout the day.',
      ],
      beforeMl: [
        'അന്നത്തെ താപ പ്രവചനം പരിശോധിച്ച് കഠിനമായ പുറംപണികൾ രാവിലെയോ വൈകുന്നേരമോ ആയി ആസൂത്രണം ചെയ്യുക.',
        'ORS പാക്കറ്റുകൾ അല്ലെങ്കിൽ ഉപ്പ്-പഞ്ചസാര-വെള്ള ലായനി വീട്ടിൽ കരുതുക.',
        'പ്രായമായവർക്കും കുഞ്ഞുങ്ങൾക്കും ദിവസം മുഴുവൻ തണുപ്പുള്ള സ്ഥലവും ദ്രാവകങ്ങളും ലഭ്യമാണെന്ന് ഉറപ്പാക്കുക.',
      ],
      during: [
        'Drink water regularly even if you don\'t feel thirsty; avoid alcohol, tea and coffee which dehydrate you.',
        'Wear light-coloured, loose cotton clothing and use an umbrella or hat outdoors.',
        'Avoid direct sun between 12 PM and 4 PM; rest in shade or a cooled space if you must be outside.',
        'Never leave children, elderly people or pets in a parked vehicle, even briefly.',
        'Watch for heat exhaustion signs (heavy sweating, weakness, nausea) and move the person to a cool place, giving fluids immediately.',
      ],
      duringMl: [
        'ദാഹം തോന്നിയില്ലെങ്കിലും ഇടയ്ക്കിടെ വെള്ളം കുടിക്കുക; നിർജ്ജലീകരണം ഉണ്ടാക്കുന്ന മദ്യം, ചായ, കാപ്പി എന്നിവ ഒഴിവാക്കുക.',
        'ഇളം നിറമുള്ള അയഞ്ഞ കോട്ടൺ വസ്ത്രം ധരിക്കുക; പുറത്ത് കുട അല്ലെങ്കിൽ തൊപ്പി ഉപയോഗിക്കുക.',
        'ഉച്ചയ്ക്ക് 12 മുതൽ 4 വരെ നേരിട്ടുള്ള വെയിൽ ഒഴിവാക്കുക; പുറത്തിറങ്ങേണ്ടിവന്നാൽ തണലിലോ തണുപ്പുള്ള സ്ഥലത്തോ വിശ്രമിക്കുക.',
        'കുട്ടികളെയോ പ്രായമായവരെയോ വളർത്തുമൃഗങ്ങളെയോ ഒരിക്കലും പാർക്ക് ചെയ്ത വാഹനത്തിൽ ഒറ്റയ്ക്ക് വിടരുത്, അല്പസമയത്തേക്കാണെങ്കിലും.',
        'ഹീറ്റ് എക്‌സോഷൻ ലക്ഷണങ്ങൾ (കനത്ത വിയർപ്പ്, ബലക്ഷയം, ഓക്കാനം) ശ്രദ്ധിച്ചാൽ വ്യക്തിയെ തണുപ്പുള്ള സ്ഥലത്തേക്ക് മാറ്റി ഉടൻ ദ്രാവകങ്ങൾ നൽകുക.',
      ],
      after: [
        'Continue rehydrating over the following day even once temperatures drop.',
        'Monitor anyone who showed heat-exhaustion symptoms for delayed complications and seek medical care if they don\'t improve.',
      ],
      afterMl: [
        'താപനില കുറഞ്ഞാലും അടുത്ത ദിവസം ജലാംശം തുടർന്ന് നൽകുക.',
        'ഹീറ്റ് എക്‌സോഷൻ ലക്ഷണം കാണിച്ച ആരെയും വൈകി വരാവുന്ന സങ്കീർണതകൾക്കായി നിരീക്ഷിക്കുകയും മെച്ചപ്പെടുന്നില്ലെങ്കിൽ ചികിത്സ തേടുകയും ചെയ്യുക.',
      ],
      dontDo: [
        'Never leave anyone in a parked, closed vehicle in the heat.',
        'Don\'t do heavy physical work outdoors during peak afternoon heat.',
        'Don\'t ignore heatstroke signs (no sweating, hot dry skin, confusion) - it\'s a medical emergency, call for help immediately.',
      ],
      dontDoMl: [
        'ചൂടിൽ ആരെയും പാർക്ക് ചെയ്ത, അടച്ച വാഹനത്തിൽ ഒരിക്കലും വിടരുത്.',
        'ഉച്ചയ്ക്കുള്ള കടുത്ത വെയിലിൽ കഠിനമായ ശാരീരിക പണികൾ ചെയ്യരുത്.',
        'ഹീറ്റ്‌സ്ട്രോക്ക് ലക്ഷണങ്ങൾ (വിയർപ്പില്ലായ്മ, ചൂടും വരണ്ടതുമായ ത്വക്ക്, ആശയക്കുഴപ്പം) അവഗണിക്കരുത് - ഇത് മെഡിക്കൽ എമർജൻസിയാണ്, ഉടൻ സഹായം തേടുക.',
      ],
    ),
    DisasterGuide(
      id: 'tsunami',
      name: 'Tsunami',
      nameMl: 'സുനാമി',
      shortDescription: 'Rare but severe wave surge following undersea earthquakes, relevant to Kerala\'s coastline',
      shortDescriptionMl: 'സമുദ്രാന്തർ ഭൂകമ്പങ്ങളെ തുടർന്നുള്ള അപൂർവമെങ്കിലും ഗുരുതരമായ തിരമാല - കേരളത്തിന്റെ തീരപ്രദേശത്തിന് പ്രസക്തം',
      icon: Icons.tsunami_rounded,
      color: Color(0xFF0E7490),
      survivalData: [
        GuideFact(
          label: 'Natural warning', labelMl: 'സ്വാഭാവിക മുന്നറിയിപ്പ്',
          value: 'Strong coastal earthquake shaking', valueMl: 'തീരത്തിനടുത്ത് ശക്തമായ ഭൂചലനം',
          icon: Icons.vibration_rounded,
        ),
        GuideFact(
          label: 'Sea behaviour warning', labelMl: 'കടലിന്റെ പെരുമാറ്റ മുന്നറിയിപ്പ്',
          value: 'Sudden, unusual sea withdrawal', valueMl: 'പെട്ടെന്ന് അസാധാരണമായി കടൽ പിൻവാങ്ങൽ',
          icon: Icons.remove_red_eye_rounded,
        ),
        GuideFact(
          label: 'Time to act', labelMl: 'പ്രവർത്തിക്കാനുള്ള സമയം',
          value: 'Minutes, not hours - move immediately', valueMl: 'മണിക്കൂറുകളല്ല, മിനിറ്റുകൾ - ഉടൻ നീങ്ങുക',
          icon: Icons.timer_outlined,
        ),
        GuideFact(
          label: 'Safe elevation', labelMl: 'സുരക്ഷിത ഉയരം',
          value: '30m+ above sea level or 3km inland', valueMl: 'സമുദ്രനിരപ്പിൽ നിന്ന് 30മീ+ അല്ലെങ്കിൽ 3കി.മീ. ഉൾനാട്ടിലേക്ക്',
          icon: Icons.terrain_rounded,
        ),
      ],
      before: [
        'If you live or are staying on the coast, know the inland evacuation route to higher ground in advance.',
        'Treat a strong earthquake felt near the coast, or an official tsunami warning, as reason to evacuate immediately.',
      ],
      beforeMl: [
        'തീരപ്രദേശത്ത് താമസിക്കുന്നവർ അല്ലെങ്കിൽ അവിടെയുള്ളവർ ഉയർന്ന സ്ഥലത്തേക്കുള്ള ഒഴിപ്പിക്കൽ വഴി മുൻകൂട്ടി അറിഞ്ഞിരിക്കുക.',
        'തീരത്തിനടുത്ത് ശക്തമായ ഭൂചലനം അനുഭവപ്പെട്ടാലോ ഔദ്യോഗിക സുനാമി മുന്നറിയിപ്പ് ലഭിച്ചാലോ ഉടൻ ഒഴിഞ്ഞുപോകേണ്ട കാരണമായി കണക്കാക്കുക.',
      ],
      during: [
        'If you feel strong ground shaking near the coast, or see the sea suddenly recede far beyond normal, move inland/uphill immediately - don\'t wait for an official announcement.',
        'Move on foot if roads are jammed; every metre of elevation and distance from shore matters.',
        'Do not stop to collect belongings or watch the wave - tsunamis can arrive as a series of waves over hours.',
        'If you can\'t reach high ground, go to the upper floor of a strong, multi-storey concrete building as a last resort.',
      ],
      duringMl: [
        'തീരത്തിനടുത്ത് ശക്തമായ നിലയനക്കം അനുഭവപ്പെട്ടാലോ കടൽ സാധാരണയിലും കൂടുതൽ പിന്നിലേക്ക് പെട്ടെന്ന് പിൻവാങ്ങുന്നത് കണ്ടാലോ ഔദ്യോഗിക പ്രഖ്യാപനത്തിന് കാത്തുനിൽക്കാതെ ഉടൻ ഉൾനാട്ടിലേക്കോ ഉയരത്തിലേക്കോ നീങ്ങുക.',
        'റോഡുകളിൽ തിരക്കുണ്ടെങ്കിൽ നടന്ന് നീങ്ങുക; തീരത്തുനിന്നുള്ള ഓരോ മീറ്റർ ഉയരവും ദൂരവും പ്രധാനമാണ്.',
        'സാധനങ്ങൾ എടുക്കാനോ തിരമാല കാണാനോ നിൽക്കരുത് - സുനാമി മണിക്കൂറുകളോളം തുടരുന്ന തിരമാലാ പരമ്പരയായി വരാം.',
        'ഉയർന്ന സ്ഥലത്ത് എത്താൻ കഴിയുന്നില്ലെങ്കിൽ അവസാന ഉപായമായി ബലമുള്ള മൾട്ടി-സ്റ്റോറി കോൺക്രീറ്റ് കെട്ടിടത്തിന്റെ മുകൾ നിലയിലേക്ക് പോകുക.',
      ],
      after: [
        'Stay away from the coast until officials confirm the tsunami threat has fully passed - later waves can be larger than the first.',
        'Avoid floodwater and debris near the shoreline; it can contain sharp debris and contamination.',
      ],
      afterMl: [
        'അധികൃതർ സുനാമി ഭീഷണി പൂർണമായി ഒഴിഞ്ഞെന്ന് സ്ഥിരീകരിക്കുന്നത് വരെ തീരത്ത് നിന്ന് അകന്ന് നിൽക്കുക - പിന്നീട് വരുന്ന തിരമാലകൾ ആദ്യത്തേതിനേക്കാൾ വലുതാകാം.',
        'തീരപ്രദേശത്തെ വെള്ളപ്പൊക്ക ജലവും അവശിഷ്ടങ്ങളും ഒഴിവാക്കുക - മൂർച്ചയുള്ള അവശിഷ്ടങ്ങളും മലിനീകരണവും ഉണ്ടാകാം.',
      ],
      dontDo: [
        'Never go to the shore to watch or photograph an approaching tsunami.',
        'Don\'t assume the danger is over after the first wave - a tsunami is a series of waves.',
        'Don\'t wait for an official siren if you feel strong shaking or see the sea retreat - act immediately.',
      ],
      dontDoMl: [
        'വരുന്ന സുനാമി കാണാനോ ഫോട്ടോ എടുക്കാനോ ഒരിക്കലും തീരത്തേക്ക് പോകരുത്.',
        'ആദ്യ തിരമാലയ്ക്ക് ശേഷം അപകടം കഴിഞ്ഞെന്ന് കരുതരുത് - സുനാമി ഒരു തിരമാലാ പരമ്പരയാണ്.',
        'ശക്തമായ നിലയനക്കം അനുഭവപ്പെടുകയോ കടൽ പിൻവാങ്ങുന്നത് കാണുകയോ ചെയ്താൽ ഔദ്യോഗിക സൈറൺ കാത്തുനിൽക്കാതെ ഉടൻ പ്രവർത്തിക്കുക.',
      ],
    ),
    DisasterGuide(
      id: 'wildfire',
      name: 'Forest / Wild Fire',
      nameMl: 'കാട്ടുതീ',
      shortDescription: 'Fast-moving fires in dry forest and hill areas, risk peaks in summer months',
      shortDescriptionMl: 'വരണ്ട വനം, മലയോര പ്രദേശങ്ങളിൽ അതിവേഗം പടരുന്ന തീ - വേനൽക്കാലത്ത് അപകട സാധ്യത കൂടുതൽ',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFEA580C),
      survivalData: [
        GuideFact(
          label: 'Spread speed', labelMl: 'പടരുന്ന വേഗത',
          value: 'Can outrun a person uphill/with wind', valueMl: 'മലകയറ്റത്തിലും കാറ്റിലും ഒരാളെക്കാൾ വേഗത്തിൽ പടരാം',
          icon: Icons.speed_rounded,
        ),
        GuideFact(
          label: 'Smoke risk', labelMl: 'പുക അപകടം',
          value: 'Inhalation often more dangerous than flame', valueMl: 'പലപ്പോഴും തീജ്വാലയേക്കാൾ ശ്വസന അപകടം കൂടുതൽ',
          icon: Icons.air_rounded,
        ),
        GuideFact(
          label: 'Defensible gap', labelMl: 'പ്രതിരോധ ഇടം',
          value: 'Clear dry vegetation near your home', valueMl: 'വീടിന് സമീപം വരണ്ട ചെടികൾ നീക്കം ചെയ്യുക',
          icon: Icons.yard_rounded,
        ),
        GuideFact(
          label: 'Evacuation trigger', labelMl: 'ഒഴിപ്പിക്കൽ സൂചന',
          value: 'Leave early - don\'t wait to see flames', valueMl: 'നേരത്തെ പോകുക - തീ കാണുന്നത് വരെ കാത്തിരിക്കരുത്',
          icon: Icons.directions_run_rounded,
        ),
      ],
      before: [
        'If near forest/hill areas, keep dry leaves and vegetation cleared away from your home.',
        'Keep an evacuation bag ready during the dry season, with documents, water and a torch.',
        'Know at least two routes out of your area in case one is blocked by fire or smoke.',
      ],
      beforeMl: [
        'വനം/മലയോര പ്രദേശത്തിനടുത്താണെങ്കിൽ വീടിന് ചുറ്റും വരണ്ട ഇലകളും ചെടികളും നീക്കം ചെയ്യുക.',
        'വേനൽക്കാലത്ത് രേഖകൾ, വെള്ളം, ടോർച്ച് എന്നിവയടങ്ങിയ ഒഴിപ്പിക്കൽ ബാഗ് തയ്യാറാക്കി വയ്ക്കുക.',
        'തീയോ പുകയോ ഒരു വഴി തടഞ്ഞാൽ ഉപയോഗിക്കാൻ കുറഞ്ഞത് രണ്ട് വഴികളെങ്കിലും അറിഞ്ഞിരിക്കുക.',
      ],
      during: [
        'Evacuate early when advised - don\'t wait until fire is visibly close, as smoke and wind can accelerate spread rapidly.',
        'Cover your nose and mouth with a damp cloth to reduce smoke inhalation while moving to safety.',
        'Move away from the fire in a direction away from wind, and avoid narrow uphill routes where fire moves fastest.',
        'If trapped, look for a cleared area, road, or body of water and stay low to avoid smoke.',
      ],
      duringMl: [
        'നിർദ്ദേശിക്കുമ്പോൾ നേരത്തെ തന്നെ ഒഴിഞ്ഞുപോകുക - തീ കാഴ്ചയിൽ അടുക്കുന്നത് വരെ കാത്തിരിക്കരുത്, പുകയും കാറ്റും അതിവേഗം പടരാൻ കാരണമാകും.',
        'സുരക്ഷിത സ്ഥലത്തേക്ക് നീങ്ങുമ്പോൾ പുക ശ്വസിക്കുന്നത് കുറയ്ക്കാൻ നനഞ്ഞ തുണി കൊണ്ട് മൂക്കും വായും മൂടുക.',
        'കാറ്റിന് എതിർദിശയിലേക്ക് തീയിൽ നിന്ന് അകന്ന് നീങ്ങുക; തീ അതിവേഗം പടരുന്ന ഇടുങ്ങിയ കയറ്റം വഴികൾ ഒഴിവാക്കുക.',
        'കുടുങ്ങിപ്പോയാൽ വൃത്തിയാക്കിയ സ്ഥലം, റോഡ്, ജലാശയം എന്നിവ കണ്ടെത്തി പുക ഒഴിവാക്കാൻ താഴ്ന്നു നിൽക്കുക.',
      ],
      after: [
        'Don\'t return until authorities confirm it\'s safe - hotspots can reignite for days.',
        'Watch for weakened trees and hot ash pits when walking through a burned area.',
      ],
      afterMl: [
        'അധികൃതർ സുരക്ഷിതമെന്ന് സ്ഥിരീകരിക്കുന്നത് വരെ മടങ്ങിവരരുത് - ചൂടുള്ള സ്ഥലങ്ങൾ ദിവസങ്ങളോളം വീണ്ടും കത്താം.',
        'കത്തിയ പ്രദേശത്തിലൂടെ നടക്കുമ്പോൾ ബലക്ഷയമുള്ള മരങ്ങളും ചൂടുള്ള ചാരക്കുഴികളും ശ്രദ്ധിക്കുക.',
      ],
      dontDo: [
        'Never try to outrun a fire moving uphill - fire travels faster uphill than most people can run.',
        'Don\'t drive through smoke with low visibility - pull over safely and wait if you can\'t see the road.',
      ],
      dontDoMl: [
        'മലകയറ്റത്തിൽ പടരുന്ന തീയെ ഒരിക്കലും മറികടക്കാൻ ശ്രമിക്കരുത് - തീ മലകയറ്റത്തിൽ മിക്ക ആളുകൾക്കും ഓടാൻ കഴിയുന്നതിലും വേഗത്തിൽ സഞ്ചരിക്കും.',
        'കാഴ്ച കുറഞ്ഞ പുകയിലൂടെ വാഹനമോടിക്കരുത് - റോഡ് കാണാൻ കഴിയുന്നില്ലെങ്കിൽ സുരക്ഷിതമായി ഒതുക്കി കാത്തിരിക്കുക.',
      ],
    ),
  ];

  static DisasterGuide byId(String id) => guides.firstWhere((g) => g.id == id, orElse: () => guides.first);
}
