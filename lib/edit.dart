import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_mysql/config.dart';
import 'package:note_app_mysql/home.dart';
    
    class Edit extends StatefulWidget {
      Edit({required this.id});
    
      String id;
    
      @override
      State<Edit> createState() => _EditState();
    }
    
    class _EditState extends State<Edit> {
      final _formKey = GlobalKey<FormState>();
    
      //inisialize field
      var nama = TextEditingController();
      var posisi_lamaran = TextEditingController();
      var status = TextEditingController();
    
      @override
      void initState() {
        super.initState();
        //in first time, this method will be executed
        _getData();
      }
    
      //Http to get detail data
      Future _getData() async {
        try {
          final response = await http.get(Uri.parse(

              "http://$ip/pegawai/data_pegawai/detail.php?id='${widget.id}'"));
    
          // if response successful
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
    
            setState(() {
               nama = TextEditingController(text: data['nama']);
                posisi_lamaran = TextEditingController(text: data['posisi_lamaran']);
                status = TextEditingController(text: data['status']);
            });
          }
        } catch (e) {
          print(e);
        }
      }
    
      Future _onUpdate(context) async {
        try {
          return await http.post(
            Uri.parse("http://$ip/pegawai/data_pegawai/update_admin.php"),
            body: {
              "id": widget.id,
              "nama": "${nama.text}",
              "posisi_lamaran": "${posisi_lamaran.text}",
              "status": "${status.text}",
            },
          ).then((value) {
            //print message after insert to database
            //you can improve this message with alert dialog
            var data = jsonDecode(value.body);
            print(data["message"]);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    
          });
        } catch (e) {
          print(e);
        }
      }
    
      Future _onDelete(context) async {
        try {
          return await http.post(
            Uri.parse("http://$ip/pegawai/data_pegawai/delete.php"),
            body: {
              "id": widget.id,
            },
          ).then((value) {
            //print message after insert to database
            //you can improve this message with alert dialog
            var data = jsonDecode(value.body);
            print(data["message"]);
    
            // Remove all existing routes until the home.dart, then rebuild Home.
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          });
        } catch (e) {
          print(e);
        }
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Creat New Note"),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          //show dialog to confirm delete data
                          return AlertDialog(
                            content: Text('Are you sure you want to delete this?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Icon(Icons.cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child: Icon(Icons.check_circle),
                                onPressed: () => _onDelete(context),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete)),
              )
            ],
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                        hintText: "Nama",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama is Required!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: posisi_lamaran,
                    decoration: InputDecoration(
                        hintText: "jabatan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'jabatan is Required!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: status,
                    decoration: InputDecoration(
                        hintText: "status",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'status is Required!';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      //validate
                      if (_formKey.currentState!.validate()) {
                        //send data to database with this method
                        _onUpdate(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
