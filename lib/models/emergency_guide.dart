import 'package:flutter/material.dart';

/// Static, offline-first survival reference shown in the Emergency Guide.
/// This intentionally ships as bundled data (not an API call) so it's still
/// readable with no signal - the moment it's most likely to be needed.
class DisasterGuide {
  final String id;
  final String name;
  final String shortDescription;
  final IconData icon;
  final Color color;

  /// What to prepare / watch for before it happens.
  final List<String> before;

  /// What to actually do while it is happening.
  final List<String> during;

  /// What to do once it has passed.
  final List<String> after;

  /// Short, high-signal "never do this" list - kept separate from [during]
  /// so it can be rendered with stronger visual warning styling.
  final List<String> dontDo;

  /// Core survival facts: how much time you typically have, what kit to
  /// keep ready, key numbers to know, etc.
  final List<GuideFact> survivalData;

  const DisasterGuide({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.icon,
    required this.color,
    required this.before,
    required this.during,
    required this.after,
    required this.dontDo,
    required this.survivalData,
  });
}

class GuideFact {
  final String label;
  final String value;
  final IconData icon;
  const GuideFact({required this.label, required this.value, required this.icon});
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
      shortDescription: 'Rising water from heavy rain, dam release or overflowing rivers',
      icon: Icons.water_rounded,
      color: Color(0xFF3B82F6),
      survivalData: [
        GuideFact(label: 'Typical warning time', value: '6–48 hrs (monsoon/dam alerts)', icon: Icons.timer_outlined),
        GuideFact(label: 'Danger water depth', value: '15 cm can knock you down', icon: Icons.height_rounded),
        GuideFact(label: 'Vehicle danger', value: '30 cm can sweep away a car', icon: Icons.directions_car_filled_rounded),
        GuideFact(label: 'Go-bag essentials', value: 'ID copies, meds, torch, whistle, water', icon: Icons.backpack_rounded),
      ],
      before: [
        'Keep an emergency kit ready: torch, power bank, whistle, medicines, copies of ID/documents in a waterproof pouch.',
        'Know your district\'s flood alert level (Green/Yellow/Orange/Red) and check it daily during monsoon in the WeBAlert Weather tab.',
        'Identify the nearest relief camp / high ground and the safest route to it before water rises.',
        'Move vehicles, important documents and valuables to an upper floor if you\'re in a known flood-prone area.',
        'Charge phones and power banks fully whenever a Yellow alert or higher is issued for your district.',
      ],
      during: [
        'Move immediately to higher ground or an upper floor - don\'t wait for water to reach your doorstep.',
        'Switch off the main electricity supply and gas connection before water enters the house.',
        'If trapped, go to the highest point in the building and signal for help (torch, bright cloth, whistle).',
        'Use the SOS button in WeBAlert to alert your Safety Circle and rescuers with your live location.',
        'Drink only stored or boiled water; avoid floodwater completely, even for washing.',
      ],
      after: [
        'Don\'t return home until authorities officially declare it safe.',
        'Avoid walking or driving through standing water - it may hide open drains, live wires or debris.',
        'Get drinking water tested or boil it before use; discard food that touched floodwater.',
        'Disinfect the house before living in it again, and watch for signs of water-borne illness for the next 1–2 weeks.',
        'Document damage with photos for insurance/relief claims before cleanup.',
      ],
      dontDo: [
        'Never walk or drive through moving water, even if it looks shallow.',
        'Don\'t touch electrical switches or equipment while standing in water.',
        'Don\'t drink or cook with floodwater or well water until it\'s tested.',
        'Don\'t go sightseeing near flooded rivers/dams - banks can collapse without warning.',
      ],
    ),
    DisasterGuide(
      id: 'landslide',
      name: 'Landslide',
      shortDescription: 'Sudden slope collapse on hills/highlands, common in Kerala\'s Western Ghats during heavy rain',
      icon: Icons.terrain_rounded,
      color: Color(0xFF92400E),
      survivalData: [
        GuideFact(label: 'Typical warning time', value: 'Seconds to minutes - often no warning', icon: Icons.timer_outlined),
        GuideFact(label: 'High-risk trigger', value: '>24hr continuous heavy rain on slopes', icon: Icons.water_drop_rounded),
        GuideFact(label: 'Escape direction', value: 'Sideways, across the slope - not downhill', icon: Icons.moving_rounded),
        GuideFact(label: 'Warning sound', value: 'Rumbling, cracking trees, sudden stream muddiness', icon: Icons.hearing_rounded),
      ],
      before: [
        'If you live on or below a steep slope in a landslide-prone area, know your evacuation route in advance.',
        'Watch for warning signs: new cracks in ground/walls, tilting trees or fences, doors/windows sticking suddenly.',
        'A sudden increase in stream water flow followed by a decrease, and water turning muddy, is an early warning sign.',
        'During Orange/Red alerts for hilly districts, avoid unnecessary travel and stay alert overnight - landslides often occur when people are asleep.',
        'Keep footwear and a torch by your bed during heavy-rain nights in high-risk zones.',
      ],
      during: [
        'If you hear rumbling, cracking trees or a roaring sound, move away immediately - don\'t stop to gather belongings.',
        'Move sideways, out of the debris path, rather than trying to outrun it downhill.',
        'If escape isn\'t possible, curl into a tight ball and protect your head with your arms.',
        'Get away from the slope path and river valleys below it - debris and mud can travel much further than expected.',
        'Alert neighbours if you can do so safely; use WeBAlert SOS to share your location with your Safety Circle.',
      ],
      after: [
        'Stay away from the slide area - additional slides are common in the same spot for hours or days after.',
        'Report broken utility lines (gas, electric, water) to authorities rather than approaching them yourself.',
        'Check for injured or trapped people near the edges of the slide, without entering the debris zone yourself.',
        'Have a structural engineer inspect your home if it\'s near the slide before re-entering.',
      ],
      dontDo: [
        'Never build or stay in temporary shelter directly below a steep, saturated slope.',
        'Don\'t return to a slide area to retrieve belongings - it can move again with no warning.',
        'Don\'t assume a slope is safe just because it hasn\'t slid before this monsoon.',
      ],
    ),
    DisasterGuide(
      id: 'earthquake',
      name: 'Earthquake',
      shortDescription: 'Ground shaking from tectonic movement - low but non-zero risk across Kerala',
      icon: Icons.vibration_rounded,
      color: Color(0xFFB45309),
      survivalData: [
        GuideFact(label: 'Shaking duration', value: 'Usually 20–60 seconds', icon: Icons.timer_outlined),
        GuideFact(label: 'Action rule', value: 'Drop, Cover, Hold On - within 1–2 sec', icon: Icons.bolt_rounded),
        GuideFact(label: 'Aftershocks', value: 'Can continue for hours to days', icon: Icons.waves_rounded),
        GuideFact(label: 'Safe distance from building', value: '~1.5x building height, if outdoors', icon: Icons.straighten_rounded),
      ],
      before: [
        'Secure heavy furniture, cupboards and water heaters to walls so they can\'t topple.',
        'Know the "Drop, Cover, Hold On" action and practise it with family, especially children.',
        'Identify safe spots in each room - under sturdy furniture, against interior walls, away from glass and tall shelves.',
        'Keep an emergency kit with water, food, torch, first-aid and a whistle accessible at all times.',
      ],
      during: [
        'Drop to the ground immediately, take Cover under a sturdy table/desk, and Hold On until shaking stops.',
        'If indoors, stay indoors - most injuries happen from people running outside during shaking.',
        'If outdoors, move to open ground away from buildings, trees and power lines.',
        'If driving, pull over away from bridges/overpasses and stay in the vehicle with the seatbelt on.',
        'If in bed, stay there and cover your head with a pillow rather than getting up.',
      ],
      after: [
        'Expect aftershocks - keep following Drop, Cover, Hold On each time the ground shakes.',
        'Check yourself and others for injuries before moving; only move an injured person if they\'re in immediate danger.',
        'Inspect for gas leaks (smell, hissing) and structural damage (cracks, tilting) before re-entering a building.',
        'Avoid using elevators, and stay away from damaged buildings, bridges and coastlines (in case of a follow-on tsunami risk).',
      ],
      dontDo: [
        'Never run outside or use stairs/elevators during active shaking.',
        'Don\'t stand in a doorway - in modern buildings it\'s not safer than sturdy cover.',
        'Don\'t light matches or use open flames if you smell gas.',
      ],
    ),
    DisasterGuide(
      id: 'cyclone',
      name: 'Cyclone / High Wind',
      shortDescription: 'Coastal storm systems bringing destructive wind, storm surge and heavy rain',
      icon: Icons.cyclone_rounded,
      color: Color(0xFF6D28D9),
      survivalData: [
        GuideFact(label: 'Typical warning time', value: '24–72 hrs (IMD cyclone bulletins)', icon: Icons.timer_outlined),
        GuideFact(label: 'Danger zone', value: 'Coastal belt + low-lying estuaries', icon: Icons.beach_access_rounded),
        GuideFact(label: 'Storm surge risk', value: 'Can raise sea level several metres', icon: Icons.waves_rounded),
        GuideFact(label: 'Eye calm ≠ over', value: 'Winds return from opposite direction', icon: Icons.warning_amber_rounded),
      ],
      before: [
        'Follow IMD/KSDMA cyclone bulletins closely from the moment a depression is announced.',
        'Secure or bring indoors loose outdoor items (signboards, sheets, potted plants) that can become projectiles.',
        'Stock up on drinking water, non-perishable food, torches and charged power banks for several days.',
        'If you\'re in a coastal or estuary evacuation zone, move to the designated shelter as soon as evacuation is announced - don\'t wait for the storm to arrive.',
      ],
      during: [
        'Stay indoors, away from windows and glass doors; shelter in an interior room on the lowest safe floor.',
        'If the calm "eye" passes over, stay inside - winds will resume violently from the opposite direction shortly after.',
        'Do not go outside to inspect damage or take photos during any lull in the storm.',
        'If flooding starts, move to higher floors but stay away from the roof unless water is life-threatening.',
      ],
      after: [
        'Wait for an official all-clear before going outside - fallen power lines and unstable structures are major post-cyclone hazards.',
        'Avoid floodwater and standing water; it may be electrically charged from downed lines.',
        'Watch for weakened trees and structures that can collapse even after wind has died down.',
        'Boil or treat drinking water until officials confirm supply is safe.',
      ],
      dontDo: [
        'Never go out during the "eye" of the storm thinking it has passed.',
        'Don\'t use candles near damaged gas lines - use torches instead.',
        'Don\'t drive through areas with downed power lines or storm debris.',
      ],
    ),
    DisasterGuide(
      id: 'lightning',
      name: 'Lightning / Thunderstorm',
      shortDescription: 'Frequent during Kerala\'s pre-monsoon and monsoon storms',
      icon: Icons.flash_on_rounded,
      color: Color(0xFFF59E0B),
      survivalData: [
        GuideFact(label: '30-30 rule', value: 'Thunder <30s after flash = go indoors', icon: Icons.timer_outlined),
        GuideFact(label: 'Wait after last thunder', value: '30 minutes before going back out', icon: Icons.hourglass_bottom_rounded),
        GuideFact(label: 'Strike distance', value: 'Can strike 15+ km from the storm core', icon: Icons.social_distance_rounded),
        GuideFact(label: 'Safest place', value: 'Enclosed building or hard-top vehicle', icon: Icons.home_rounded),
      ],
      before: [
        'Check WeBAlert weather alerts for thunderstorm warnings before farm work, fishing or outdoor travel.',
        'Plan outdoor activities for times when no storms are forecast, especially in open fields or near water.',
        'If you hear thunder, treat it as a signal to head indoors - don\'t wait to see lightning first.',
      ],
      during: [
        'Get inside a sturdy building or hard-topped vehicle immediately - avoid open sheds, tents or bus stops.',
        'Stay away from windows, plumbing and corded electronics; avoid using landline phones.',
        'If caught outdoors with no shelter, crouch low on the balls of your feet, minimising contact with the ground, and get away from tall isolated trees, poles and water.',
        'Avoid open fields, hilltops, and being the tallest object around; spread out from groups of people.',
      ],
      after: [
        'Wait at least 30 minutes after the last thunderclap before resuming outdoor activity.',
        'If someone is struck by lightning, call for emergency help immediately and begin CPR if they\'re unresponsive and not breathing - a lightning victim carries no residual charge and is safe to touch.',
      ],
      dontDo: [
        'Never shelter under a lone tree, tower or pole during a thunderstorm.',
        'Don\'t stand in open water or near metal fences/railings.',
        'Don\'t use a wired telephone or touch plumbing during a storm.',
      ],
    ),
    DisasterGuide(
      id: 'heatwave',
      name: 'Heat Wave',
      shortDescription: 'Prolonged abnormally high temperatures, increasingly common in Kerala summers',
      icon: Icons.thermostat_rounded,
      color: Color(0xFFDC2626),
      survivalData: [
        GuideFact(label: 'High-risk hours', value: '12 PM – 4 PM (peak sun)', icon: Icons.wb_sunny_rounded),
        GuideFact(label: 'Hydration target', value: '2.5–3 L water/day, more if outdoors', icon: Icons.local_drink_rounded),
        GuideFact(label: 'Heatstroke sign', value: 'Hot dry skin + confusion = medical emergency', icon: Icons.emergency_rounded),
        GuideFact(label: 'Highest-risk group', value: 'Infants, elderly, outdoor labourers', icon: Icons.groups_rounded),
      ],
      before: [
        'Check the day\'s heat forecast and plan strenuous outdoor work for early morning or evening.',
        'Keep ORS packets or a homemade salt-sugar-water solution at home.',
        'Ensure elderly family members and infants have access to cool spaces and fluids throughout the day.',
      ],
      during: [
        'Drink water regularly even if you don\'t feel thirsty; avoid alcohol, tea and coffee which dehydrate you.',
        'Wear light-coloured, loose cotton clothing and use an umbrella or hat outdoors.',
        'Avoid direct sun between 12 PM and 4 PM; rest in shade or a cooled space if you must be outside.',
        'Never leave children, elderly people or pets in a parked vehicle, even briefly.',
        'Watch for heat exhaustion signs (heavy sweating, weakness, nausea) and move the person to a cool place, giving fluids immediately.',
      ],
      after: [
        'Continue rehydrating over the following day even once temperatures drop.',
        'Monitor anyone who showed heat-exhaustion symptoms for delayed complications and seek medical care if they don\'t improve.',
      ],
      dontDo: [
        'Never leave anyone in a parked, closed vehicle in the heat.',
        'Don\'t do heavy physical work outdoors during peak afternoon heat.',
        'Don\'t ignore heatstroke signs (no sweating, hot dry skin, confusion) - it\'s a medical emergency, call for help immediately.',
      ],
    ),
    DisasterGuide(
      id: 'tsunami',
      name: 'Tsunami',
      shortDescription: 'Rare but severe wave surge following undersea earthquakes, relevant to Kerala\'s coastline',
      icon: Icons.tsunami_rounded,
      color: Color(0xFF0E7490),
      survivalData: [
        GuideFact(label: 'Natural warning', value: 'Strong coastal earthquake shaking', icon: Icons.vibration_rounded),
        GuideFact(label: 'Sea behaviour warning', value: 'Sudden, unusual sea withdrawal', icon: Icons.remove_red_eye_rounded),
        GuideFact(label: 'Time to act', value: 'Minutes, not hours - move immediately', icon: Icons.timer_outlined),
        GuideFact(label: 'Safe elevation', value: '30m+ above sea level or 3km inland', icon: Icons.terrain_rounded),
      ],
      before: [
        'If you live or are staying on the coast, know the inland evacuation route to higher ground in advance.',
        'Treat a strong earthquake felt near the coast, or an official tsunami warning, as reason to evacuate immediately.',
      ],
      during: [
        'If you feel strong ground shaking near the coast, or see the sea suddenly recede far beyond normal, move inland/uphill immediately - don\'t wait for an official announcement.',
        'Move on foot if roads are jammed; every metre of elevation and distance from shore matters.',
        'Do not stop to collect belongings or watch the wave - tsunamis can arrive as a series of waves over hours.',
        'If you can\'t reach high ground, go to the upper floor of a strong, multi-storey concrete building as a last resort.',
      ],
      after: [
        'Stay away from the coast until officials confirm the tsunami threat has fully passed - later waves can be larger than the first.',
        'Avoid floodwater and debris near the shoreline; it can contain sharp debris and contamination.',
      ],
      dontDo: [
        'Never go to the shore to watch or photograph an approaching tsunami.',
        'Don\'t assume the danger is over after the first wave - a tsunami is a series of waves.',
        'Don\'t wait for an official siren if you feel strong shaking or see the sea retreat - act immediately.',
      ],
    ),
    DisasterGuide(
      id: 'wildfire',
      name: 'Forest / Wild Fire',
      shortDescription: 'Fast-moving fires in dry forest and hill areas, risk peaks in summer months',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFEA580C),
      survivalData: [
        GuideFact(label: 'Spread speed', value: 'Can outrun a person uphill/with wind', icon: Icons.speed_rounded),
        GuideFact(label: 'Smoke risk', value: 'Inhalation often more dangerous than flame', icon: Icons.air_rounded),
        GuideFact(label: 'Defensible gap', value: 'Clear dry vegetation near your home', icon: Icons.yard_rounded),
        GuideFact(label: 'Evacuation trigger', value: 'Leave early - don\'t wait to see flames', icon: Icons.directions_run_rounded),
      ],
      before: [
        'If near forest/hill areas, keep dry leaves and vegetation cleared away from your home.',
        'Keep an evacuation bag ready during the dry season, with documents, water and a torch.',
        'Know at least two routes out of your area in case one is blocked by fire or smoke.',
      ],
      during: [
        'Evacuate early when advised - don\'t wait until fire is visibly close, as smoke and wind can accelerate spread rapidly.',
        'Cover your nose and mouth with a damp cloth to reduce smoke inhalation while moving to safety.',
        'Move away from the fire in a direction away from wind, and avoid narrow uphill routes where fire moves fastest.',
        'If trapped, look for a cleared area, road, or body of water and stay low to avoid smoke.',
      ],
      after: [
        'Don\'t return until authorities confirm it\'s safe - hotspots can reignite for days.',
        'Watch for weakened trees and hot ash pits when walking through a burned area.',
      ],
      dontDo: [
        'Never try to outrun a fire moving uphill - fire travels faster uphill than most people can run.',
        'Don\'t drive through smoke with low visibility - pull over safely and wait if you can\'t see the road.',
      ],
    ),
  ];

  static DisasterGuide byId(String id) => guides.firstWhere((g) => g.id == id, orElse: () => guides.first);
}
