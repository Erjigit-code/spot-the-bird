import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spot_the_bird/models/bird_post_models.dart';
import 'package:spot_the_bird/services/sqflite.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(birdPosts: [], status: BirdPostStatus.initial));

  final dbHelper = DataBaseHelper.instance;

  //
  //
  Future<void> loadPosts() async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = [];
    final List<Map<String, dynamic>> rows = await dbHelper.qureyAllRows();

    if (rows.length == 0) {
      print('Rows are empty');
    } else {
      print('Rows have data');

      for (var row in rows) {
        birdPosts.add(BirdModel(
            id: row["id"],
            birdName: row["birdName"],
            latitude: row["latitude"],
            longitude: row["longitude"],
            birdDescription: row["birdDescription"],
            image: File(row["url"])));
      }
    }
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  //
  //
  Future<void> addBirdPost(BirdModel birdModel) async {
    //
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;
    birdPosts.add(birdModel);

    Map<String, dynamic> row = {
      DataBaseHelper.columnTitle: birdModel.birdName,
      DataBaseHelper.columnDescription: birdModel.birdDescription,
      DataBaseHelper.latitude: birdModel.latitude,
      DataBaseHelper.longitude: birdModel.longitude,
      DataBaseHelper.columnUrl: birdModel.image.path
    };
    final int? id = await dbHelper.insert(row);

    birdModel.id = id;

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  //
  //
  Future<void> removeBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.removeWhere((element) => element == birdModel);

    await dbHelper.delete(birdModel.id!);

    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }
}
