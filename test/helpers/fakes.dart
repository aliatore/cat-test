import 'dart:async';

import 'package:cat_directory_app/core/network/network_info.dart';
import 'package:cat_directory_app/core/utils/clock.dart';
import 'package:cat_directory_app/features/breeds/data/models/breed_dto.dart';

class FakeClock extends Clock {
  FakeClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;

  void advance(Duration duration) => current = current.add(duration);
}

class FakeNetworkInfo implements NetworkInfo {
  FakeNetworkInfo({this.online = true});

  bool online;
  final _changes = StreamController<bool>.broadcast();

  void emit({required bool online}) {
    this.online = online;
    _changes.add(online);
  }

  @override
  Future<bool> get isConnected async => online;

  @override
  Stream<bool> get onStatusChange => _changes.stream;
}

BreedsPageDto breedsPageDto(
  int page, {
  int perPage = 2,
  int lastPage = 3,
  List<String>? names,
}) {
  final breeds = names ?? ['Breed $page-A', 'Breed $page-B'];
  return BreedsPageDto(
    currentPage: page,
    lastPage: lastPage,
    perPage: perPage,
    total: lastPage * perPage,
    data: [
      for (final name in breeds)
        BreedDto(
          breed: name,
          country: 'Egypt',
          origin: 'Natural',
          coat: 'Short',
          pattern: 'Spotted',
        ),
    ],
  );
}
