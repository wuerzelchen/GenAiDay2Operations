# define python alpine as base
FROM python:3.12-alpine

# set workind directory
WORKDIR /app

# copy requirements file
COPY requirements.txt .

# install dependencies
RUN pip install -r requirements.txt

# copy the rest of the files
COPY . .

# run the app
CMD ["python", "app.py"]
