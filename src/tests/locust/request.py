from locust import HttpUser, TaskSet, task, between

class UserBehavior(TaskSet):
    def on_start(self):
        """on_start is called when a Locust start before any task is scheduled"""
        self.login()

    def login(self):
        payload = {
            "email": "renatocariani@gmail.com",
            "password": "durateston123"
        }
        headers = {'Content-Type': 'application/json'}
        response = self.client.post("/auth/login", json=payload, headers=headers)
        
        if response.status_code == 200:
            self.token = response.json().get("access_token")
        else:
            print(f"Login failed with status code {response.status_code}: {response.text}")
            self.token = None
    
    @task(1)
    def read_medicine_requests(self):
        if self.token:
            headers = {
                "Authorization": f"Bearer {self.token}",
                "Content-Type": "application/json"
            }
            response = self.client.get("/requests/medicine/", headers=headers)
            if response.status_code != 200:
                print(f"Failed to read medicine requests: {response.status_code} - {response.text}")

class WebsiteUser(HttpUser):
    tasks = [UserBehavior]
    wait_time = between(1, 2)  

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.host = "http://0.0.0.0:8000"  # Substitua pelo host
