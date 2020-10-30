FROM python:3

WORKDIR /usr/src/app

RUN pip install setuptools

COPY .env .
COPY setup.py .

COPY src ./

RUN pip install .

ENTRYPOINT [ "python", "main.py"]

# default args
CMD [ "import" ]
