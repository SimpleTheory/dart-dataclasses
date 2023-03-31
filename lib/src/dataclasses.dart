import 'dart:collection';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:ari_utils/ari_utils.dart';
/// Things to do in Metadata
///   - Map ReflectedClasses to types (+swap)
///   - List of all reflected types
abstract class AbstractDataclass{
  @override
  String toString();
  @override
  int get hashCode;
  @override
  bool operator ==(Object other);
  copyWith();
  Map<String, dynamic> get $attributes;
  toMap(){throw UnimplementedError();}
  toJson() => jsonEncode($attributes);
  factory AbstractDataclass.fromJson(String json)=>AbstractDataclass.fromMap(jsonDecode(json));
  factory AbstractDataclass.fromMap(Map<String, dynamic> map) {
    // implement AbstractDataclass.fromMap
    throw UnimplementedError();
  }
}

mixin SupportedClasses{
  late Map<String, Method> methods;

  Function? get fromMap => methods['fromMap']?.referencedMethod;
  Function? get fromJson => methods['fromJson']?.referencedMethod;

  Function? get toMap => methods['toMap']?.referencedMethod;
  Function? get toJson => methods['toJson']?.referencedMethod;

  Function? get staticConstructor => methods['staticConstructor']?.referencedMethod;
}

//<editor-fold desc="Annotations">
class Dataclass {
  final bool? eq;
  final bool? toJson;
  final bool? fromJson;
  final bool? attributes;
  final bool? toStr;
  final bool? copyWith;
  final bool? all;
  final String? superFactory;
  final bool? staticConstructor;
  final bool? abstractParent;
  final bool? constructor;

  // final bool
  const Dataclass(
      {this.eq,
      this.toJson,
      this.fromJson,
      this.attributes,
      this.toStr,
      this.copyWith,
      this.all,
      this.superFactory,
      this.constructor,
      this.staticConstructor,
      this.abstractParent,
      });
}
// class Metaclass {const Metaclass();}
class Generate{
  const Generate();
}
class Super {
  /// Type + for positional parameter and do ++s relative its position.
  /// However doing an incorrect number of ++s will give an error.
  // final Type parent;
  final String param;

  const Super(this.param);
}
class FromMapOverride{
  final Type type;
  const FromMapOverride(this.type);
}
class ToMapOverride{
  final Type type;
  const ToMapOverride(this.type);
}
class StaticConstructorOverride{
  final Type type;
  const StaticConstructorOverride(this.type);
}
class CreateTests{
  final Type cls;
  final Object reference;

  const CreateTests(this.cls, this.reference);
}
class CreateTestTemplates{
  final Type cls;
  final Object reference;

  const CreateTestTemplates(this.cls, this.reference);
}
//</editor-fold>

// <editor-fold desc="Reflected Meta-classes from Python">
enum MethodType{
  normal,
  constructor,
  factory,
  namedConstructor,
  setter,
  operator
}
class Annotation {
  String name;
  List positionalParam;
  Map<String, dynamic> keywordParam;

  Annotation({
    required this.name,
    required this.positionalParam,
    required this.keywordParam,
  });

  Annotation.create(this.name, this.positionalParam, this.keywordParam);

  @override
  String toString() {
    return 'Annotation{name: $name, positionalParam: $positionalParam, keywordParam: $keywordParam}';
  }
}
class Attribute {
  String name;
  ReflectedType type;
  bool final_;
  bool static_;
  bool const_;
  bool late_;
  bool external_;
  dynamic defaultValue;
  late bool private;
  String? superParam;

  Attribute({
    required this.name,
    required this.type,
    required this.final_,
    required this.static_,
    required this.const_,
    required this.late_,
    required this.external_,
    this.defaultValue,
    this.superParam,
  }){private = name.startsWith('_');}

