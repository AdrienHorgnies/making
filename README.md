# making

`making` calls `make` on any source (`git`) file change (`inotify`) and can execute artifacts.

## Usage

Use it just like `make`.
See `making -h` for its specific options (custom command, exclude files from monitoring, etc.).

![image](https://github.com/user-attachments/assets/a954ba30-f40c-4ce3-bf59-7c7352f3ba52)

## Install

For Debian based distribution, head over to https://aptly.fita.dev, add it to your repositories, and then:
```console
sudo apt install making
```

Otherwise, this is a single bash script, just download it inside your `PATH`, for example:
```console
cd /usr/local/bin;
sudo wget https://github.com/AdrienHorgnies/making/blob/main/making;
```

## Version

`making` follows [Semantic Versioning 2.0.0](https://semver.org/#semantic-versioning-200).
Furthermore, the patch version correspond to the number of commits on the branch main.

## Auditing

The build is reproducible.
The sha256 sum of all the packages of the same version must match.

```console
$ wget -q https://aptly.fita.dev/pool/main/m/making/making_0.0.34_1_amd64.deb -O repo.deb
$ make package >/dev/null && mv making_0.0.34_1_amd64.deb build.deb
$ sha256sum *.deb
f12294d903bf958b54ce7cbc4d684587821b062dbd42e179abc40985e2a3a5e7  build.deb
f12294d903bf958b54ce7cbc4d684587821b062dbd42e179abc40985e2a3a5e7  repo.deb
```
