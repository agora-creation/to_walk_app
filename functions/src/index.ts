import * as admin from 'firebase-admin'
import * as functions from "firebase-functions";

admin.initializeApp()

exports.levelUpFunction = functions
    .region('asia-northeast1')
    .pubsub.schedule('0 0 * * *')
    .timeZone('Asia/Tokyo')
    .onRun(async (context) => {
        var today = new Date()
        var prevDay = new Date()
        prevDay.setDate(today.getDate() - 1)
        today = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0)
        prevDay = new Date(prevDay.getFullYear(), prevDay.getMonth(), prevDay.getDate(), 0, 0, 0)
        const userSnapshot = await admin.firestore().collection('user').get()
        userSnapshot.docs.forEach(async (userDoc) => {
            var userId:string = userDoc.data()['id']
            var stepsNum:number = 0
            const stepsSnapshot = await admin.firestore().collection('steps').where('userId', '==', userId).where('createdAt', '<', today).where('createdAt', '>=', prevDay).get()
            stepsSnapshot.docs.forEach(async (stepsDoc) => {
                stepsNum += stepsDoc.data()['stepsNum']
            })
            const alkSnapshot = await admin.firestore().collection('user').doc(userId).collection('alk').get()
            alkSnapshot.docs.forEach(async (alkDoc) => {
                var exp:number = alkDoc.data()['exp']
                alkDoc.ref.update({
                    'exp': exp + stepsNum,
                })
            })
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