  Attribute.create(
      this.name,
      this.type,
      this.final_,
      this.static_,
      this.const_,
      this.late_,
      this.external_,
      this.defaultValue,
      [this.superParam]);
}
class Getter{
  ReflectedType returnType;
  String name;
  bool external_;
  bool static_;
  late bool private;
  dynamic referenceValue;

  Getter({
    required this.returnType,
    required this.name,
    required this.external_,
    required this.static_,
    this.referenceValue
  }){private = name.startsWith('_');}

  Getter.create(
      this.returnType, this.name, this.external_, this.static_, [this.referenceValue]);
}
class Method{
  // Regular
  String name;
  ReflectedType? returnType;
  MethodType methodType;
  bool static_;
  String? generics;
  bool external_;
  late bool private;
  // String parametersString  = '()';

  // Reflected
  Function? referencedMethod;

  Method({
    required this.name,
    this.returnType,
    required this.methodType,
    required this.static_,
    this.generics,
    required this.external_,
    // required this.parametersString,
    this.referencedMethod
  }){private = name.startsWith('_');}
//Method.create('DateTime', ReflectedType.create(DateTime, 'DateTime'), MethodType.constructor,
// false, null, false, null),
  Method.create(
      this.name,
      this.returnType,
      this.methodType,
      this.static_,
      this.generics,
      this.external_,
      // this.parametersString,
      this.referencedMethod);
}
class ReflectedType{
  String typeString;
  Type? referenceType;
  late bool nullable;
  // List<ReflectedType>? generics;

  ReflectedType({
    required this.typeString,
    this.referenceType,
    // this.generics,
  }){nullable = typeString.endsWith('?');}

  ReflectedType.create(this.referenceType, this.typeString)
  {nullable = typeString.endsWith('?');}
}
class ReflectedClass with SupportedClasses{
  // Regular
  String name;
  ReflectedType referenceType;
  Annotation dataclassAnnotation;
  late Map<String, Attribute> attributes;
  // late Map<String, Method> methods; //[]
  late Map<String, Getter> getters; //[]
  // Mixin and Implements to be implemented later
  Type? parent; // Maybe ReflectedType?

  // Reflection Stuff
  List<Type>? mixins;
  List<Type>? implementations;


  Map<String, Function> get staticsFactories =>
      Map.fromEntries(methods.entries.where(
              (entry) =>
          entry.value.static_ ||
              entry.value.methodType == MethodType.factory ||
              entry.value.methodType == MethodType.namedConstructor ||
              entry.value.referencedMethod != null
      ).map((entry) => MapEntry(entry.key, entry.value.referencedMethod!)));
  Map<String, Attribute> get staticAttributes => attributes.where((p0) => p0.value.static_);
  Map<String, Getter> get staticGetter => getters.where((p0) => p0.value.static_);
  Map<String, dynamic> get statics => {...staticAttributes, ...staticsFactories, ...staticAttributes};


  @override
  String toString() {
    return 'ReflectedClass{name: $name,'
        ' methods: ${methods.keys.toList()},'
        ' attributes: ${attributes.keys.toList()},'
        ' getters: ${getters.keys.toList()},'
        ' parent: $parent,'
        ' mixins: $mixins,'
        ' implementations: $implementations,'
        ' dataclassAnnotation: $dataclassAnnotation'
        '}';
  }

  ReflectedClass({
    required this.name,
    required this.referenceType,
    required this.dataclassAnnotation,
    required List<Attribute> attributes,
    required List<Method> methods,
    required List<Getter> getters,
    this.parent,
    this.mixins,
    this.implementations
}){
  this.methods = {for (Method method in methods) method.name : method};
  this.attributes = {for (Attribute attribute in attributes) attribute.name : attribute};
  this.getters = {for (Getter getter in getters) getter.name : getter};
}
}
class EnumExtension with SupportedClasses{
  String name;
  ReflectedType referenceType;
  List<String> options;

