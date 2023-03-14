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