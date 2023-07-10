import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_models.dart';
import 'package:spot_the_bird/services/sqflite.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;

  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionfocusnode;
  @override
  void initState() {
    _descriptionfocusnode = FocusNode();
    super.initState();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState!.save();
    final BirdModel birdModel = BirdModel(
      birdName: name,
      latitude: widget.latLng.latitude,
      longitude: widget.latLng.longitude,
      birdDescription: description,
      image: widget.image,
    );
    context.read<BirdPostCubit>().addBirdPost(birdModel);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionfocusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(widget.image), fit: BoxFit.cover),
                  ),
                ),

                ///
                /////
                ///
                ///
                ///1)
                TextFormField(
                  decoration: InputDecoration(hintText: "Enter a bird name"),
                  onSaved: (value) {
                    name = value!.trim();
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionfocusnode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the name";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer name";
                    }
                    return null;
                  },
                ),

                //2)
                TextFormField(
                  focusNode: _descriptionfocusnode,
                  decoration:
                      InputDecoration(hintText: "Enter a bird description"),
                  textInputAction: TextInputAction.done,
                  onSaved: (value) {
                    description = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    _submit(context);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the description";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer description";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _submit(context);
                    },
                    child: Text('Pop')),
              ],
            ),
          ),
        ),
      ),
      //

      //

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submit(context);
        },
        child: Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