  EnumExtension({
    required List<Method> methods,
    required this.name,
    required this.referenceType,
    required this.options,
  }){
    this.methods = {for (Method method in methods) method.name : method};
    if (this.methods['fromMap'] != null && this.methods['fromJson'] == null){
      this.methods['fromJson'] = Method(
          name: 'fromJson', methodType: MethodType.factory,
          static_: false, external_: false,
          referencedMethod: (String json)=>fromMap!(jsonDecode(json))
      );
    }
  }

}
class ClassOverrides with SupportedClasses{
  late String name;
  ReflectedType referenceType;
  ClassOverrides({required this.name, required this.referenceType, required methods})
    {this.methods = methods;}
  ClassOverrides.create(this.referenceType, List<Method> methods)
    {this.methods = {for (Method e in methods) e.name: e};
     name = referenceType.referenceType!.toString();
    }
}

//</editor-fold>

// <editor-fold desc="Help Functions">
// Help Functions
// const List<Type> mapTypes = [Map, HashMap, LinkedHashMap, SplayTreeMap, UnmodifiableMapView];
bool isMap(i) =>
    i is Map ||
    i is HashMap ||
    i is LinkedHashMap ||
    i is SplayTreeMap ||
    i is UnmodifiableMapView;

bool equals(a, b) {
  DeepCollectionEquality deepEquality = const DeepCollectionEquality();
  if (a.runtimeType == b.runtimeType) {
    if (a is Iterable || isMap(a)
        // a is List
        //     || a is Set
        //     || a is Map
        //     || a is Queue
        //     || a is LinkedHashMap
        //     || a is LinkedHashSet
        //     || a is Array
        //     || a is HashMap

        ) {
      return deepEquality.equals(a, b);
    }
  }
  try{
    return a == b;}
  on NoSuchMethodError{
    return b == a;
  }
}

bool isJsonSafe(a) => a == null || a is num || a is String || a is bool;

Map? supportedTypeToMap(supportedType){
  if (supportedType is Enum){
    return supportedType.toMap();
  }
    if (supportedType is DateTime){
    return supportedType.toMap();
  }
    if (supportedType is Duration){
    return supportedType.toMap();
  }
    if (supportedType is RegExp){
    return supportedType.toMap();
  }
    if (supportedType is Uri){
    return supportedType.toMap();
  }
    if (supportedType is BigInt){
    return supportedType.toMap();
  }
    if (supportedType is Enum){
    return supportedType.toMap();
  }
    return null;

}


Function? toMapOverride(object, Map<Type, ClassOverrides> map) {
  return map[object.runtimeType]?.toJson;
}

//</editor-fold>

// <editor-fold desc="JSON Extensions">
class SupportedDefaults with SupportedClasses{
  String name;
  ReflectedType referenceType;
  late Map<String, Attribute>? attributes;
  late Map<String, Getter>? getters;
  // late Map<String, Method> methods;
  Type? parent;

  SupportedDefaults({
    required this.name,
    required this.referenceType,
    List<Getter>? getters,
    List<Attribute>? attributes,
    required List<Method> methods,
    this.parent
  }){
    this.methods = {for (Method method in methods) method.name : method};
    if (attributes != null){
      this.attributes = {for (Attribute attribute in attributes) attribute.name : attribute};}
    if (getters != null){
      this.getters = {for (Getter getter in getters) getter.name : getter};}
  }
}

extension DateTimeJson on DateTime {
  Map toMap() => {'time': toIso8601String(), '__type': 'DateTime'};
  String toJson() => jsonEncode(toMap());
  static DateTime fromMap(Map map) => DateTime.parse(map['time']!);
  static DateTime fromJson(String json) =>
      DateTimeJson.fromMap(jsonDecode(json));
  static DateTime staticConstructor({year, month, day, hours, minutes, seconds, milliseconds, microseconds})
  => DateTime(year, month, day, hours, minutes, seconds, milliseconds, microseconds);
}

extension UriJson on Uri {
  Map toMap() => {'__type': 'Uri', 'url': toString()};

