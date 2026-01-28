# cozy-share

```plain
   ╭────────────────────────────────────────╮
   │  cozy‑share — a warm little net share  │
   ╰────────────────────────────────────────╯
                   (^-^)
                          ✧
                         ✧ ✧     Q(-_-q)
                       ✧  ✧  ✧
                         ✧ ✧
                          ✧
           (づ｡◕‿‿◕｡)づ
```

## Quick-Start

- You can enroll users either through [compose](#compose) [docker-compose.env.yml](docker-compose.env.yml) or [manually](#manual)
  - templated from [docker-compose.env.yml.example](docker-compose.env.yml.example)

### Compose

```shell
cp docker-compose.env.yml.example docker-compose.env.yml

vim docker-compose.env.yml # edit plz

docker compose -f docker-compose.yml -f docker-compose.env.yml up -d
```

### Manual

```shell
docker exec -it samba --adduser demo --pass Sup3rP4ssw0rd123
```

## Adding users

docker exec -it samba --adduser user --pass S3cr3tP4ssw04d

### generate a mid passphrase?

```shell
openssl rand -hex 36
```

## Networking

If you have to add a network the long way, here you go

- Pros
  - allows broadcast without conflict
  - none of the downsides of host networking
- Cons
  - idk yet

```bash
# 10.0.0.0/24 is a standin
docker network create -d macvlan \
  --subnet=10.0.0.0/24 \
  --gateway=10.0.0.1 \
  -o parent=eth0 \
  frontend

# 10.0.0.100 is a standin
ip addr add 10.0.0.100/24 dev eth0
```

## Attribution

Built from [dockur/samba](https://github.com/dockur/samba)
