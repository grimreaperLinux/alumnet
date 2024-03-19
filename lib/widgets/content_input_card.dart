import 'package:alumnet/widgets/test_form_field.dart';
import 'package:flutter/material.dart';

class TextInputCard extends StatefulWidget {
  final Function getContent;

  const TextInputCard({required this.getContent, super.key});
  @override
  State<TextInputCard> createState() => _TextInputCardState();
}

class _TextInputCardState extends State<TextInputCard> {
  bool textFieldStatus = false;
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: textFieldStatus,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _contentController,
                decoration: const TextFieldCustom(
                  hinttext: 'Enter the content for your post',
                  labeltext: 'Content',
                ).textfieldDecoration(),
              ),
            ),
            Material(
              elevation: 5,
              color: const Color(0xff345C67),
              borderRadius: BorderRadius.circular(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () {
                  setState(() {
                    textFieldStatus = !textFieldStatus;
                  });
                  widget.getContent(_contentController.text);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      textFieldStatus ? 'Edit' : 'Save',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
