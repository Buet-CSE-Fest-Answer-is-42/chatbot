import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: 100,
        child: Center(
          child: Container(
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class Loading {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: LoadingWidget(),
      ),
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}
