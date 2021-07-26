# LangChat


<div>
<p align="center"><img src="./assets/chatlogoreadme.png" height="150px"></p>
</div>

LangChat is very similar to regular chat application, wherein users communicate with each other using messages over the internet. What langChat brings in new is the idea of removing language barriers in such a communication system. We intend to target users who have communication barriers due to language restrictions. Using this application for same language communication is of no use, Much better apps already exist like Whatsapp, Telegram, Signal and etc. LangChat automatically translates messages (text and audio) made by the other user in some language to the language set by user himself. Since variety of languages and nuances exist in the world, language barrier in communication does exist, LangChat is developed to remove this barrier.

Languages Supported are:
1. English
2. Spanish
3. Gujarati
4. German
5. Hindi
6. French

Application can obviously be extended to more languages 😏, but for now these are supported.

Working :- You will send and receive text and audio messages in language of your own choice. On long press on message bubble you can also see message of sender in his/her language. You can also listen audio message in original lanuguage. While app is in background or is terminated only then you will receive Notification i.e. application only handles background notifications, not foreground notifications.

For Background Notification Cloud Function Deployed to Firebase is:
```
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendNotification = functions.firestore
    .document("ChatRooms/{chatRoomId}/chats/{messageId}")
    .onCreate((snapshot, context) => {
      const document = snapshot.data();
      const senderId = document.senderUid;
      let receiverId = "";
      const chatRoomId = context.params.chatRoomId;
      const ids = chatRoomId.split("_");
      if (ids[0] == senderId) {
        receiverId = ids[1];
      } else {
        receiverId = ids[0];
      }
      admin
          .firestore()
          .collection("users")
          .doc(receiverId)
          .get()
          .then((receiver) => {
            if (receiver.data().pushToken) {
              admin
                  .firestore()
                  .collection("users")
                  .doc(senderId)
                  .get()
                  .then((sender) => {
                    let payload = {};
                    if (document.msgType != "audio") {
                      payload = {
                        notification: {
                          click_action: "FLUTTER_NOTIFICATION_CLICK",
                          title: `Message by ${sender.data().name}`,
                          body: document.transMessage,
                          badge: "1",
                          sound: "default",
                        },
                      };
                    } else {
                      payload = {
                        notification: {
                          click_action: "FLUTTER_NOTIFICATION_CLICK",
                          title: `Message by ${sender.data().name}`,
                          body: "🔊 Audio Message",
                          badge: "1",
                          sound: "default",
                        },
                      };
                    }
                    admin
                        .messaging()
                        .sendToDevice(
                            receiver.data().pushToken, payload)
                        .then((response) => {
                          console.log("Message Sent: ", response);
                        }).catch((error) => {
                          console.log("Error Sent: ", error);
                        });
                  });
            } else {
              console.log("Can not find pushToken for target user");
            }
          });
      return null;
    });
```

### Internationalization
Currently implemented for English and Hindi. The app takes up the language set in your phone :iphone:.

<img src="https://github.com/devansh2805/LangChat/blob/main/demo/demo.gif?raw=true" width="300" />

### Tech Stack :wrench:

[![](https://img.shields.io/badge/Made_Using-Flutter-blue?style=curve-square&logo=flutter)](https://flutter.dev/docs)

[![](https://img.shields.io/badge/Database-Firebase-yellow?style=curve-square&logo=firebase)](https://flutter.dev/docs)

[![](https://img.shields.io/badge/Editor-Visual_Studio_Code-0073bf?style=curve-square&logo=visualstudiocode)](https://flutter.dev/docs)
