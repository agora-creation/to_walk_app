import * as admin from 'firebase-admin'
import * as functions from "firebase-functions";

admin.initializeApp()

exports.levelUpFunction = functions
    .region('asia-northeast1')
    .pubsub.schedule('0 0 * * *')
    .onRun(async (context) => {
        const userSnapshot = await admin.firestore().collection('user').get()
        userSnapshot.docs.forEach(async (userDoc) => {
            var userId = userDoc.data()['id']
            //alk get
            //steps get
            //levelUp
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
