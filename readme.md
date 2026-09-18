# Gentoo Overlay

> Персональный overlay с дополнительными ebuild'ами

## Описание

Этот overlay содержит ebuild'ы, которых нет в official Gentoo repository.

## Установка

Добавьте в `/etc/portage/repos.conf/overlay.conf`:

```ini
[overlay]
location = /var/db/repos/overlay
sync-type = git
sync-uri = https://github.com/sema1011/Overlay.git
priority = 50
```

Затем выполните:

```bash
emerge --sync overlay
```

## Пакеты

| Пакет | Описание |
|-------|----------|
| `app-portage/portconf` | /etc/portage cleaner |

## Лицензия

Все ebuild'ы распространяются под лицензией [GPL-2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
