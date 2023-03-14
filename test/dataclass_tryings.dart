import 'dart:convert';

import 'package:dataclasses/dataclasses.dart';

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

  Person(this.address, this.family, this.name);
}

enum Letters {
  a, b, c
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
      attributes: [Attribute.create('address', ReflectedType.create(Address, 'Address'), false, true, false, false, false, null), Attribute.create('family', ReflectedType.create(List, 'List<Person>?'), false, true, false, false, false, null), Attribute.create('name', ReflectedType.create(String, 'String'), false, false, false, false, false, null)],
      getters: [],
      methods: [],
      parent: null);
  print(person.statics);
  EnumExtension refEnum = EnumExtension(
      name: 'Letters',
      referenceType: ReflectedType.create(Letters, "Letters"),
      options: ['a', 'b', 'c'],
      methods: [
        Method.create("fromMap", ReflectedType.create(Letters, "Letters"), MethodType.factory, false, null, false, (Map<String, dynamic> map){if (map['value'] == 'a'){return Letters.a;} if (map['value'] == 'b'){return Letters.b;} if (map['value'] == 'c'){return Letters.c;} throw Exception("Enum Letters can not instantiate from map $map");}),
      ]
  );
  print(refEnum.methods['fromJson']?.name);
}