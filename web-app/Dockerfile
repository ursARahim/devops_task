FROM python:3.10-slim

RUN mkdir /app
 
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1 

RUN apt-get update && apt-get install -y git && apt-get clean

ARG GIT_COMMIT_HASH
ARG GIT_COMMIT_MESSAGE

ENV GIT_COMMIT_HASH=${GIT_COMMIT_HASH:-"Unknown"}
ENV GIT_COMMIT_MESSAGE=${GIT_COMMIT_MESSAGE:-"Unknown"}

RUN pip install --upgrade pip 

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /app/static
RUN python manage.py collectstatic --noinput


EXPOSE 8000

CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "web_app.wsgi:application"]