# Using website-local-proxy

This is a reverse proxy to handle the port-forwarding of the various locally-hosted Keyman sites. Assuming the corresponding sites already already running, the proxy can be started with the command-line:
```bash
build.sh build start
```

If you want the host to use a port other than 80, set the environment variable `KEYMAN_COM_PROXY_PORT` to the port number.

Once the reverse proxy is started, you can browse to locally hosted Keyman sites like the following:
* http://api.keyman.com.localhost
* http://help.keyman.com.localhost
* http://keyman.com.localhost
* http://keymanweb.com.localhost
* http://s.keyman.com.localhost

## Pre-requisites

- On the host machine, install [Docker](https://docs.docker.com/get-docker/).

### DNS

- On macOS and perhaps others, you may need to edit `/etc/hosts` (probably with `sudo`)

```
127.0.0.1       localhost help.keyman.com.localhost api.keyman.com.localhost keyman.com.localhost keymanweb.com.localhost s.keyman.com.localhost
```
