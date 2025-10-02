# Chiselled Python3.11

This directory contains the image recipes of Chiselled Python3.11. These
images are smaller in size, hence less prone to vulnerabilities. Know
more about chisel [here](https://github.com/canonical/chisel).

We currently have Chiselled Python3.11 only on jammy. See
[rockcraft.yaml](./rockcraft.yaml).

### Building the image(s)

Build the rock in the usual way:

```sh
$ rockcraft pack
```

### Running the image(s)

Import the recently created rock into Docker using
[skopeo](https://github.com/containers/skopeo).

```sh
$ /snap/rockcraft/current/bin/skopeo copy \
	oci-archive:python_3.11_amd64.rock \
	docker-daemon:ubuntu/python:3.11
```

The image has `pebble enter --verbose` as entrypoint. [Learn about
pebble](https://github.com/canonical/pebble).

```sh
$ docker run ubuntu/python:3.11
2024-02-22T09:16:53.017Z [pebble] Started daemon.
2024-02-22T09:16:53.020Z [pebble] POST /v1/services 284.402µs 400
2024-02-22T09:16:53.020Z [pebble] Cannot start default services: no default services
...
```

You can access the `python3` interpreter with the following command:

```sh
$ docker exec -it <container-name> python3
Python 3.11.0rc1 (main, Aug 12 2022, 10:02:14) [GCC 11.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> print("hello world")
hello world
>>> exit()
```

### Building and running an application on Chiselled Python3.11

Let's assume, you have the following Python3 source code you want to run
as an application. Assume the file is called `main.py`.

```py
print("hello world")
```

You may create the following Dockerfile for your application image:

```Dockerfile
FROM ubuntu/python:3.11

ADD main.py /

ENTRYPOINT ["python3", "/main.py"]
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

### Running a simple Python script without building another image

Let's assume the previous hello world example file at `./app/main.py`. You may run
the application with the Chiselled Python image as shown below:

```sh
$ docker run -v ./app:/app ubuntu/python:3.11 \
	exec python3 /app/main.py 2> logs
hello world
```
