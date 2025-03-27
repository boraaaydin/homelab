FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . /app
WORKDIR /app

# Expose ports
EXPOSE 5901 6080 7788 9222

# Set environment variables
ENV DISPLAY=:99 \
    RESOLUTION=1920x1080x24

# Default command is defined in docker-compose.yml 