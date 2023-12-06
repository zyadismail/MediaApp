import 'package:flutter/material.dart';
import 'package:media_app/screens/results_screen/results_screen.dart';
import 'package:media_app/shared/widgets/button/button.dart';
import 'package:media_app/shared/widgets/choice_card/choice_card.dart';
import 'package:media_app/shared/widgets/text_field/text_field.dart';

import '../../shared/cubit/app_cubit/app_cubit.dart';
import '../favourite_screen/favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool imagesActive = true;
  final TextEditingController _controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_)=>const FavouriteScreen(),
                    ),
                );
              },
              icon: const Icon(
                Icons.save_alt,
                color: Colors.black,
                size: 32,
              ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/pexels-logo.png',
                    height: MediaQuery.of(context).size.height / 10,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imagesActive = true;
                            });
                          },
                          child: ChoiceCard(
                            text: 'Images',
                            icon: Icons.camera_enhance_outlined,
                            isActive: imagesActive,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              imagesActive = false;
                            });
                          },
                          child: ChoiceCard(
                            text: 'Video',
                            icon: Icons.play_arrow_outlined,
                            isActive: !imagesActive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: MyFormField(
                  controller: _controller,
                  text: 'Search',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Search query cannot be empty';
                    }
                    return null;
                  },
                  prefixIcon: Icons.search_outlined,
                ),
              ),
              MyButton(
                text: 'Search',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if(imagesActive) {
                      AppCubit.get(context).getImages(text: _controller.text);
                    }else{
                      AppCubit.get(context).getVideos(text: _controller.text);

                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultsScreen(
                          query: _controller.text,
                          isFromImages: imagesActive,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
