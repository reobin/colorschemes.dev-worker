<h1 align="center">
  <img alt="vimcolorschemes worker" src="https://github.com/vimcolorschemes/worker/blob/media/logo.png?raw=true" width="400" />
</h1>
<p align="center" style="border:none">
  I fetch color schemes repositories, and store them. That's about it
</p>

## Getting started

The import script queries Github repositories matching a query, and stores them in a mongoDB database.

This is the data source of [vimcolorschemes](https://github.com/reobin/vimcolorschemes)

### Requirements:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (See [below](#set-up-the-worker-wihout-docker) for the setup without docker)
- [mongodb-community](https://docs.mongodb.com/manual/installation/#mongodb-community-edition-installation-tutorials) running at port 27017

_Note_: The MongoDB database can also be ran from [the app docker setup](https://docs.vimcolorschemes.com/#/installation-guide?id=_1-docker).

### Run a job

To run a job, use the `bin/start` script:

```shell
bin/start
```

### Arguments

#### -j (job)

3 jobs are available:

- import
- clean
- udpate

By default, the import runs. To run a specific job, use the `-j` flag.

Example:

```shell
bin/start -j update
```

[Read more on the jobs](https://docs.vimcolorschemes.com/#/the-worker)

#### -b (build)

After making a change to the code, use the `-b` flag to force a new build to the
container.

Example:

```shell
bin/start -b
```

### Set up the environment variables

A template dotenv file (`.template.env`) is available at root.

Copy it using `cp .template.env .env` and update the values to your needs.

> TIP: Read the comments on the template dotenv file.

The `.env` is automatically picked up by the docker container when it runs.

#### GitHub queries

Since GitHub's API has a quite short rate limit for unauthenticated calls (60 for core API calls).
I highly recommend setting up authentication (5000 calls for core API calls) to avoid wait times when you reach the limit.

To do that, you first need to create your personal access token with permissions to read public repositories. Follow instructions on how to do that [here](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).

### Set up the worker wihout Docker

It is possible to run the jobs without docker.

First, make sure `python3` in installed on your machine.

Then, dependencies need to be installed:

```shell
pip3 install .
```

Source the dotenv file after setting it up:

```shell
source .env
```

Lastly, run the script using `src/main.py`:

```shell
python3 src/main.py
```

You can run a specific job by passing the job name as an argument:

```shell
python3 src/main.py update
```

## Deployment to Lambda

### The environment layer

A Lambda Layer is used to hold all the script dependencies.

When a new dependency is added, or one needs to be updated, the script should be run to build the layer.
The layer then needs to be updloaded to the configured Lambda Layer.

To run the script:

```bash
# at project root
sh create_lambda_layer.sh
```

### The actual script

A Github Action is set up to zip the content of the source directory, and deploy it to AWS Lambda.

All this is done on push to `master`.
