# **Docker Demo – Cloud Computing Class**
Let's learn **Docker** by running, building, and orchestrating containers with **Docker Compose**.

---

## **🔧 Installation**
Before starting, install **Docker** on your system:

📌 **Install Docker**
- [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Linux](https://docs.docker.com/engine/install/)

---

## **🟢 Demo 1 – Running Containers**
### **🔍 Exploring Images and Layers**
Pull an image and inspect its layers:

```sh
docker pull ubuntu
```
You should see output like:

```
latest: Pulling from library/ubuntu
da7391352a9b: Pull complete 
14428a6d4bcd: Pull complete 
...
```

Docker assumes we want the `:latest` image. Now, specify a **tag** explicitly:

```sh
docker pull ubuntu:24.04
```
Since `ubuntu:24.04` and `ubuntu:latest` often point to the same image, this command should complete instantly.

Now, pull an **older version**:
```sh
docker pull ubuntu:22.04
```
This time, **Docker will download new layers** since we didn’t have `22.04` before.

Run `docker images` to view the new images on disk

### **🖥️ Running an Ubuntu Container**
Let's start a container and interact with it:

```sh
docker run -it --rm ubuntu /bin/bash
```
✅ Try **`ls`**, **`cd`**, and **`cat /etc/os-release`** to explore the container.

In another terminal, check running containers:

```sh
docker ps -a
```
The `--rm` flag ensures cleanup, but if you see leftovers, remove them with:

```sh
docker rm <container_id>
```

---

### **🟢 Demo 2 – Running Our Go + Nginx App**
We will **run and expose a simple Go web application** inside Docker, **proxied by Nginx**.

#### **1️⃣ Clone the Repo**
```sh
git clone git@github.com:dansc0de/cc-docker-demo.git
cd cc-demo-docker
```

#### **2️⃣ Build and Start Containers**
```sh
docker-compose up --build
```

✅ This command:
- Builds a **Go backend** (`server`) listening on **port 8080**.
- Runs an **Nginx proxy** (`nginx`) forwarding requests to the Go backend.
- Uses **a shared network** (`app_network`) for communication.

#### **3️⃣ Check Running Containers**
```sh
docker ps
```
You should see **two running containers:**
- `server` (Go backend)
- `nginx` (Reverse proxy)

---

### **🟢 Demo 3 – Accessing the Application**
1️⃣ Open a browser or use `curl` to check the app:

```sh
curl -v http://localhost/api
```
**Expected Response:**
```
This is an in class demo, nothing to see here
```

2️⃣ Test another endpoint:

```sh
curl -v http://localhost/api/teapot
```
**Expected Response:**
```
I'm a teapot
```
(Yes, this is an **Easter egg** from the [HTTP 418 I'm a Teapot](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418) joke!)

---

### **📌 Understanding What’s Happening**
| **Component**  | **Role**  |
|---------------|----------|
| **Go App (`server`)**  | Handles requests at `/` and `/teapot` (listening on port 8080) |
| **Nginx (`nginx`)**  | Proxies `/api` requests to `server:8080` |
| **Docker Compose**  | Orchestrates both services & networks them together |

---

## **🛠️ Extra Exercises**
### **🔹 1. Port Binding in Docker**
By default, the container **isolates ports**. Let’s manually expose the Go app.

```sh
docker run -p 8081:8080 server
```
Now, access the Go app at:
```
http://localhost:8081
```

### **🔹 2. Persistent Data with Volumes**
Try running a container **with a volume**:
```sh
docker run -v $(pwd)/app_data:/data ubuntu /bin/bash
```
✅ Any changes in `/data` inside the container **persist** on your host!

### **🔹 3. Reverse Proxy Challenge**
Modify **`nginx.conf`** so that:
- `localhost:8081` serves **the Go app**.
- `127.0.0.1:8081` forwards to **another container** (e.g., `nginx` default page).

---

## **🛠️ Debugging Tips**
### **Check Container Logs**
```sh
docker logs server
docker logs nginx
```

### **Enter a Running Container**
```sh
docker exec -it server /bin/bash
```

### **Stop Everything**
```sh
docker-compose down
```

---

## **✅ Summary**
- 🐳 **Learned how to run & explore Docker containers**.
- 🛠️ **Built a real-world Docker Compose app** with Go + Nginx.
- 🔄 **Enabled hot reloading for Go development**.
- 🚀 **Practiced Docker networking, volumes & reverse proxying**.

🎉 **Congrats! You're ready to containerize your projects!** 🚀