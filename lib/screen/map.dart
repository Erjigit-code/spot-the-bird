import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spot_the_bird/screen/bird_info_Screen.dart';
import '../models/bird_post_models.dart';
import 'add_bird_screen.dart';
import 'dart:io';
import 'package:bloc/bloc.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  Future<void> _pickSurotAndCreatePost(
      {required LatLng latLng, required BuildContext context}) async {
    File? image;

    final picker = ImagePicker();

    final tandalganSurot =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 40);

    if (tandalganSurot != null) {
      image = File(tandalganSurot.path);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddBirdScreen(latLng: latLng, image: image!)));
    } else {
      print('User didnt picked image');
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];
    birdPosts.forEach((post) {
      markers.add(Marker(
          width: 55,
          height: 55,
          point: LatLng(post.latitude, post.longitude),
          builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BirdPostInfoScreen(
                            birdModel: post,
                          )));
                },
                child: Container(
                  child: Image.asset("assets/bird_icon.png"),
                ),
              )));
    });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
          listener: (previousState, currentState) {
            if (currentState is LocationLoaded) {
              _mapController.onReady.then((_) => _mapController.move(
                  LatLng(currentState.latitude, currentState.logtitude), 14));
            }
            if (currentState is LocationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red.withOpacity(0.6),
                content: Text("Ошибка, не смогли найти иестоположение"),
              ));
            }
          },
          child: BlocBuilder<BirdPostCubit, BirdPostState>(
            buildWhen: (prevState, currentState) =>
                (prevState.status != currentState.status),
            builder: (context, birdPostState) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  onLongPress: (tapPosition, latLng) => _pickSurotAndCreatePost(
                    latLng: latLng,
                    context: context,
                  ),
                  center: LatLng(0, 0),
                  zoom: 15.3,
                  maxZoom: 17,
                  minZoom: 3,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    retinaMode: true,
                  ),
                  MarkerLayerOptions(
                      markers: _buildMarkers(context, birdPostState.birdPosts)),
                ],
              );
            },
          )),
    );
  }
}
