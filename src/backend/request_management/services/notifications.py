import firebase_admin
from firebase_admin import credentials, messaging
from fastapi import HTTPException
from time import sleep
import json
import os
import aiohttp

cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(cred)

gateway_url = os.getenv("GATEWAY_URL", "http://localhost:8000")

with open('./services/token.json', 'r') as file:
    token = json.load(file)['token']

async def _fetch_user_role_data(user_role: str, session: aiohttp.ClientSession):
    url = f"{gateway_url}/auth/users/roles/{user_role}"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        async with session.get(url, headers=headers) as response:
            if response.status == 200:
                return await response.json()  # Assuming JSON response
            else:
                error_message = await response.text()
                raise HTTPException(status_code=response.status, detail=error_message)
    except aiohttp.ClientError as e:
        raise HTTPException(status_code=503, detail=f"Unable to reach the auth service: {str(e)}")

async def publish_notification_by_role(title, body, payload, role):
        async with aiohttp.ClientSession() as http_session:
            # Inicialize o SDK do Firebase com suas credenciais
                print("Enviando notificação...")
                user_data = await _fetch_user_role_data(role, http_session)
                sleep(6)
                for token in user_data:
                    try:
                        mobile_token_user = token if token else None
                        print(mobile_token_user)
                        message = messaging.Message(
                            notification=messaging.Notification(
                                title=str(title),
                                body=str(body),
                            ),
                            data={
                                'data': str(payload)
                            },
                            token= mobile_token_user,
                        )
                        # Envie a mensagem
                        messaging.send(message)
                    except Exception as e:
                        print("Exception", e)
                        raise HTTPException(status_code=500, detail=f"Failed to publish notification: {str(e)}")
                print("Notificação enviada.")
 

async def publish_notification_to_user(title, body, mobile_token):
    # Inicialize o SDK do Firebase com suas credenciais
        print("Enviando notificação")
        sleep(5)
        print(mobile_token)
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
