# Chiselled Python3.8

This directory contains the image recipes of Chiselled Python3.8. These
images are smaller in size, hence less prone to vulnerabilities. Know
more about chisel [here](https://github.com/canonical/chisel).

We currently have Chiselled Python3.8 only on focal. See
[rockcraft.yaml](./rockcraft.yaml).

### Building the image(s)

Build the rock in the usual way:

```sh
$ rockcraft pack
```

### Run the image(s)

Import the recently created rock into Docker using
[skopeo](https://github.com/containers/skopeo).

```sh
$ skopeo copy oci-archive:python_3.8_amd64.rock docker-daemon:ubuntu/python:3.8
```

The image has `pebble enter --verbose` as entrypoint. [Learn about
pebble](https://github.com/canonical/pebble).

```sh
$ docker run -it ubuntu/python:3.8
2024-01-25T10:20:35.681Z [pebble] Started daemon.
2024-01-25T10:20:35.687Z [pebble] POST /v1/services 1.941757ms 400
2024-01-25T10:20:35.687Z [pebble] Cannot start default services: no default services
...
```

You can access the `python3` interpreter with the following command:

```sh
$ docker exec -it <container-name> python3
Python 3.8.10 (default, Nov 22 2023, 10:22:35)
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print("hello world")
hello world
>>> exit()
```

### Building and running an application on Chiselled Python3.8

Let's assume, you have the following Python3 source code you want to run
as an application. Assume the file is called `main.py`.

```py
print("hello world")
```

You may create the following Dockerfile for your application image:

```Dockerfile
FROM ubuntu/python:3.8

ADD main.py /

ENTRYPOINT ["python3.8", "/main.py"]
```

Build the image:

```sh
$ docker build -t myapp -f Dockerfile.app .
```

Run your application container:

```sh
$ docker run myapp
hello world
```

### Running a Python application as Pebble service

You can run your python application as a pebble service too. There is a
`python3` service inside the rock that you can utilise.

```sh
$ docker run -it -v $PWD:/app:ro ubuntu/python:3.8 \
	--args python3 /app/main.py \; start python3
2024-01-25T10:30:16.708Z [pebble] Started daemon.
2024-01-25T10:30:16.717Z [pebble] POST /v1/services 6.882444ms 202
Start service "python3"
2024-01-25T10:30:16.722Z [pebble] Service "python3" starting: python3 [ /app/main.py ]
2024-01-25T10:30:16.811Z [python3] hello world
...
```
