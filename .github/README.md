# ghcr_docker_image_alimalinux8_systemd

AlmaLinux8 を systemd で AlmaLinux8 systemd を Docker で動かすためのDockerImage

## 用途

Ansibleをローカルで実行したいなど。。。

## 使い方

```yaml
version: "3"
services:
  almalinux8_systemd:
    image: ghcr.io/webdimension/almalinux8_systemd:latest
    container_name: almalinux8_systemd
    ports:
      - "2222:22"
    privileged: true
    volumes:
      - ${YOUR_PUBLIC_KEY}:/home/ansible/.ssh/authorized_keys
```