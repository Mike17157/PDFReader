#!/bin/bash
npm run start & 
uvicorn main:app --host 0.0.0.0 --port 8000