# godot-build

Dockerfile to build Godot for Windows and Linux systems

Build without encryption

```sh
docker build -t godot-binaries .
```

Build with encryption, you will need to set your own encryption key separate of this process as you will need to distribute the key to any client of the binaries you generate

More info on how to do that [here](https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_with_script_encryption_key.html)

```sh
docker build -t godot-binaries . --build-arg SCRIPT_AES256_ENCRYPTION_KEY=$(echo $SCRIPT_AES256_ENCRYPTION_KEY)
```

Extract the binaries

```sh
docker run -d --name binaries_container godot-binaries
docker cp binaries_container:/godot-4.2.2-stable/bin .
docker container remove binaries_container
```
