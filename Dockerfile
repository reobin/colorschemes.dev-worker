FROM python:3

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
  vim \
  git

ENV TERM xterm-256color

RUN pip install setuptools

ADD setup.py .

RUN pip install .

ADD .env .
ADD src ./

ENTRYPOINT [ "python", "main.py" ]

# default args
CMD [ "import" ]
