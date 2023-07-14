import 'dart:developer';
import 'dart:io';

import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../modals/book.dart';

class BookDetails extends StatelessWidget {
  final bool myBook;
  final Book book;
  List<int> bytes = [];
  BookDetails({super.key, required this.book, required this.myBook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: (myBook)
            ? SpeedDial(
                icon: Icons.menu,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.download),
                      label: 'Download',
                      onTap: () async {
                        // final dio = Dio();
                        // final dir = await getApplicationDocumentsDirectory();
                        // String fullpath = dir.path + '/' + book.file;
                        // download2(dio, book.file, fullpath);
                      }),
                  if (!book.isShared)
                    SpeedDialChild(
                        child: const Icon(Icons.share),
                        label: 'Share',
                        onTap: () {
                          context.read<UserProvider>().shareBook(id: book.id);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                  SpeedDialChild(
                    child: const Icon(Icons.delete),
                    label: 'Delete',
                    onTap: () async {
                      await context
                          .read<UserProvider>()
                          .deleteBook(id: book.id)
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              )
            : FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.download),
              ),
        body: SfPdfViewer.network(
          book.file,
          enableTextSelection: true,
          onDocumentLoaded: (details) async {
            bytes = await details.document.save();
          },
        ));
  }
}
