import 'package:flutter/material.dart';
import 'package:study_with/config/color/color.dart';

Future<void> CustomDialog({
  bool barrierDismissible = false,
  required BuildContext context,
  required String title,
  required String dialogContent,
  required String? buttonText,
  required int buttonCount,
  required VoidCallback func,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: background,
                surfaceTintColor: Colors.transparent,
                title: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainBlue
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Text(
                    dialogContent,
                    style: TextStyle(
                      fontSize: 15,
                      color: black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                actions: <Widget>[
                  /// <버튼이 2개일 때>
                  buttonCount == 2
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: blue20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mainBlue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          onPressed: func,
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Center(
                    child: Container(
                      width: 80,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onPressed: func,
                        child: Text(
                          buttonText!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(color: border)),
              );
            });
      });
}
