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
        var prevDayS = new Date(prevDay.getFullYear(), prevDay.getMonth(), prevDay.getDate(), 0, 0, 0)
        var prevDayE = new Date(prevDay.getFullYear(), prevDay.getMonth(), prevDay.getDate(), 23, 59, 59)
        const userSnapshot = await admin.firestore().collection('user').get()
        userSnapshot.docs.forEach(async (userDoc) => {
            var userId:string = userDoc.data()['id']
            var stepsNum:number = 0
            const stepsSnapshot = await admin.firestore().collection('steps').where('userId', '==', userId).where('createdAt', '>=', prevDayS).where('createdAt', '<=', prevDayE).get()
            stepsSnapshot.docs.forEach(async (stepsDoc) => {
                stepsNum += stepsDoc.data()['stepsNum']
            })
            const alkSnapshot = await admin.firestore().collection('user').doc(userId).collection('alk').get()
            alkSnapshot.docs.forEach(async (alkDoc) => {
                var exp:number = alkDoc.data()['exp']
                var stepsExp:number = Math.floor(stepsNum * 0.01)
                alkDoc.ref.update({
                    'exp': exp + stepsExp,
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
