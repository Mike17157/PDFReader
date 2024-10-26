# Use Node.js base image
FROM node:23-bookworm

# Install system dependencies using apt-get
RUN apt-get update && apt-get install -y \
    ghostscript \
    tesseract-ocr \
    python3 \
    python3-pip \
    build-essential \
    python3-dev \
    python3-venv \
    ocrmypdf \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
# Set working directory
WORKDIR /app

# Initialize a new Next.js project with specified configuration
RUN npx create-next-app@latest pdf-reader --typescript --tailwind --eslint --app --src-dir --import-alias --use-npm

# Update working directory to include the new project folder
WORKDIR /app/pdf-reader

# Install shadcn-ui and initialize it
RUN npm install -g @shadcn/ui
RUN npx shadcn@latest init --yes

# Set up Python virtual environment and install requirements
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt .
RUN . /app/venv/bin/activate && pip install -r requirements.txt

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
