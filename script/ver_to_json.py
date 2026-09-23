#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Конвертирует Overlay в JSON формат: {название-версия: {версия, url}}
Live-версии 9999 игнорируются.
"""

import json
import re
from pathlib import Path
from packaging.version import parse as _parse_version, InvalidVersion


OVERLAY_PATH = Path("/home/gentoo/Git/Overlay")


def parse_version(v: str):
    """Обёртка над packaging.version.parse для Gentoo-суффиксов (_p1, _alpha1, _rc1 и т.д.)."""
    v = v.lstrip("v")
    # Убираем Gentoo-ревизию (-r1, -r2, ...)
    v = re.sub(r'-r\d+$', '', v)
    try:
        return _parse_version(v)
    except InvalidVersion:
        v = re.sub(r'_p(\d+)', r'.post\1', v)
        v = re.sub(r'_alpha(\d*)', r'a\1', v)
        v = re.sub(r'_beta(\d*)', r'b\1', v)
        v = re.sub(r'_pre(\d*)', r'.rc\1', v)
        v = re.sub(r'_rc(\d*)', r'.rc\1', v)
        try:
            return _parse_version(v)
        except InvalidVersion:
            return _parse_version("0")


def parse_overlay(path: Path) -> tuple[dict, dict]:
    """Парсит Overlay и возвращает (packages, src_uris)."""
    packages = {}
    src_uris = {}

    for ebuild_file in path.rglob("*.ebuild"):
        name_file = ebuild_file.name
        if not name_file.endswith(".ebuild"):
            continue

        base = name_file[:-len(".ebuild")]
        match = re.match(r'^(.+?)-([\d][\d.a-zA-Z_-]*)$', base)
        if match:
            name = match.group(1)
            version = match.group(2)
            # Убираем Gentoo-ревизию (-r1, -r2, ...)
            version = re.sub(r'-r\d+$', '', version)
            # Игнорируем live-версии 9999
            if version == "9999":
                continue

            # Извлекаем SRC_URI из ebuild (однострочный и многострочный)
            src_uri = ""
            inherit_eclasses = []
            try:
                content = ebuild_file.read_text(encoding="utf-8", errors="replace")
                # Многострочный: SRC_URI=" ... "
                uri_match = re.search(r'^\s*SRC_URI\s*=\s*"(.*?)"', content, re.MULTILINE | re.DOTALL)
                if uri_match:
                    raw = uri_match.group(1)
                    # Убираем комментарии и лишние пробелы
                    raw = re.sub(r'#.*', '', raw)  # комментарии
                    raw = re.sub(r'\s+', ' ', raw).strip()  # нормализация пробелов
                    src_uri = raw
                # Захват inherit: однострочный и многострочный с \
                inherit_match = re.search(r'^\s*inherit\s+(.+)', content, re.MULTILINE)
                if inherit_match:
                    raw_inherit = inherit_match.group(1)
                    # Склеиваем строки с \ в конце
                    while raw_inherit.endswith('\\'):
                        raw_inherit = raw_inherit[:-1].strip()
                        # Ищем следующую строку
                        next_match = re.search(r'^\s*(.+)', content[inherit_match.end():], re.MULTILINE)
                        if next_match:
                            raw_inherit += " " + next_match.group(1).strip()
                        else:
                            break
                    inherit_eclasses = raw_inherit.split()
            except Exception:
                pass

            # Fallback: pypi eclass без SRC_URI
            if not src_uri and "pypi" in inherit_eclasses:
                src_uri = f"https://pypi.org/packages/project/{name}/{name}-{{version}}.tar.gz"

            # Fallback: EGIT_REPO_URI без SRC_URI
            if not src_uri:
                egit_match = re.search(r'^\s*EGIT_REPO_URI\s*=\s*"(.*?)"', content, re.MULTILINE)
                if egit_match:
                    src_uri = egit_match.group(1)

            # Fallback: HOMEPAGE если SRC_URI пуст
            if not src_uri:
                homepage_match = re.search(r'^\s*HOMEPAGE\s*=\s*"(.*?)"', content, re.MULTILINE)
                if homepage_match:
                    src_uri = homepage_match.group(1)

            if name not in packages:
                packages[name] = {}
                src_uris[name] = {}
            packages[name][version] = True
            src_uris[name][version] = src_uri

    return packages, src_uris


def extract_repo_url(src_uri: str, pkg_name: str = "") -> str:
    """Извлекает URL репозитория/релизов из SRC_URI."""
    if not src_uri:
        return ""
    # GitHub
    match = re.search(r'github\.com/([^/]+)/([^/]+)', src_uri)
    if match:
        owner, repo = match.group(1), match.group(2)
        # Убираем .git суффикс
        if repo.endswith(".git"):
            repo = repo[:-4]
        # Если имя репозитория — bash-переменная, fallback на pkg_name
        if ("$" in repo or "{" in repo) and pkg_name:
            return f"https://github.com/{owner}/{pkg_name}/releases"
        # Bash-переменная без fallback — возвращаем пустую строку
        if "$" in repo or "{" in repo:
            return ""
        return f"https://github.com/{owner}/{repo}/releases"
    # Codeberg
    match = re.search(r'codeberg\.org/([^/]+)/([^/]+)', src_uri)
    if match:
        owner, repo = match.group(1), match.group(2)
        if repo.endswith(".git"):
            repo = repo[:-4]
        if ("$" in repo or "{" in repo) and pkg_name:
            return f"https://codeberg.org/{owner}/{pkg_name}/releases"
        if "$" in repo or "{" in repo:
            return ""
        return f"https://codeberg.org/{owner}/{repo}/releases"
    # GitLab
    match = re.search(r'gitlab\.com/([^/]+)/([^/]+)', src_uri)
    if match:
        owner, repo = match.group(1), match.group(2)
        if repo.endswith(".git"):
            repo = repo[:-4]
        if ("$" in repo or "{" in repo) and pkg_name:
            return f"https://gitlab.com/{owner}/{pkg_name}/-/releases"
        if "$" in repo or "{" in repo:
            return ""
        return f"https://gitlab.com/{owner}/{repo}/-/releases"
    # PyPI
    match = re.search(r'pypi\.org/(?:project|pypi)/([^/]+)', src_uri)
    if match:
        return f"https://pypi.org/project/{match.group(1)}"
    # pypi eclass fallback: https://pypi.org/packages/project/{name}/{name}-{version}.tar.gz
    match = re.search(r'pypi\.org/packages/project/([^/]+)/', src_uri)
    if match:
        return f"https://pypi.org/project/{match.group(1)}"
    # mirror://pypi/ — пропустить букву-директорию или bash-переменную
    match = re.search(r'mirror://pypi/[^/]+/([^/]+)', src_uri)
    if match:
        project = match.group(1)
        # Если имя — bash-переменная, fallback на pkg_name
        if ("$" in project or "{" in project) and pkg_name:
            return f"https://pypi.org/project/{pkg_name}"
        # Bash-переменная без fallback — возвращаем пустую строку
        if "$" in project or "{" in project:
            return ""
        return f"https://pypi.org/project/{project}"
    # SourceForge
    match = re.search(r'mirror://sourceforge/([^/]+)', src_uri)
    if match:
        return f"https://sourceforge.net/projects/{match.group(1)}/best_release.json"
    match = re.search(r'downloads\.sourceforge\.net/(?:project|sourceforge)/([^/]+)/', src_uri)
    if match:
        return f"https://sourceforge.net/projects/{match.group(1)}/best_release.json"
    # GNU FTP
    match = re.search(r'ftp\.gnu\.org/gnu/([^/]+)/', src_uri)
    if match:
        return f"https://ftp.gnu.org/gnu/{match.group(1)}/"
    match = re.search(r'mirror://gnu/([^/]+)', src_uri)
    if match:
        return f"https://ftp.gnu.org/gnu/{match.group(1)}/"
    # Savannah (nongnu)
    match = re.search(r'mirror://nongnu/([^/]+)', src_uri)
    if match:
        return f"https://download.savannah.gnu.org/releases/{match.group(1)}/"
    return ""


def main():
    PACKAGES_JSON = Path(__file__).parent / "packages.json"

    # Читаем существующий packages.json если есть
    old_data = {}
    if PACKAGES_JSON.exists():
        try:
            old_data = json.loads(PACKAGES_JSON.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, Exception):
            old_data = {}

    # Читаем Overlay
    overlay_packages, src_uris = parse_overlay(OVERLAY_PATH)

    added = 0
    updated = 0
    errors = 0

    # Формируем результат — только последняя версия на пакет
    result = dict(old_data)  # начинаем с существующих данных
    for name in sorted(overlay_packages.keys()):
        versions = overlay_packages[name]
        # Оставляем только самую последнюю версию
        latest_ver = max(versions.keys(), key=parse_version)
        url = extract_repo_url(src_uris.get(name, {}).get(latest_ver, ""), name)
        entry = {"version": latest_ver, "url": url}

        if name in result:
            # Проверяем, изменились ли данные
            if result[name].get("version") != latest_ver or result[name].get("url") != url:
                result[name] = entry
                updated += 1
        else:
            result[name] = entry
            added += 1

        if not url:
            errors += 1

    # Записываем только если были изменения
    if added or updated:
        output = json.dumps(result, indent=2, ensure_ascii=False)
        PACKAGES_JSON.write_text(output + "\n", encoding="utf-8")
        print(f"Пакетов добавлено: {added}")
        print(f"Пакетов обновлено: {updated}")
        print(f"С ошибкой: {errors}")
    else:
        print("Изменений нет")


if __name__ == "__main__":
    main()
