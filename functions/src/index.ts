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
        const prevDayS = new Date(prevDay.getFullYear(), prevDay.getMonth(), prevDay.getDate(), 0, 0, 0)
        const prevDayE = new Date(prevDay.getFullYear(), prevDay.getMonth(), prevDay.getDate(), 23, 59, 59)
        const prevDaySTimestamp = admin.firestore.Timestamp.fromDate(prevDayS)
        const prevDayETimestamp = admin.firestore.Timestamp.fromDate(prevDayE)
        const userSnapshot = await admin.firestore().collection('user').get()
        userSnapshot.docs.forEach(async (userDoc) => {
            var userId:string = userDoc.data()['id']
            var stepsAll:number = 0
            const stepsSnapshot = await admin.firestore().collection('steps').where('userId', '==', userId).orderBy('createdAt', 'asc').startAt(prevDaySTimestamp).endAt(prevDayETimestamp).get()
            stepsSnapshot.docs.forEach((stepsDoc) => {
                var stepsNum:number = stepsDoc.data()['stepsNum']
                console.log(stepsNum)
                stepsAll += stepsNum
            })
            const alkSnapshot = await admin.firestore().collection('user').doc(userId).collection('alk').get()
            alkSnapshot.docs.forEach((alkDoc) => {
                var exp:number = alkDoc.data()['exp']
                var stepsExp:number = Math.floor(stepsAll * 0.01)
                var newExp:number = exp + stepsExp
                alkDoc.ref.update({
                    'exp': newExp,
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
