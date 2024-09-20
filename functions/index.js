const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnNewMessage = functions
    .region("us-central1")
    .database.ref("/mensagens/{mensagemId}")
    .onCreate((snapshot, context) => {
      const messageData = snapshot.val();
      const payload = {
        notification: {
          title: "Nova mensagem",
          body: messageData.text,
        },
      };

      return admin.messaging().sendToDevice(messageData.receiverToken, payload)
          .then((response) => {
            console.log("Notificação enviada com sucesso:", response);
            return null;
          })
          .catch((error) => {
            console.error("Erro ao enviar notificação:", error);
          });
    });

