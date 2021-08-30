import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/all_tags_bloc/all_tags_bloc.dart';
import 'package:onoo/src/data/model/all_tags.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/post_by_tag_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class AllTagsScreen extends StatefulWidget {
  static final String route = '/AllTagsScreen';
  @override
  _AllTagsScreenState createState() => _AllTagsScreenState();
}

class _AllTagsScreenState extends State<AllTagsScreen> {
  bool isDark = false;
  late AllTagsBloc _allTagsBloc;

  @override
  void initState() {
    _allTagsBloc = BlocProvider.of<AllTagsBloc>(context)
      ..add(GetAllTagsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            helper.getTranslated(context, AppTags.allTags),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        backgroundColor: Utils.getBackgroundColor(isDark: isDark),
        body: BlocListener<AllTagsBloc, AllTagsState>(
          bloc: _allTagsBloc,
          listener: (context, state) {
            if (state is AllTagsErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
            } else if (state is AllTagsSuccessState) {}
          },
          child: BlocBuilder<AllTagsBloc, AllTagsState>(
            builder: (context, state) {
              if (state is AllTagsErrorState) {
                return Center(
                  child: LoadingIndicator(),
                );
              }

              return getViewsAsPerState(state, context);
            },
          ),
        ),
      ),
    );
  }

  getViewsAsPerState(AllTagsState state, BuildContext context) {
    if (state is AllTagsLoadingState) {
      return Center(
        child: LoadingIndicator(),
      );
    } else if (state is AllTagsSuccessState) {
      return _buildUI(state.allTags);
    }
  }

  Widget _buildUI(AllTags allTags) {
    Size size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppThemeData.wholeScreenPadding),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: AppThemeData.normalPadding),
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: (itemWidth / 100),
                controller: ScrollController(keepScrollOffset: false),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(
                    allTags.data != null ? allTags.data!.length : 0, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 40, height: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostByTagScreen(
                                        tag: allTags.data![index])));
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green;
                                //generate a random color
                                return Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(1.0);
                              },
                            ),
                          ),
                          child: Text(
                            allTags.data != null ? allTags.data![index] : "",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
