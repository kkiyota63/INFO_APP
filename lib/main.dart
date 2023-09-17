import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  Future<String> fetchRSSFeed(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load RSS feed');
      }
    } catch (e) {
      throw Exception('Failed to load RSS feed');
    }
  }

  List<Article> parseRSS(String xmlString) {
    var xmlDocument = XmlDocument.parse(xmlString);
    var rssItems = xmlDocument.findAllElements("item");

    return rssItems.map((item) {
      var title = item.findElements("title").first.text;
      var link = item.findElements("link").first.text;
      var imageUrl =
          item.findElements("media:content").first.getAttribute('url') ?? "";
      var author = item.findElements("studio:authorName").first.text ?? "";

      return Article(title, link, imageUrl, author);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSS Feed Reader"),
      ),
      body: FutureBuilder<String>(
        future: fetchRSSFeed('https://kadaiinfo.com/rss/nO0soVtCP7jDPK41E79T'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            var articles = parseRSS(snapshot.data!);
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ設定
                  children: [
                    if (article.imageUrl.isNotEmpty)
                      Image.network(article.imageUrl),
                    Text(article.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24)), // フォントサイズを大きく
                    Text("Author: ${article.author}",
                        textAlign: TextAlign.left), // 左寄せ設定
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String link;
  final String imageUrl;
  final String author;

  Article(this.title, this.link, this.imageUrl, this.author);
}
