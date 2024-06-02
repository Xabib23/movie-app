// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteMovieModelAdapter extends TypeAdapter<FavouriteMovieModel> {
  @override
  final int typeId = 0;

  @override
  FavouriteMovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteMovieModel(
      id: fields[0] as int?,
      title: fields[1] as String?,
      genra: fields[2] as String?,
      releaseDate: fields[3] as String?,
      runtime: fields[4] as int?,
      posterPath: fields[5] as String?,
      score: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteMovieModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.genra)
      ..writeByte(3)
      ..write(obj.releaseDate)
      ..writeByte(4)
      ..write(obj.runtime)
      ..writeByte(5)
      ..write(obj.posterPath)
      ..writeByte(6)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteMovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
