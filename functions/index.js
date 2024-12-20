/* eslint-disable max-len */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.autoEndSessions = functions.pubsub.schedule("every 1 hour").onRun(async (context) => {
  const db = admin.firestore();
  const now = admin.firestore.Timestamp.now();
  const cutoffTime = now.toMillis() - 24 * 60 * 60 * 1000; // 24시간 전 타임스탬프

  const userSessions = await db.collection("user_sessions").get();

  for (const doc of userSessions.docs) {
    const data = doc.data();
    const activeSession = data.active_session;

    if (activeSession && !activeSession.end_time) {
      const startTime = activeSession.start_time.toMillis();

      if (startTime <= cutoffTime) {
        // 24시간 초과 시 세션 종료
        const endTime = now;

        // active_session 종료 처리
        await db.collection("user_sessions").doc(doc.id).update({
          "active_session.end_time": endTime,
          "session_history": admin.firestore.FieldValue.arrayUnion({
            ...activeSession,
            end_time: endTime,
          }),
        });

        // lounge 데이터 갱신
        const loungeId = activeSession.lounge_id;
        if (loungeId) {
          await db.collection("lounges").doc(loungeId).update({
            current_users: admin.firestore.FieldValue.increment(-1),
          });
        }
      }
    }
  }
});
