import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/widgets/container_widget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text(
          "이용 내역",
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_sessions')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "이용 내역이 없습니다.",
                style: TextStyle(fontSize: 16, color: grey70),
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final sessionHistory = userData['session_history'] as List<dynamic>? ?? [];

          if (sessionHistory.isEmpty) {
            return const Center(
              child: Text(
                "이용 내역이 없습니다.",
                style: TextStyle(fontSize: 16, color: grey70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessionHistory.length,
            itemBuilder: (context, index) {
              final session = sessionHistory[sessionHistory.length - 1 - index] as Map<String, dynamic>;
              final selectedSpace = session['selected_space'] ?? '알 수 없음';
              final startTime = (session['start_time'] as Timestamp).toDate();
              final endTime = session['end_time'] != null
                  ? (session['end_time'] as Timestamp).toDate()
                  : null;
              final formattedStart = DateFormat('yyyy-MM-dd HH:mm').format(startTime);
              final formattedEnd = endTime != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(endTime)
                  : '진행 중';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$selectedSpace",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "이용 시작: $formattedStart",
                        style: const TextStyle(
                          fontSize: 14,
                          color: black,
                        ),
                      ),
                      Text(
                        "이용 종료: $formattedEnd",
                        style: const TextStyle(
                          fontSize: 14,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}