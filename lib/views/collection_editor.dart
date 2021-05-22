import 'package:flutter/material.dart';
import 'package:flutter_spinner/utils/collection.model.dart';
import 'package:flutter_spinner/utils/questions.dart';
import 'package:flutter_spinner/widgets/question_box.dart';

import 'collections_page.dart';

class CollectionEditor extends StatefulWidget {
  @override
  _CollectionEditorState createState() => _CollectionEditorState();
}

class _CollectionEditorState extends State<CollectionEditor> {
  List<Question> questions = [];
  Collection collection;

  void onAddQuestion() {
    var existingEmptyQuestion = this
        .questions
        .firstWhere((element) => element.text.isEmpty, orElse: () => null);

    if (existingEmptyQuestion != null) {
      existingEmptyQuestion.focusNode.requestFocus();
      return;
    }

    setState(() {
      Question newQuestion =
          new Question(isTabu: false, probability: 0.5, text: "");
      questions.add(newQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black54),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      'Nazwa kolekcji pytań długa',
                      style: TextStyle(fontSize: 26.0),
                      overflow: TextOverflow.ellipsis,
                    )),
                    Container(
                      child: Row(
                        children: [
                          Text("18+"),
                          Switch(
                            value: true,
                            onChanged: (value) {
                              setState(() {
                                // gameOptions.isTabuEnabled = value;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: questions.length + 1,
                itemBuilder: (context, index) {
                  if (index == questions.length) {
                    return TextButton(
                        onPressed: onAddQuestion,
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 16, bottom: 32, left: 16),
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                Text("Dodaj pytanie"),
                              ],
                            )));
                  }

                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: QuestionBox(
                          question: questions[index],
                          autofocus: questions[index].text.isEmpty,
                          onChanged: (text) {
                            setState(() {
                              questions.elementAt(index).setText(text);
                            });
                          },
                          onDelete: () {
                            setState(() {
                              questions.removeAt(index);
                            });
                          }));
                },
              ))
            ],
          ),
        ),
        floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 42.0),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CollectionsPage()),
                    );
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "ZAPISZ",
                  )),
            )));
  }
}
