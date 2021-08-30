// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onno_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnnoUserAdapter extends TypeAdapter<OnnoUser> {
  @override
  final int typeId = 9;

  @override
  OnnoUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnnoUser(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      image: fields[3] as String?,
      passwordAvailable: fields[4] as bool?,
      joinDate: fields[5] as String?,
      lastLogin: fields[6] as String?,
      about: fields[7] as String?,
      socials: fields[8] as dynamic,
      gender: fields[9] as String?,
      phone: fields[10] as String?,
      email: fields[11] as String?,
      dob: fields[12] as String?,
      token: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OnnoUser obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.passwordAvailable)
      ..writeByte(5)
      ..write(obj.joinDate)
      ..writeByte(6)
      ..write(obj.lastLogin)
      ..writeByte(7)
      ..write(obj.about)
      ..writeByte(8)
      ..write(obj.socials)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.phone)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.dob)
      ..writeByte(13)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnnoUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
