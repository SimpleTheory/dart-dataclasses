import 'package:dataclasses/dataclasses.dart';

Map<String, SupportedClasses> str2reflection = {}; //$$$

dejsonify(thing){
  // Map or Recognized
  if (thing is Map){
    // Recognized
    if (str2reflection[thing['__type']]?.fromMap != null){
      return str2reflection[thing['__type']]!.fromMap!(thing);
    }
    // Map
    return dejsonifyMap(thing);
  }
  // List
  if (thing is List){
    return dejsonifyList(thing);
  }
  // Json safe type
  return thing;
}
List dejsonifyList(List list){
  return list.map((e) => dejsonify(e)).toList();

}
Map dejsonifyMap(Map map){
  return Map.from(map.map((key, value) =>
      MapEntry(dejsonify(key), dejsonify(value))));
}
// Serialize JSON

jsonify(thing) {
  try {
    return thing.toMap();
  } on NoSuchMethodError {
    if (isJsonSafe(thing)) {
      return thing;
    } else if (supportedTypeToMap(thing) != null) {
      return supportedTypeToMap(thing);
    } else if (thing is Iterable && !isMap(thing)) {
      return nestedJsonList(thing);
    } else if (isMap(thing)) {
      return nestedJsonMap(thing);
    } else {
      throw Exception('Error on handling $thing since ${thing.runtimeType} '
          'is not a base class or does not have a toJson() method');
    }
  }
}

List nestedJsonList(Iterable iter) {
  List l = [];
  for (var thing in iter) {
    l.add(jsonify(thing));
  }
  return l;
}

Map nestedJsonMap(mapLikeThing) {
  Map m = {};
  var key;
  var value;

  for (MapEntry mapEntry in mapLikeThing.entries) {
    key = jsonify(mapEntry.key);
    value = jsonify(mapEntry.value);
    m[key] = value;
  }

  return m;
}
