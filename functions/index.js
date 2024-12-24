/* eslint-disable max-len */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.autoEndSessions = functions.pubsub.schedule("every 1 hour").onRun(async (context) => {
  const db = admin.firestore();
  const now = admin.firestore.Timestamp.now();
  const cutoffTime = admin.firestore.Timestamp.fromMillis(now.toMillis() - 24 * 60 * 60 * 1000); // 24시간 전

  console.log(`Current time: ${now.toDate()}, Cutoff time: ${cutoffTime.toDate()}`);

  try {
    const userSessions = await db.collection("user_sessions")
      .where("active_session.start_time", "<=", cutoffTime)
      .where("active_session.end_time", "==", null)
      .get();

    console.log(`Found ${userSessions.size} sessions to process.`);

    if (userSessions.empty) {
      console.log("No sessions to end.");
      return;
    }

    const batch = db.batch();

    userSessions.forEach(doc => {
      const data = doc.data();
      const activeSession = data.active_session;

      if (activeSession) {
        console.log(`Processing session for user: ${doc.id}`);
        const loungeId = activeSession.lounge_id;
        const endTime = now;

        // Update user session
        batch.update(doc.ref, {
          "active_session.end_time": endTime,
          "session_history": admin.firestore.FieldValue.arrayUnion({
            ...activeSession,
            end_time: endTime,
          }),
        });

        // Update lounge data
        if (loungeId) {
          const loungeRef = db.collection("lounges").doc(loungeId);
          batch.update(loungeRef, {
            current_users: admin.firestore.FieldValue.increment(-1),
          });
        }
      }
    });

    await batch.commit();
    console.log("Sessions ended and lounges updated.");
  } catch (error) {
    console.error("Error processing sessions:", error);
  }
});