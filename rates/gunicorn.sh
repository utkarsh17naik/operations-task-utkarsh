#!/bin/sh
gunicorn --chdir /app wsgi --timeout=1200 -w 2 --threads 2 -b 0.0.0.0:80
