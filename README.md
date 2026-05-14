UniNotify — University Notification App

A smart, organized, and reliable communication platform for universities built with Flutter.


📌 About the Project
UniNotify is a cross-platform mobile application developed to replace informal communication channels (such as WhatsApp and Telegram groups) with a unified, official notification system for universities.
The app enables university administrators and faculty members to send categorized and prioritized academic notifications, while students receive accurate and timely information through a dedicated interface.
Developed by:
NameStudent IDManar Talal AL-Subbari202210101070Maram Sharaf Fadel202210101395Dhoha Ziyad AL-Rowaishan202210100508
Supervised by: As.Prof.Dr. Sadiq Al-Taweel
University: University of Science and Technology — College of Computing, Department of Information Technology
Academic Year: 2025/2026

🎯 Objectives

Provide a unified platform for delivering instant academic and administrative notifications.
Allow faculty members and administrators to send direct, targeted notifications to students.
Automatically classify notifications by priority (urgent, important, normal).
Enable students and faculty to submit feedback and complaints through the app.
Generate periodic reports (weekly, monthly, yearly) to track communication effectiveness.


✨ Features
For Students

Receive instant notifications categorized by type (lectures, exams, administrative announcements).
Personalized notifications based on major, registered courses, and academic level.
Archive previous notifications with a search feature.
Submit feedback and complaints to administration.

For Faculty Members

Send instant notifications for canceled lectures or important updates.
Upload and share lecture slides and educational materials.
Receive notifications from university administration.
Submit feedback to administration.

For University Administration

Send important administrative notifications to all students and faculty.
Generate reports on notifications and lectures.
Monitor delivery and manage communication activities.
Receive and manage feedback from students and faculty.


🛠️ Tech Stack
TechnologyUsageFlutterCross-platform mobile development (Android & iOS)PHPBackend — handles system logic, APIs, and database interactionsSQLDatabase — stores users, notifications, files, and reportsREST APIsCommunication between mobile frontend and backendJWT TokensAuthentication and authorizationSSL/TLSSecure data transmissionFirebase / Push NotificationsReal-time notification delivery

🏗️ System Architecture
Mobile App (Flutter)
       ↕ Internet
   Server (PHP API)
       ↕
    SQL Database
The user interacts with the mobile app, which sends requests via the internet to the PHP server. The server processes requests, retrieves or updates data in the database, and sends responses back to the app.

👥 User Roles
RolePermissionsAdministratorSend notifications, manage users, generate reports, receive feedbackFaculty MemberSend lecture notifications, upload files, receive notifications, send feedbackStudentReceive notifications, download files, send feedback

🚀 Getting Started
Prerequisites

Flutter SDK (latest stable version)
Android Studio or VS Code
A running PHP backend with SQL database
An Android or iOS device / emulator

Installation
bash# Clone the repository
git clone https://github.com/m4aram/Ween_App-.git

# Navigate to the project directory
cd Ween_App-

# Install dependencies
flutter pub get

# Run the app
flutter run

📁 Project Structure
lib/
├── android/       # Android-specific configurations
├── ios/           # iOS-specific configurations
├── lib/           # Main Flutter source code
├── assets/        # Images, fonts, and static files
├── test/          # Unit and widget tests
└── pubspec.yaml   # Project dependencies

📊 Development Methodology
This project was built using the Agile methodology, working in short development cycles (Sprints). Each Sprint involved designing, developing, and testing a specific part of the system, allowing continuous improvements based on real user feedback.

📄 License
This project was developed as a graduation requirement for the Bachelor of Information Technology at the Faculty of Computing and Information Technology, University of Science and Technology.

UniNotify — Enhancing university communication, one notification at a time.
