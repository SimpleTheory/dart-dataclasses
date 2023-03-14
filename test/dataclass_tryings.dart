import 'dart:convert';

import 'package:dataclasses/dataclasses.dart';

import 'trying_metadata.dart';

class Address {
  Address();

  factory Address.fromJson() => Address();

  factory Address.fromMap(address) => Address();
}

@Dataclass()
class Person {
  Address address;
  List<Person>? family;
  String name;

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

  factory Person.fromJson(String json) => Person.fromMap(jsonDecode(json));

  factory Person.fromMap(Map map){

    Address address = dejsonify(map['address']);
    List? familyTemp = dejsonify(map['family']);
    String name = map['name'];

    List<Person>? family =
    familyTemp == null ? null :
    List<Person>.from(familyTemp);

    return Person(address: address, family: family, name: name);
  }
// </Dataclass>

// </editor-fold>
}

enum Letters { a, b, c }

abstract class JsonMixin {
  Map<String, dynamic> get $attributes;

  @override
  int get hashCode;

  @override
  bool operator ==(Object other);

  toMap() => {'Type:': runtimeType, ...$attributes};

  toJson() => jsonEncode($attributes);
}

void main() {
  ReflectedClass person = ReflectedClass(
      name: 'Person',
      referenceType: ReflectedType.create(Person, 'Person'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('address', ReflectedType.create(Address, 'Address'),
            false, true, false, false, false, null),
        Attribute.create('family', ReflectedType.create(List, 'List<Person>?'),
            false, true, false, false, false, null),
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null)
      ],
      getters: [],
      methods: [],
      parent: null);
  print(person.statics);
  EnumExtension refEnum = EnumExtension(
      name: 'Letters',
      referenceType: ReflectedType.create(Letters, "Letters"),
      options: [
        'a',
        'b',
        'c'
      ],
      methods: [
        Method.create("fromMap", ReflectedType.create(Letters, "Letters"),
            MethodType.factory, false, null, false, (Map<String, dynamic> map) {
          if (map['value'] == 'a') {
            return Letters.a;
          }
          if (map['value'] == 'b') {
            return Letters.b;
          }
          if (map['value'] == 'c') {
            return Letters.c;
          }
          throw Exception("Enum Letters can not instantiate from map $map");
        }),
      ]);
  print(refEnum.methods['fromJson']?.name);
}
