# 🎯 Bandox - Kanban-Based Task Management Application

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)  
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

---

## 🚀 About Bandox

Bandox is a modular Flutter application designed to streamline task and team management using the Kanban methodology. Beyond its core task management capabilities, Bandox integrates secure, internal messaging tailored for organizations. It combines simplicity and ease of use with robust security features — including SMS-based verification and private company-wide communication channels.

This approach ensures that all internal conversations remain confidential and securely stored within the company’s own infrastructure or database, avoiding reliance on external messaging platforms like email or WhatsApp. By centralizing communication and task tracking in one intuitive interface, Bandox empowers companies to maintain control over their data privacy and operational efficiency, fostering a safer and more transparent workplace environment.



- **Admin Panel:** View and manage the list of companies.  
- **Manager Panel:** Manage company-specific operations and workflows.  
- **User Panel:** Employee interface for task and collaboration management.

---

## 📁 Project Structure

```plaintext
bandox/
├── admin_panel/      # Company list and admin management
├── manager_panel/    # Company-specific management and control
└── user_panel/       # Employee task management and collaboration
```
## 📱 Features

### Admin Panel

- Offers a comprehensive overview of all registered companies within the system  
- Allows administrators to view, add, or modify company details  
- Manages high-level organizational settings with ease  

### Manager Panel

- Enables managers to oversee projects and workflows  
- Allows assigning and prioritizing tasks  
- Monitors workflow progress  
- Facilitates efficient team collaboration  

### User Panel

- Provides an interface for managing individual tasks  
- Supports task status updates and subtasks management  
- Enables real-time notifications and collaboration  
- Includes secure internal messaging for private, company-wide communication  
- Ensures all conversations are stored securely within the company’s infrastructure  

## 📦 Dependencies

- Flutter SDK (>=3.0.0)  
- Firebase Core & Firestore  
- flutter_bloc (for state management)  
- dio (for HTTP requests)  
- equatable (for value equality in bloc)  
- Other relevant packages as per `pubspec.yaml`

---

## 🔒 Security & Privacy

- Firebase configuration files are excluded from version control via `.gitignore`.  
- API keys and sensitive credentials should be managed securely and not hardcoded.  
- User data is stored securely and access is controlled via Firebase rules.

---

## 🤖 Cloud Run Face Recognition Service

In addition to the Bandox Flutter app, this project includes a Python-based face recognition backend service deployed on Google Cloud Run. This service provides secure and scalable facial authentication and recognition functionalities that can be integrated with Bandox or used independently.

### Features

- Real-time face recognition API  
- Authentication support  
- Containerized with Docker for easy deployment  
- Scalable on-demand via Google Cloud Run  

### Setup & Deployment

Navigate to the face recognition backend folder (e.g., `face_recognition_service/`).  

## 🛠️ Development Setup

1. Clone the repository:  
   ```bash
   git clone https://github.com/enesorhann/bandbox.git](https://github.com/enesorhann/bandox.git


## 🙏 Thanks / Credits
Thanks to the Flutter and Firebase communities for amazing tools and documentation.

Inspired by Kanban methodologies and project management best practices.

---
