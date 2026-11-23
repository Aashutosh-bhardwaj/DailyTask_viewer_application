# TaskViewer – Task Management Application

TaskViewer is a task management application developed using **Flutter, Dart, FastAPI, and MySQL**. It helps users create and manage their daily tasks in an organized way.

The application provides user authentication and allows users to save and retrieve their tasks from a MySQL database through a FastAPI backend.

## 🚀 Features

- **User Registration:** Create a new account using email and password.
- **User Login:** Securely log in to an existing account.
- **JWT Authentication:** Protect API endpoints using JSON Web Tokens.
- **Add Tasks:** Create tasks with title, description, due date, and priority.
- **Task Storage:** Store tasks permanently in a MySQL database.
- **View Tasks:** Retrieve and display saved tasks.
- **User-Specific Tasks:** Each user can access their own tasks.
- **Priority Management:** Set task priority to Low, Medium, or High.

## 🛠️ Technologies Used

### Frontend
- Flutter
- Dart
- Material UI
- HTTP Package

### Backend
- Python
- FastAPI
- Uvicorn
- JWT Authentication
- Password Hashing

### Database
- MySQL
- MySQL Workbench
- MySQL Connector

### Development Tools
- Android Studio
- Visual Studio Code
- Git
- GitHub

## 📂 Project Structure

```text
TaskViewer/
│
├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   │   └── task.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── add_task_screen.dart
│   │   │
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   │
│   │   └── main.dart
│   │
│   └── pubspec.yaml
│
├── backend/
│   ├── main.py
│   ├── database.py
│   ├── requirements.txt
│   └── .env.example
│
└── README.md
```

*Note: Folder and file names above are an example. Adjust them according to your actual project structure.*

## ⚙️ Installation and Setup

### 1. Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate to the project directory:

```bash
cd TaskViewer
```

### 2. Frontend Setup (Flutter)

Navigate to the Flutter project folder:

```bash
cd frontend
```

Install the required dependencies:

```bash
flutter pub get
```

Check your Flutter installation:

```bash
flutter doctor
```

Run the application:

```bash
flutter run
```

### 3. Backend Setup (FastAPI)

Open another terminal and navigate to the backend folder:

```bash
cd backend
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate the virtual environment.

**Windows:**

```bash
venv\Scripts\activate
```

Install the required Python packages:

```bash
pip install -r requirements.txt
```

### 4. MySQL Database Setup

Open MySQL Workbench and execute the following SQL commands:

```sql
CREATE DATABASE tash_viewer_db;

USE tash_viewer_db;
```

Create the users table:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Create the tasks table:

```sql
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);
```

### 5. Environment Configuration

Create a `.env` file inside the backend folder.

Add your MySQL configuration:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=tash_viewer_db
DB_PORT=3306

JWT_SECRET_KEY=your_secret_key
```

Replace `your_mysql_password` with your actual MySQL password.

**Important:** Never upload your actual `.env` file or database credentials to GitHub. Add `.env` to `.gitignore`.

### 6. Run FastAPI Backend

Start the backend server:

```bash
uvicorn main:app --reload
```

The backend will run at:

```text
http://127.0.0.1:8000
```

Open the Swagger API documentation:

```text
http://127.0.0.1:8000/docs
```

## 🔗 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | `/signup` | Register a new user |
| POST | `/login` | Login user |
| GET | `/test-db` | Test database connection |
| POST | `/tasks` | Create a new task |
| GET | `/tasks` | Retrieve user's tasks |

**Authentication:** Task endpoints require a valid JWT access token in the Authorization header.

```text
Authorization: Bearer YOUR_ACCESS_TOKEN
```

## 🔄 Application Workflow

1. User opens the TaskViewer application.
2. User registers or logs in.
3. Backend verifies the user's credentials.
4. User receives an authentication token.
5. User enters the home screen.
6. User creates a task by entering its details.
7. Flutter sends task information to the FastAPI backend.
8. FastAPI stores the task in the MySQL database.
9. Saved tasks are retrieved and displayed in the application.

## 🗄️ Database Design

The application uses two main tables:

**1. Users Table**

Stores registered user information.

- `id` – Unique user ID.
- `email` – User email address.
- `password_hash` – Hashed password.
- `created_at` – Account creation time.

**2. Tasks Table**

Stores task information.

- `id` – Unique task ID.
- `user_id` – Reference to the user.
- `title` – Task title.
- `description` – Task details.
- `due_date` – Task deadline.
- `priority` – Task priority.
- `is_completed` – Task completion status.
- `created_at` – Task creation time.

## 🔐 Security

- Passwords are stored as hashes instead of plain text.
- JWT authentication is used to protect task APIs.
- Each authenticated user can access their own tasks.
- Database credentials are maintained in environment variables.

## 🎯 Project Objective

The main objective of TaskViewer is to provide a simple and user-friendly platform for managing daily tasks. It demonstrates the integration of a Flutter mobile application with a Python FastAPI backend and a MySQL relational database.

## 👨‍💻 Developer

**Project Name:** TaskViewer  
**Frontend:** Flutter & Dart  
**Backend:** Python & FastAPI  
**Database:** MySQL

**GitHub:** Add your GitHub repository link here.

---

⭐ If you find this project useful, consider giving the repository a star!

**Thank you for visiting TaskViewer!**