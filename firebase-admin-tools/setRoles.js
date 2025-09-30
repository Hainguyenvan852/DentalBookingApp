const admin = require("firebase-admin");

// Tải service account JSON đã tải về từ Firebase Console
// (Project Settings > Service accounts > Generate new private key)
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function setRole(uid, role) {
  await admin.auth().setCustomUserClaims(uid, { role });
  console.log(`✅ Set role=${role} cho user ${uid}`);
}

setRole("t79V3zSOeTVItfUeNL6klTw9IPW2", "admin"); // hoặc "patient"
