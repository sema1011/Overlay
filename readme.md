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
| `app-office/freeLib` | Cataloger for LibRusEc and Flibusta book libraries |
| `app-portage/portconf` | /etc/portage cleaner |
| `games-util/gtnh-daily-updater` | Updates daily and experimental GTNH packs to the latest version |
| `media-radio/radiotray-ng` | Internet radio player for Linux based on GStreamer |
| `media-sound/grooveoff` | Offline Grooveshark.com music |

## Лицензия

Каждый ebuild имеет свою лицензию, указанную в заголовке файла.
