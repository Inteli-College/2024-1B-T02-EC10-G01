import firebase_admin
from firebase_admin import credentials, messaging
from time import sleep

async def publish_notification(title, body, mobile_token):
    # Inicialize o SDK do Firebase com suas credenciais
        print("Enviando notificação")
        sleep(6)
        print(mobile_token)
        cred = credentials.Certificate("./serviceAccountKey.json")
        firebase_admin.initialize_app(cred)
        message = messaging.Message(
            notification=messaging.Notification(
                title=str(title),
                body=str(body),
            ),
            data={
                'data': str(body)
            },
            token= mobile_token,
        )
        # Envie a mensagem
        messaging.send(message)
        print("Notificação enviada")
