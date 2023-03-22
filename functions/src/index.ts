import * as admin from 'firebase-admin'
import * as functions from "firebase-functions";

admin.initializeApp()

exports.levelUpFunction = functions
    .region('asia-northeast1')
    .pubsub.schedule('0 0 * * *')
    .timeZone('Asia/Tokyo')
    .onRun(async (context) => {
        const userSnapshot = await admin.firestore().collection('user').get()
        userSnapshot.docs.forEach(async (userDoc) => {
            var userId = userDoc.data()['id']
            var exp = 0;
            var level = 0;
            var speed = 0;
            var jump = 0;
            const alkSnapshot = await admin.firestore().collection('user').doc(userId).collection('alk').get()
            alkSnapshot.docs.forEach(async (alkDoc) => {
                exp = alkDoc.data()['exp']
                level = alkDoc.data()['level']
                speed = alkDoc.data()['speed']
                jump = alkDoc.data()['jump']
                alkDoc.ref.update({
                    'exp': exp + 1,
                    'level': level + 1,
                    'speed': speed + 1,
                    'jump': jump + 1,
                });
            })
            //const stepsSnapshot = await admin.firestore().collection('steps').
        })
        return null
    })

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
