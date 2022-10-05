FROM python:3.9-slim
COPY requirements.txt /
RUN pip3 install -r /requirements.txt
RUN pip3 install gunicorn
COPY . /app
WORKDIR /app

RUN ["chmod", "+x", "/app/gunicorn.sh"]

ENTRYPOINT ["./gunicorn.sh"]

