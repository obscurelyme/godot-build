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

Sign the executables for distribution

Will need to leverage Windows 10 SDK to use both `makecert` and `signtool`

[makecert](https://learn.microsoft.com/en-us/windows/win32/seccrypto/makecert)
[signtool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/using-signtool-to-sign-a-file)

```sh
makecert -r -pe -n "CN=[NAME OF SIGNER]" -a sha256 -sky signature -cy authority -sv CArootkey.pvk -len 2048 -m 13 CArootcert.cer

signtool sign -f certificate.pfx -fd SHA256 -p [password] -t http://timestamp.digicert.com example.exe
```