  String toJson() => jsonEncode(toMap());

  static Uri fromJson(String json) => UriJson.fromMap(jsonDecode(json));

  static Uri fromMap(Map map) => Uri.parse(map['url']!);

  static Uri staticConstructor(
      {String? scheme,
      String? userInfo,
      String? host,
      int? port,
      String? path,
      Iterable<String>? pathSegments,
      String? query,
      Map<String, dynamic /*String|Iterable<String>*/ >? queryParameters,
      String? fragment}) => Uri(scheme: scheme, userInfo: userInfo, host: host,
      port: port, path: path, pathSegments: pathSegments, query: query, queryParameters: queryParameters);
}

extension BigIntJson on BigInt {
  Map toMap() => {'__type': 'BigInt', 'int': toString()};

  String toJson() => jsonEncode(toMap());

  static BigInt fromJson(String json) => BigIntJson.fromMap(jsonDecode(json));

  static BigInt fromMap(Map map) => BigInt.parse(map['int']!);

}

extension DurationJson on Duration {
  Map toMap() => {'__type': 'Duration', 'duration': inMicroseconds};

  String toJson() => jsonEncode(toMap());

  static Duration fromMap(Map map) => Duration(microseconds: map['duration']!);

  static Duration fromJson(String json) =>
      DurationJson.fromMap(jsonDecode(json));
  static Duration staticConstructor(
      {int days = 0,
      int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0}) =>
      Duration(days: days, hours: hours, minutes: minutes,
      seconds: seconds, milliseconds: milliseconds, microseconds: microseconds);
}

extension RegExpJson on RegExp {
  Map toMap() =>
      {'__type': 'RegExp', 'pattern': pattern, 'multiline': isMultiLine};

  String toJson() => jsonEncode(toMap());

  static RegExp fromMap(Map map) =>
      RegExp(map['pattern'], multiLine: map['multiline'] ?? false);

  static RegExp fromJson(String json) => RegExpJson.fromMap(jsonDecode(json));

  static RegExp staticConstructor(String source,
      {bool multiLine = false,
      bool caseSensitive = true,
      bool unicode = false,
      bool dotAll = false})=>
 RegExp(source, multiLine: multiLine, caseSensitive: caseSensitive, unicode: unicode, dotAll: dotAll);
}

extension EnumToJson on Enum {
  Map toMap() => {
        '__type': runtimeType.toString(),
        '__enum': true,
        'value': '$runtimeType.$name'
      };

  String toJson() => jsonEncode(toMap());
}



const Map<String, Function> typeFactoryDefault = {
  'Uri': UriJson.fromMap,
  'DateTime': DateTimeJson.fromMap,
  'BigInt': BigIntJson.fromMap,
  'Duration': DurationJson.fromMap,
  'RegExp': RegExpJson.fromMap
};
const Map<String, Type> string2classdefault = {
  'List': List,
  'Map': Map,
  'Set': Set,
  'Iterable': Iterable,
  'HashMap': HashMap,
  'LinkedHashSet': LinkedHashSet,
  'LinkedHashMap': LinkedHashMap,
  'Queue': Queue,
  'ListQueue': ListQueue,
  'SplayTreeSet': SplayTreeSet,
  'Uri': Uri,
  'DateTime': DateTime,
  'BigInt': BigInt,
  'Duration': Duration,
  'RegExp': RegExp
};
const Map<Type, Function> iterableInstantiator = {
  List: List.from,
  Map: Map.from,
  Set: Set.from,
  Iterable: Iterable.castFrom,
  HashMap: HashMap.from,
  LinkedHashSet: LinkedHashSet.from,
  LinkedHashMap: LinkedHashMap.from,
  Queue: Queue.from,
  ListQueue: ListQueue.from,
  SplayTreeSet: SplayTreeSet.from,
};
const Map<String, Type> iterable2type = {

};

// </editor-fold>
