FROM python:3

WORKDIR /usr/src/app

RUN pip install setuptools

ADD setup.py .

RUN pip install .

ADD .env .
ADD src ./

ENTRYPOINT [ "python", "main.py"]

# default args
CMD [ "import" ]
