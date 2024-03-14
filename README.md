# PodcastSummarizer

Welcome to the Podcast Summarizer project! This project was developed to provide concise summaries of lengthy podcasts, enabling users to quickly grasp the main points and decide whether to invest time in listening to the full episode. Leveraging extractive summarization techniques along with sentiment analysis, this solution delivers informative and engaging summaries.

## Overview and Goals
Podcasting has become a popular medium for consuming content across various topics. However, lengthy podcast episodes can be daunting for users to commit to. With this project, I aimed to develop a solution that would generate concise summaries of podcasts. By extracting key points and sentiments from the podcast audio, the goal was to provide users with informative summaries that help them decide which podcasts to listen to.

## Technologies Used
### AWS Technologies
1. Amplify: Utilized for creating and hosting the front-end interface, providing seamless user interaction and file upload capabilities.
2. S3: Utilized for storage of audio files, transcribed text, and summarized outputs.
3. EC2: Hosts the frontend Flask application and executes Terraform scripts.
4. Lambda: Executes code for audio-to-text conversion (Transcribe Lambda) and text summarization with sentiment analysis (Backend Lambda).
5. IAM: Managed role permissions for accessing AWS services.
6. Transcribe: Converts uploaded audio files to text.
7. Comprehend: Detects the sentiment of summarized text.
8. Terraform: Implemented Infrastructure as Code (IaC) to provision resources on AWS.

### Other Technologies
1. ReactJS: Powers the frontend web application.
2, sumy and nltk: Libraries used for text summarization using Lunn's theorem.
3, Boto3: Python SDK for AWS, facilitating interaction with S3 buckets.
4. Gunicorn: WSGI server for running the Flask application.

## Terraform Implementation

Terraform played a crucial role in this project by enabling Infrastructure as Code (IaC) practices. With Terraform, I could define and provision the necessary AWS resources programmatically, ensuring consistency and reproducibility across deployments. The Terraform scripts were responsible for creating EC2 instances to host the frontend application, setting up Lambda functions for audio processing, configuring S3 buckets for data storage, and managing IAM roles for access control. This approach streamlined the deployment process and facilitated easy scalability as the project evolved.

## Set Up

- The steps for setting up are in the file [setup.txt](setup.txt)
- All the terraform files are in the folder [terraform](terraform/)

## Architecture Diagram

### Flow of Data
1. User Interaction: Users interact with the ReactJS-powered frontend interface, developed using Amplify, to upload audio files.
2. File Storage: The uploaded audio file is stored in an S3 bucket.
3. Audio-to-Text Conversion: A Lambda function is triggered to convert the audio file to text using Amazon Transcribe.
4. Text Summarization and Sentiment Analysis: Another Lambda function performs text summarization and sentiment analysis on the transcribed text.
5. Summarized Content Storage: The summarized content, along with its sentiment analysis, is stored in a separate S3 bucket.
6. Display to User: The summarized content is fetched from the S3 bucket and displayed to the user on the frontend interface.

<img width="800" align="center" alt="Screenshot 2024-02-21 at 8 21 44 PM" src="https://github.com/noopur-phadkar/PodcastSummarizer/assets/98292727/1ab0e850-cd7f-4ce3-b95a-a0c60f13de76">

### Frontend
The frontend of the Podcast Summarizer project utilizes ReactJS, a lightweight and flexible web application framework, alongside Amplify. ReactJS contributes to structuring the frontend and facilitating smooth user interactions, as well as dynamic content display. Amplify further enhances ReactJS by simplifying the development process and offering additional features, thus aiding in the creation of a robust application.

### Backend
The backend of the Podcast Summarizer project comprises several AWS services orchestrated using Terraform. Upon uploading an audio file through the front end, the file is stored in an S3 bucket. A Lambda function is triggered to convert the audio file to text using Amazon Transcribe. Once the transcription is complete, another Lambda function performs text summarization and sentiment analysis using natural language processing techniques. The summarized content, along with its sentiment analysis, is stored in a separate S3 bucket and made available to the front end for display.

# 

By implementing the Podcast Summarizer, I aimed to streamline the podcast consumption experience and empower users to make informed decisions about their listening preferences. Whether you're a podcast enthusiast or a casual listener, this solution offers a convenient way to discover and explore content efficiently.
