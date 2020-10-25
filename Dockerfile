FROM python:3

WORKDIR /usr/src/app

RUN pip install setuptools

COPY . ./

RUN pip install .

CMD [ "python", "src/main.py"]
