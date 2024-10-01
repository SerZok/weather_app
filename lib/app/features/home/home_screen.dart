import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Дом',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Header',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              20.ph,
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const ArticleCard();
                },
                separatorBuilder: (context, index) {
                  return 20.ph;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
