import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});
  @override
  State<ArticleScreen> createState() => _AboutScreenText();
}


class _AboutScreenText extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Второй',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Заголовок статьи',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Это первый абзац текста, который описывает основную суть статьи.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Это второй абзац, который дополняет информацию или вводит дополнительные данные.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Image.network(
                'https://example.com/image.jpg', // Ссылка на изображение
                height: 200,
              ),
              const SizedBox(height: 16),
              const Text(
                'Третий абзац текста, который может описывать изображение или предоставлять дополнительные детали.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
