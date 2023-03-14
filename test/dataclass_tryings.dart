import 'dart:convert';

import 'package:ari_utils/ari_utils.dart';

class Address{
  Address();
  factory Address.fromJson()=>Address();
  factory Address.fromMap(address)=>Address();
}


@Dataclass()
class Person {
  Address address;
  List<Person>? family;
  String name;

  @Generate()


//   Person({required this.address, required this.name, this.family});
//
//
//   Map get __attributes => {"address": address, "family": family, "name": name};
//
//
//   @override
//   int get hashCode => address.hashCode ^ family.hashCode ^ name.hashCode;
//  
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           (other is Person && runtimeType == other.runtimeType &&
//               equals(address, other.address) && equals(family, other.family) && equals(name, other.name));
//
//  
//
//   Person copyWithPerson(Address? address, List<Person>? family, String? name) =>
//       Person(address: address ?? this.address, family: family ?? this.family, name: name ?? this.name);
//
//  
//
//   String toJson()=>jsonEncode(toMap());
//   Map toMap()=> {'__type': 'Person', ...nestedJsonMap(__attributes)};
//
//
//   factory Person.fromMap(Map map){
//
//     Address address = Address.fromJson();
//     // List? family_temp = recursiveFromJsonIterable(map['family']);
//     List? family_temp = map['family'];
//     List<Person>? family;
//     String name = map['name'];
//
//     if (family_temp == null){List<Person>? family = null;}
//     else{List<Person>? family =
//     List<Person>.from(family_temp);
//     }
//
//     return Person(address: address, family: family, name: name);
//   }
//   factory fromJson(String json) => Person.fromMap(jsonDecode(json));
//
// // Precede class name in factory constructor
// // Initialize variable in part_declarations
// // Take out ? in else of nullable casting
//

  // Person({required this.address, required this.name, this.family});
  // factory Person.defaultConstructor({required address, required name, family}) => Person(address: address, name: name, family: family);

  // <editor-fold desc="Dataclass Section">
  // <Dataclass>
  // WARNING! Any code written in this section is subject to be overwritten! Please move any code you wish to save outside
  // of this section. Or else the next time the code generation runs your code will be overwritten! (Even if you disable
  // said functions in the @Dataclass() annotation. If you wish to keep the capabilities of your class as a Metaclass and
  // disable the code generation, change the annotation to @Metaclass).

  Person({required this.address, required this.name, this.family});

  factory Person.staticConstructor({required address, required name, family}) => Person(address: address, name: name, family: family);

  Map<String, dynamic> get attributes__ => {"address": address, "family": family, "name": name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Person && runtimeType == other.runtimeType && equals(address, other.address) && equals(family, other.family) && equals(name, other.name));

  @override
  int get hashCode => address.hashCode ^ family.hashCode ^ name.hashCode;

  @override
  String toString() => 'Person(address: $address, family: $family, name: $name)';

  Person copyWithPerson(Address? address, List<Person>? family, String? name) => Person(address: address ?? this.address, family: family ?? this.family, name: name ?? this.name);

  String toJson()=>jsonEncode(toMap());
  Map<String, dynamic> toMap()=> {'__type': 'Person', ...nestedJsonMap(attributes__)};

  // factory Person.fromJson(String json) => Person.fromMap(jsonDecode(json));

  // factory Person.fromMap(Map map){
  //
  //   Address address = mapFactory['Address']!(map['address']);
  //   List? family_temp = recursiveFromJsonIterable(map['family']);
  //   String name = map['name'];
  //
  //   List<Person>? family =
  //   family_temp == null ? null :
  //   List<Person>.from(family_temp);
  //
  //   return Person(address: address, family: family, name: name);
  // }
// </Dataclass>

// </editor-fold>

  // factory Person.fromJson(String json) => Person.fromMap(jsonDecode(json));
  //
  // factory Person.fromMap(Map map){
  //
  //   // Address address = jsonFactoryMap['Address']!(map['address']);
  //   // List? family_temp = recursiveFromJsonIterable(map['family']);
  //   Address address = Address();
  //   List? family_temp = map['family'];
  //   String name = map['name'];
  //
  //   List<Person>? family =
  //     family_temp == null ? null :
  //     List<Person>.from(family_temp);
  //
  //   return Person(address: address, family: family, name: name);
  // }

}

abstract class JsonMixin {
  Map<String, dynamic> get $attributes;
  @override
  int get hashCode;
  @override
  bool operator ==(Object other);
  toMap() => {'Type:': runtimeType, ...$attributes};
  toJson() => jsonEncode($attributes);



}

void main(){
  ReflectedClass person = ReflectedClass(
      name: 'Person',
      referenceType: ReflectedType.create(Person, 'Person'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [Attribute.create('address', ReflectedType.create(Address, 'Address'), false, false, false, false, false, null), Attribute.create('family', ReflectedType.create(List, 'List<Person>?'), false, false, false, false, false, null), Attribute.create('name', ReflectedType.create(String, 'String'), false, false, false, false, false, null)],
      getters: [],
      methods: [],
      parent: null);
}