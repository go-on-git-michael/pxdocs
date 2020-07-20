---
title: Install on Docker (shared)
description: Learn how to install Porworx as a runC container
keywords: Install, Docker, PX OCI
hidden: true
---

Portworx provides a Docker-based installation utility to help deploy the Portworx OCI bundle. You can install this bundle by running the following Docker container on your host system:

```text
REL="/{{% currentVersion %}}"  # Portworx v{{% currentVersion %}} release

latest_stable=$(curl -fsSL "https://install.portworx.com$REL/?type=dock&stork=false&aut=false" | awk '/image: / {print $2}')

# Download OCI bits (reminder, you will still need to run `px-runc install ..` after this step)
sudo docker run --entrypoint /runc-entry-point.sh \
    --rm -i --privileged=true \
    -v /opt/pwx:/opt/pwx -v /etc/pwx:/etc/pwx \
    $latest_stable
```
