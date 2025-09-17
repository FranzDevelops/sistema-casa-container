# Firebird 2.5.9 Docker Container for Sistema Casa

This repository contains a Docker container for **Sistema Casa server**, preconfigured with **Firebird 2.5.9** and its necessary dependencies.  

## Build the image

```bash
docker build -t my-firebird-2.5.9 .
```

## Run the container (basic)
```bash
docker run -d --name firebird259 \
  -v ./db:/firebird/data \
  -p 3050:3050 \
  my-firebird-2.5.9
```

## Run the container (with restart policy, CPU, and RAM limits)
```bash
docker run -d --name firebird259 \
  --restart unless-stopped \
  --cpus=1.5 \
  --memory=2g \
  -v ./db:/firebird/data \
  -p 3050:3050 \
  my-firebird-2.5.9
```

## Access the container shell
```bash
docker exec -it firebird259 /bin/bash
```

## Notes
- The database files inside /firebird/data are mounted from ./db on your host, ensuring persistence.
- Firebird creates a default user (SYSDBA) with a password stored in SYSDBA.password inside the Firebird installation.

You can check it inside the container, for example:
```
docker exec -it firebird259 cat /firebird/etc/SYSDBA.password
```

Make sure to keep the password safe and update it as needed for security.
