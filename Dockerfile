# Use Node.js base image
FROM node:18-bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ghostscript \
    tesseract-ocr \
    python3 \
    python3-pip \
    build-essential \
    python3-dev \
    ocrmypdf \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Initialize a new Next.js project with default configuration
RUN npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias --use-npm --yes

# Install shadcn-ui and initialize it
RUN npm install -g @shadcn/ui
RUN npx shadcn@latest init --yes

# Copy Python requirements and install them
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Build the frontend
RUN npm run build

# Expose ports for FastAPI and Next.js
EXPOSE 8000 3000

# Create a script to run both services
COPY start.sh .
RUN chmod +x ./start.sh

# Command to run the application
CMD ["./start.sh"]
