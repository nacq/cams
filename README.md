### Setup

Camera 1:

rtsp://<camera_server_ip>:<port>/streaming/channels/101 (hd)

rtsp://<camera_server_ip>:<port>/streaming/channels/102 (sd)

Camera 2:

rtsp://<camera_server_ip>:<port>/streaming/channels/201 (hd)

rtsp://<camera_server_ip>:<port>/streaming/channels/202 (sd)

Note: authentication may be needed to start the connection

Build the image:
```
docker build --no-cache -t nginx-rtmp .
```

Run it:
```
docker run -d -p 1935:1935 -p 8080:8080 --name nginx-rtmp-container nginx-rtmp
```

Stream the source to the destination:
```
ffmpeg -i rtsp://<username>:<password>@<camera_server_ip>:<port>/streaming/channels/101 \
    -c:v libx264 -preset ultrafast -tune zerolatency \
    -c:a aac -ar 44100 \
    -f flv rtmp://127.0.0.1:1935/live/stream
```
