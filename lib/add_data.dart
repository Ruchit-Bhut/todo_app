import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/show_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddData extends StatefulWidget {
  String? id;
  String? names;
  String? studys;

  AddData({super.key, this.id, this.names, this.studys});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _study = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.text = widget.names ?? "";
    _study.text = widget.studys ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? AppLocalizations.of(context)!.updateData : AppLocalizations.of(context)!.addData),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child:
              textField(controller: _name, fieldname: AppLocalizations.of(context)!.enterYourName),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child:
              textField(controller: _study, fieldname: AppLocalizations.of(context)!.enterYourStudy),
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {

                  if(_formKey.currentState!.validate()){
                    if (widget.id == null) {
                      await FirebaseFirestore.instance
                          .collection('student')
                          .add({"name": _name.text, "study": _study.text});
                    } else {
                      await FirebaseFirestore.instance
                          .collection('student')
                          .doc(widget.id)
                          .update({"name": _name.text, "study": _study.text});
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowData(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: Text(
                  widget.id != null ? AppLocalizations.of(context)!.updateData : AppLocalizations.of(context)!.insertData,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textField extends StatelessWidget {
  textField({super.key, this.fieldname,this.controller});

  String? fieldname;var controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)?.pleaseRequiredFill;
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: fieldname,
      ),
      controller: controller,
    );
  }
}
