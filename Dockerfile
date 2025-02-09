# Use an official Python runtime as base image
FROM python:3.12.9-alpine3.21

# Set the working directory
WORKDIR /app

# Copy app files
COPY app.py requirements.txt ./

# Install dependencies
RUN pip install -r requirements.txt

# Expose the application port
EXPOSE 8080

# Command to run the app
CMD ["python", "app.py"]
