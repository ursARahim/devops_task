FROM python:3.10-slim

RUN mkdir /app
 
WORKDIR /app
 
# Set environment variables 
# Prevents Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE=1
#Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1 

RUN pip install --upgrade pip 

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /app/static
RUN python manage.py collectstatic --noinput


EXPOSE 8000

# Command can be overridden in docker-compose for local dev
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "web_app.wsgi:application"]