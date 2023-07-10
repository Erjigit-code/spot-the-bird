import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screen/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (BuildContext context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(
            create: (BuildContext context) => BirdPostCubit()..loadPosts()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //Appbar Color
          primaryColor: const Color(0xff646FD4),
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xff14C38E),
            secondary: const Color(0xff9A86A4),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
