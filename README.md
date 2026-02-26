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

>### Warning
>
> this uses **group 1000 for smb**
> [cozy-salt](https://github.com/vegcom/cozy-salt) sets our users as all `>2000` gid/uid
>
> **smb** group has to be **1000 on host**, as is in guest
>
> [How To](#permissions)

## Quick-Start

- You can enroll users either through [compose](#compose) [docker-compose.env.yml](docker-compose.env.yml) or [manually](#manual)
  - templated from [docker-compose.env.yml.example](docker-compose.env.yml.example)

### Compose

```shell
cp .env.example .env
cp docker-compose.env.yml.example docker-compose.env.yml
vim .env docker-compose.env.yml # edit plz
docker compose -f docker-compose.yml -f docker-compose.env.yml up -d
```

### Manualy Adding Users

```shell
docker exec -it samba --adduser demo --pass Sup3rP4ssw0rd123
```

```shell
openssl rand -hex 36
```

## Troubleshooting & problem solving

### Permissions

samba requires ( via `samba.sh` ) to be gid 1000 so we just run our users off 2000+

```shell
addgroup --gid 1000 smb || groupmod --gid 1000 smb
chown -R :smb /storage
chmod -R g+rwX /storage
find /storage -type d -exec chmod g+s {} \;
app/samba/users.conf
```

### Networking

```bash
# 10.0.0.0/24 is a standin
docker network create -d macvlan \
  --subnet=10.0.0.0/24 \
  --gateway=10.0.0.1 \
  -o parent=eth0 \
  frontend
```

```bash
# 10.0.0.254 is an unassigned IP
ip link delete frontend-shim
ip link add frontend-shim link eth0 type macvlan mode bridge
ip addr add 10.0.0.254/24 dev frontend-shim
ip link set frontend-shim up
```

```bash
# 10.0.0.200 is the default salt master IP
ip route add 10.0.0.200/32 dev frontend-shim
```

## Attribution

Built from [dockur/samba](https://github.com/dockur/samba)
