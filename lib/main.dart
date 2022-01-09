import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/common/app_colors.dart';
import 'package:rick_and_morty_app/locator_service.dart' as di;
import 'package:rick_and_morty_app/presentation/bloc/search_bloc/search_block.dart';

import 'locator_service.dart';
import 'presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'presentation/pages/person_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PersonListCubit>(
              create: (context) => sl<PersonListCubit>()..loadPerson()),
          BlocProvider<PersonSearchBloc>(
              create: (context) => sl<PersonSearchBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
              backgroundColor: AppColors.mainBackground,
              scaffoldBackgroundColor: AppColors.mainBackground),
          home: const HomePage(),
        ));
  }
}
