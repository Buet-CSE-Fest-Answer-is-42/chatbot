<img src="https://github.com/Buet-CSE-Fest-Answer-is-42/chatbot/assets/53055478/1715c5fa-bdee-44d2-b12f-eeab5fccc639" alt="star" style="height: 80px; width: 80px; "/> <h1> Pixies: Conversational Chatbot and PDF Sharing Platform</h1>

## Overview
This project aims to develop a conversational chatbot with the ability to process voice commands and text input and provide responses in both text and speech formats. The chatbot utilizes advanced LLM and AI techniques and can generate a customized story-telling book with AI-generated images based on user prompts. The project also includes a PDF-sharing platform that allows users to browse, search, view, and download PDF documents without relying on a Content Delivery Network (CDN).

## Features
1. Conversational Chatbot:
   - Accepts voice commands and text input from users.
   - Responds to both text and speech formats.
   - Supports prompt input from files, images, and cameras.
   - Generates a storytelling book with AI-generated images based on the provided prompt.

2. PDF Sharing Platform:
   - Allows users to browse, search, view, and download PDF documents.
   - Provides efficient searching using titles or keywords.
   - Does not rely on a Content Delivery Network (CDN) for PDF storage.
     
## System Design
The project features a modular architecture with three main service modules: 
1. Authentication
2. Pdf
3. Bot.
Each module runs on a separate server to ensure scalability and performance.

The Authentication module handles user sign-in and login processes, incorporating secure authentication mechanisms. Rate limiting is applied to protect against abuse and unauthorized access.

The Pdf module enables users to search, browse, and view books. It supports searching by title or keywords and provides options to view both personal and available books. Users can also upload PDF files for sharing. Rate limiting is implemented to manage user interactions effectively.

The Bot module integrates language models and AI APIs to power a conversational chatbot. It accepts voice commands or text inputs and responds in text or speech format. The module generates children's books with AI-generated images based on user prompts. Rate limiting ensures optimal API usage.

It runs on two database - User and PDF so that it can avoid single point failure and to manage loads efficiently.

Here is the system design below- 
![Pixies drawio](https://github.com/Buet-CSE-Fest-Answer-is-42/chatbot/assets/53055478/92aa0181-205a-40f8-b9ed-12ac0d6e269e)


The project focuses on modularity, security, with authentication measures and rate limiting and pagination in place to protect user data and ensure a safe user experience.

Overall, the project aims to provide a user-friendly platform for accessing, sharing, and generating content, including PDF files and AI-generated children's books. The modular design allows for future expansion and the addition of new functionalities.

## API Extensibility
The chatbot and PDF-sharing platform APIs are designed to be extensible for similar tasks or functionalities. Developers can leverage the existing architecture and add new features or extend existing functionalities to suit their requirements.

## Dependencies Used
- Speech Recognition APIs for voice input processing
- Text-to-Speech and Speech-to-Text Conversion APIs for voice output processing
- LLM and ML Libraries for language and image understanding and processing
- AI Image Generation Libraries or APIs for generating AI images
- PDF Processing Libraries for PDF document management and viewing

## Technologies and Frameworks Used
- [Node.js](https://nodejs.org/en) for backend
- [Flutter](https://flutter.dev/) for Android
- [MongoDB](https://www.mongodb.com/atlas/database) for database
- [OpenAI](https://openai.com/) for conversational chatbot
- [MLkit](https://developers.google.com/ml-kit) for OCR
- [Clickdrop](https://clipdrop.co/) for text-to-image generation
- [Cloudinary](https://cloudinary.com/) for Storing PDFs
- [jsPDF](https://github.com/parallax/jsPDF) for Generating PDF

## Installation and Configuration
1. Clone the GitHub repository.
2. Install the required dependencies and libraries for both the front-end and back-end.
   - For flutter, follow the [documentation](https://docs.flutter.dev/get-started/install). Then run ```flutter pub get``` to fetch dependencies and ```flutter run``` to run the project.
   - For nodejs, for every server, run ```npm install``` to install all packages and then ```npm run dev``` to start the servers.
4. Configure the APIs and necessary credentials.
5. Set up the database and storage for PDF document management.
6. Build and run the application.

## Conclusion
The Conversational Chatbot and PDF Sharing Platform project offers a comprehensive solution for interactive conversations, AI-generated storytelling book creation, and efficient PDF document management. The extensible APIs and modular architecture allow for easy integration and customization as per specific requirements. The project aims to enhance user experiences and provide a seamless platform for communication and document sharing.

For detailed implementation instructions and code samples, please refer to the project's GitHub repository.
