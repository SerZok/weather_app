import 'package:json_annotation/json_annotation.dart';
part 'article.g.dart';

// Поля класса должны быть аналогичны полям присылаемого с сервера ответа. Как
// минимум те, которые нужны в приложении.

@JsonSerializable()
class Article {
  Article({
    required this.uuid,

  });
  final String uuid;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
