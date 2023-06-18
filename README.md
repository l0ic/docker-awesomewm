## awesome 4.3 deb package for Debian Bookworm

This is the Dockerfile that can be used to build the deb package for *Debian Bookworm*.

To get a `deb` file just execute next commands:

```
cd awesome
docker build -t awesome:v1 .
docker run awesome:v1
docker cp $(docker ps -a -n=1 -q):/root/awesome_4.3.0-0~xxxx.deb .
```

Then, to install, execute

```
sudo dpkg -i ./awesome_4.3.0-0~xxxx.deb
sudo apt-get -f install  # To install missing dependencies (dpkg doesn't install any dependencies)
```
