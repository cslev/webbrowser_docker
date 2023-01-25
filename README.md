# webbrowser_docker
Run multiple different web browsers in a docker environment with GUI (through VNC).

VNC has been decided as the main way of getting the GUI applications, otherwise too many things must be shared from the HOST system.
These include `.Xauthority`, `DISPLAY` environment variable.
Most importantly, we do NOT want the container to run in the host's networking namespace to adequately isolate network traffic.

# Get the source
```
git clone https://github.com/cslev/webbrowser_docker
```

# Browsers available
 - Firefox 109.0 (installed from source)
 - Google Chrome (latest - downloaded at building stage)
 - Brave browser (latest - downloaded at building stage)

# Build image
The below commands is to build the container with all different browser settings
```
cd webbrowser_docker
sudo docker build -t cslev/webbrowser_docker:latest . -f Dockerfile
```

# Run container with `docker-compose`
Use the docker-compose file present in this repo.

For reference:
```
version: '3.6'

services:
  webbrowser:
    image: cslev/webbrowser_docker:latest
    container_name: webbrowser
    ports:
      - target: 5900
        published: 5555
        protocol: 'tcp'
```
As you can see, the VNC port 5900 will be exposed to the host machine by port 5555.

Then, run the container:
```
$ sudo docker-compose up
```
Use `-d` at the end if you do not want to see the VNC server output.

# Connect to the VNC server
Grab your favorite VNC client and connect to `127.0.0.1` on port `5555` and voila'.

I like using the lightweight `xtightvncviewer` application for this.
```
$ sudo apt-get update
$ sudo apt-get install xtightvncviewer
$ xtightvncviewer 127.0.0.1:5555
```

You will see an `xterm` running. Since there is no Desktop Environment installed, one cannot start and close applications easily.
This is done for purpose to reduce the container's footprint.
Accordingly, never close the `xterm` window by pressing `Ctrl+D`.

## Start Firefox
In the `xterm`, issue the following command:
```
firefox
```
If the PATH (for some reason) does not work, use explicit path:
```
/webbrowser/firefox/firefox
```

## Start Chrome
In the `xterm`, issue the following command:
```
google-chrome-stable --no-sandbox
```
The argument `--no-sandbox` is needed, otherwise Chrome complains.

## Start Brave
In the `xterm`, issue the following command:
```
brave
```


# Closing a browser window and start another
As mentioned above, no Desktop Environment is provided, hence you won't see any window decorations and border. Simply close all tabs of the browser and it will close the app too.
Then, you are back at square one with the `xterm`.


 


