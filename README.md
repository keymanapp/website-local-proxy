# Using website-local-proxy

This is a reverse proxy to handle the port-forwarding of the various locally-hosted Keyman sites. Assuming the corresponding sites already already running, the proxy can be started with the command-line:
```bash
build.sh build start
```

If you want the host to use a port other than 80, set the environment variable `PROXY_PORT` to the port number.

## Pre-requisites
On the host machine, install [Docker](https://docs.docker.com/get-docker/).

### DNS

Update the corresponding hosts file for the local DNS and add the following:

```bash
# Added for Keyman sites
127.0.0.1       api.keyman.com.local 
127.0.0.1       help.keyman.com.local 
127.0.0.1       keyman.com.local
127.0.0.1       keymanweb.com.local
# End of section
```

#### Linux
```bash
sudo vim /etc/hosts
```

#### Windows

C:\Windows\System32\Drivers\etc\hosts (Run as Administrator)
