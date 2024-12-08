import 'package:flutter/material.dart';

import '../../utils/view/app_palette.dart';
import '../../utils/view/widgets/buttons/icon_button.dart';
import '../../utils/view/widgets/cards/homepage_card.dart';
import '../../utils/view/widgets/cards/training_card.dart';
import '../../utils/view/widgets/texts/header_text.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key, required this.title});

  final String title;

  @override
  _TrainingPage createState() => _TrainingPage();
}

class _TrainingPage extends State<TrainingPage> {
  bool _isTextVisible = false; // To manage the visibility of the text in AppBar()

  // List names of games
  List<String> nameTrainingList = [
    "Brow Down",
    "Brown Up",
    "Mouth Open",
    "Mouth Smile",
    "Mouth Pucker",
    "Mouth Lower"
  ];

  List<String> nameTrainingDescriptionList = [
    "Improve your ability to lower your eyebrows",
    "Enhance your skill in raising your eyebrows",
    "Practice opening your mouth naturally",
    "Learn to form a natural smile",
    "Master puckering your lips for focused gestures",
    "Practice lowering your bottom lip"
  ];

  // To change the visibility of the text when you scroll
  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels >= 65 && !_isTextVisible) {
      setState(() {
        _isTextVisible = true;
      });
    } else if (notification.metrics.pixels < 65 && _isTextVisible) {
      setState(() {
        _isTextVisible = false;
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButtonWidget(
          icon: Icons.arrow_back,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Visibility(
          visible: _isTextVisible,
          child: const HeaderText(
            text: 'Training',
            size: HeaderText.H4,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll, // Listen to the scroll events
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HomePageCard at the top
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: HomePageCard(
                  title: 'Training',
                  image: AssetImage('assets/images/image.png'),
                  onTap: () => print('Home page card'),
                ),
              ),
              const SizedBox(height: 8.0),
              // Grid of TrainCards
              Container(
                decoration: const BoxDecoration(
                  color: PaletteColor.powderBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20.0), // Padding for the grid
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
                  shrinkWrap: true, // Let GridView size itself within the scrollable column
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 10.0, // Horizontal spacing
                    mainAxisSpacing: 10.0, // Vertical spacing
                  ),
                  itemCount: 6, // Number of TrainCards
                  itemBuilder: (context, index) {
                    return TrainingCard(
                      title: nameTrainingList[index],
                      description: nameTrainingDescriptionList[index],
                      onTap: () => print('TrainingCard $index tapped'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}