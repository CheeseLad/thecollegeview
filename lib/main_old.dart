import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The College View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The College View'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                'assets/tcv/logo.png',
                fit: BoxFit.contain,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('News'),
onTap: () {
  setState(() {
    _selectedItem = 'News';
    Navigator.pop(context);
  });
},
            ),
            ListTile(
              title: Text('Sport'),
              onTap: () {
                setState(() {
                  _selectedItem = 'Sport';
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Features'),
              onTap: () {
                setState(() {
                  _selectedItem = 'Features';
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ArticlePreview(
            imageUrl: 'https://thecollegeview.ie/wp-content/uploads/2024/04/IMG_7165-326x245.jpg',
            title: 'MPS ELECTS A NEW COMMITTEE FOR THE 2024/2025 SEASON',
            date: '⏰ April 19, 2024',
            intro:
                'On Monday, the 15th of April 2024, DCU’s Media Production Society saw the election of a brand-new committee for the 2024/2025 academic year. After many speeches, questions, votes, and smiles, a new committee has finally...',
          ),
          SizedBox(height: 16.0),
          ArticlePreview(
            imageUrl: 'https://thecollegeview.ie/wp-content/uploads/2024/03/175EC963-4D02-49C5-A811-B3B73F7542F7-326x245.jpeg',
            title: 'DCU Students Call for a Ceasefire in Palestine',
            date: '⏰ March 25, 2024',
            intro:
                'At 12pm on Wednesday the 20th of March DCU staff and students vacated classrooms in their droves in order to take part in the walkout in solidarity with the Palestinian people.  The walk out, that...',
          ),
        ],
      ),
    );
  }
}

class ArticlePreview extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String intro;

  const ArticlePreview({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.intro,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  intro,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* class NewsArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Markdown Viewer'),
        ),
        body: Markdown(
          selectable: true,
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            <md.InlineSyntax>[
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
          data: """
          ![Image](https://thecollegeview.ie/wp-content/uploads/2024/04/IMG_7165.jpg)

On Monday, the 15th of April 2024, DCU's Media Production Society saw the election of a brand-new committee for the 2024/2025 academic year. After many speeches, questions, votes, and smiles, a new committee has finally been established. The elected are as follows:  

**CHAIRPERSON: SADHBH O'GRADY KEELY**   

Sadhbh O'Grady Keely is a second-year Communications and Gaeilge student. She was previously the Events Manager and has now been elected Chairperson for the 2024/2025 academic year.   

          """,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(fontSize: 24),
            h2: TextStyle(fontSize: 20),
            a: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

class NewsArticleScreen2 extends StatelessWidget {
  const NewsArticleScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Markdown Viewer'),
        ),
        body: FutureBuilder<List<File>>(
          future: _getMarkdownFiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final markdownFiles = snapshot.data;
              if (markdownFiles!.isEmpty) {
                return Text('No markdown files found.');
              }
              return ListView.builder(
                itemCount: markdownFiles.length,
                itemBuilder: (context, index) {
                  return _buildMarkdownWidget(markdownFiles[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<File>> _getMarkdownFiles() async {
    List<File> markdownFiles = [];
    final directory = Directory('assets/2024');
    if (await directory.exists()) {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.md')) {
          markdownFiles.add(entity);
        }
      }
    }
    return markdownFiles;
  }

  Widget _buildMarkdownWidget(File file) {
    return FutureBuilder<String>(
      future: file.readAsString(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error reading file: ${snapshot.error}');
        } else {
          final markdownContent = snapshot.data;
          if (markdownContent!.contains('news')) {
            return md.Markdown(
              data: markdownContent,
              selectable: true,
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                <md.InlineSyntax>[
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                ],
              ),
              styleSheet: md.MarkdownStyleSheet(
                h1: TextStyle(fontSize: 24),
                h2: TextStyle(fontSize: 20),
                a: TextStyle(color: Colors.blue),
              ),
            );
          } else {
            // Return an empty container if the file doesn't contain "news"
            return Container();
          }
        }
      },
    );
  }
} */