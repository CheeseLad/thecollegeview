// lib/article_submission_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticleSubmissionPage extends StatefulWidget {
  @override
  _ArticleSubmissionPageState createState() => _ArticleSubmissionPageState();
}

class _ArticleSubmissionPageState extends State<ArticleSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();

  // Replace with your Google Form's action URL
  final String _formUrl = 'https://docs.google.com/forms/d/e/1FAIpQLSf-7_TjFgoBVorwVl7NkPFWO_yJGVNGyMVKFFX47QciTaV1pg/formResponse';

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse(_formUrl),
        body: {
          'entry.1771027269': _titleController.text, // Replace with actual entry ID
          'entry.447857319': _authorController.text, // Replace with actual entry ID
          'entry.888149517': _categoryController.text, // Replace with actual entry ID
          'entry.1424180295': _contentController.text, // Replace with actual entry ID
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission Successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission Failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Your Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Title:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the title of the article',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Author Name:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the author\'s name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Category:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButtonFormField<String>(
                value: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select a category',
                ),
                items: <String>['News', 'Opinion', 'Feature', 'Editorial']
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoryController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Content:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the content of the article',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
