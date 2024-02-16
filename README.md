# PodcastSummarizer

Welcome to the Podcast Summarizer project! This project was developed by me with the goal of providing concise summaries of lengthy podcasts, enabling users to quickly grasp the main points and decide whether to invest time in listening to the full episode. Leveraging extractive summarization techniques along with sentiment analysis, this solution delivers informative and engaging summaries.

## Overview and Goals
Podcasting has become a popular medium for consuming content across various topics. However, lengthy podcast episodes can be daunting for users to commit to. With this project, I aimed to develop a solution that would generate concise summaries of podcasts. By extracting key points and sentiments from the audio content, the goal was to provide users with informative summaries that help them decide which podcasts to listen to.

## Technologies Used
### AWS Technologies
1. S3: Utilized for storage of audio files, transcribed text, and summarized outputs.
2. EC2: Hosts the frontend Flask application and executes Terraform scripts.
3. Lambda: Executes code for audio-to-text conversion (Transcribe Lambda) and text summarization with sentiment analysis (Backend Lambda).
4. IAM: Managed role permissions for accessing AWS services.
5. Transcribe: Converts uploaded audio files to text.
6. Comprehend: Detects the sentiment of summarized text.
7. Terraform: Implemented Infrastructure as Code (IaC) to provision resources on AWS.

### Other Technologies
1. Flask: Powers the frontend web application.
2, sumy and nltk: Libraries used for text summarization.
3, Boto3: Python SDK for AWS, facilitating interaction with S3 buckets.
4. Gunicorn: WSGI server for running the Flask application.

## Terraform Implementation

Terraform played a crucial role in this project by enabling Infrastructure as Code (IaC) practices. With Terraform, I could define and provision the necessary AWS resources programmatically, ensuring consistency and reproducibility across deployments. The Terraform scripts were responsible for creating EC2 instances to host the frontend application, setting up Lambda functions for audio processing, configuring S3 buckets for data storage, and managing IAM roles for access control. This approach streamlined the deployment process and facilitated easy scalability as the project evolved.


## Architecture Diagram

### Flow of Data
1. User Interaction: Users interact with the Flask-powered frontend interface to upload audio files.
2. File Storage: The uploaded audio file is stored in an S3 bucket.
3. Audio-to-Text Conversion: A Lambda function is triggered to convert the audio file to text using Amazon Transcribe.
4. Text Summarization and Sentiment Analysis: Another Lambda function performs text summarization and sentiment analysis on the transcribed text.
5. Summarized Content Storage: The summarized content, along with its sentiment analysis, is stored in a separate S3 bucket.
6. Display to User: The summarized content is fetched from the S3 bucket and displayed to the user on the frontend interface.

![image](https://github.com/noopur-phadkar/PodcastSummarizer/assets/98292727/cbbb3c2a-38ba-4f96-8994-f66879a4b6af)


### Frontend
The frontend component of the Podcast Summarizer project is powered by Flask, a lightweight and flexible web application framework. Users interact with the frontend interface to upload audio files and receive summarized content. The interface provides a seamless experience, allowing users to easily access and navigate through the summarization functionality.

### Backend
The backend of the Podcast Summarizer project comprises several AWS services orchestrated using Terraform. Upon uploading an audio file through the frontend, the file is stored in an S3 bucket. A Lambda function is triggered to convert the audio file to text using Amazon Transcribe. Once the transcription is complete, another Lambda function performs text summarization and sentiment analysis using natural language processing techniques. The summarized content, along with its sentiment analysis, is stored in a separate S3 bucket and made available to the frontend for display.

# 

By implementing the Podcast Summarizer, I aimed to streamline the podcast consumption experience and empower users to make informed decisions about their listening preferences. Whether you're a podcast enthusiast or a casual listener, this solution offers a convenient way to discover and explore content efficiently.
