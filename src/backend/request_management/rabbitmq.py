# import pika
# import os

# # RabbitMQ connection parameters
# RABBITMQ_HOST = os.getenv('RABBITMQ_HOST', 'localhost')
# RABBITMQ_PORT = int(os.getenv('RABBITMQ_PORT', 5672))
# RABBITMQ_USER = os.getenv('RABBITMQ_USER', 'rabbitmq')
# RABBITMQ_PASS = os.getenv('RABBITMQ_PASS', 'rabbitmq')

# class RabbitMQ:
#     def __init__(self):
#         self.connection = None
#         self.channel = None

#     def connect(self):
#         credentials = pika.PlainCredentials(RABBITMQ_USER, RABBITMQ_PASS)
#         parameters = pika.ConnectionParameters(
#             RABBITMQ_HOST,
#             RABBITMQ_PORT,
#             '/',
#             credentials
#         )
#         self.connection = pika.BlockingConnection(parameters)
#         self.channel = self.connection.channel()

#     def get_channel(self):
#         if self.connection is None or self.connection.is_closed:
#             self.connect()
#         return self.channel

#     def close(self):
#         if self.connection and self.connection.is_open:
#             self.connection.close()

# rabbitmq = RabbitMQ()