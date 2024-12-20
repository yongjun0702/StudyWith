/* eslint-disable max-len */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.autoEndSessions = functions.pubsub.schedule("every 1 hour").onRun(async (context) => {
  const db = admin.firestore();
  const now = admin.firestore.Timestamp.now();
  const cutoffTime = now.toMillis() - 24 * 60 * 60 * 1000; // 24시간 전 타임스탬프

  // 24시간 초과하고 아직 종료되지 않은 세션만 가져옴
  const userSessions = await db.collection("user_sessions")
    .where("active_session.start_time", "<=", cutoffTime)
    .where("active_session.end_time", "==", null)
    .get();

  if (userSessions.empty) {
    console.log("No sessions to end.");
    return;
  }

  const batch = db.batch(); // 배치 작업 시작

  userSessions.forEach(doc => {
    const data = doc.data();
    const activeSession = data.active_session;

    if (activeSession) {
      const startTime = activeSession.start_time.toMillis();

      if (startTime <= cutoffTime) {
        const endTime = now;

        // active_session 종료 처리
        batch.update(doc.ref, {
          "active_session.end_time": endTime,
          "session_history": admin.firestore.FieldValue.arrayUnion({
            ...activeSession,
            end_time: endTime,
          }),
        });

        // lounge 데이터 갱신
        const loungeId = activeSession.lounge_id;
        if (loungeId) {
          const loungeRef = db.collection("lounges").doc(loungeId);
          batch.update(loungeRef, {
            current_users: admin.firestore.FieldValue.increment(-1),
          });
        }
      }
    }
  });

  // 배치 작업 커밋
  await batch.commit();
  console.log("Sessions ended and lounges updated.");
});