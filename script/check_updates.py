#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Проверяет обновления пакетов на основе packages.json.
Использует curl для параллельных HTTP-запросов.
"""

import json
import re
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from packaging.version import parse as _parse_version, InvalidVersion


USER_AGENT = "WorldUpdates/1.0"
MAX_WORKERS = 10
PACKAGES_JSON = Path(__file__).parent / "packages.json"

# ANSI цвета
C_RESET = "\033[0m"
C_GREEN = "\033[32m"
C_YELLOW = "\033[33m"
C_RED = "\033[31m"
C_CYAN = "\033[36m"
C_BOLD = "\033[1m"


def c(text: str, color: str) -> str:
    return f"{color}{text}{C_RESET}"


def parse_version(v: str):
    """Обёртка над packaging.version.parse для Gentoo-суффиксов (_p1, _alpha1, _rc1 и т.д.)."""
    v = v.lstrip("v")
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


def curl_get(url: str, timeout: int = 10, headers: dict = None) -> str:
    """Загружает URL через curl."""
    cmd = ["curl", "-s", "-m", str(timeout), "--compressed", "-o", "-", "-w", ""]
    cmd.extend(["-H", f"User-Agent: {USER_AGENT}"])
    if headers:
        for k, v in headers.items():
            cmd.extend(["-H", f"{k}: {v}"])
    cmd.append(url)
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        if result.returncode == 0:
            return result.stdout
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return ""


def extract_latest_github(url: str) -> str:
    """GitHub: API releases → HTML releases → HTML tags."""
    repo_match = re.search(r'github\.com/([^/]+)/([^/]+)/', url)
    if not repo_match:
        return ""
    owner, repo = repo_match.group(1), repo_match.group(2)

    # API releases
    if "/releases" in url:
        api_url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
        headers = {"Accept": "application/vnd.github.v3+json"}
        data = curl_get(api_url, timeout=10, headers=headers)
        if data:
            try:
                tag = json.loads(data).get("tag_name", "")
                if tag:
                    return tag.lstrip("v")
            except json.JSONDecodeError:
                pass

        # Fallback: HTML releases
        html = curl_get(f"https://github.com/{owner}/{repo}/releases", timeout=10)
        if html:
            match = re.search(r'/releases/tag/(v?[\d.]+[a-zA-Z0-9._-]*)', html)
            if match:
                return match.group(1).lstrip("v")

    # Fallback: HTML tags
    html = curl_get(f"https://github.com/{owner}/{repo}/tags", timeout=10)
    if html:
        match = re.search(r'/tags/([^/"\?]+)', html)
        if match:
            tag = match.group(1).lstrip("v")
            tag = re.sub(r'\.(zip|tar\.gz|tgz|tar\.bz2|tar\.xz|deb|rpm|whl)$', '', tag, flags=re.IGNORECASE)
            if tag:
                return tag

    return ""


def extract_latest_codeberg(url: str) -> str:
    """Codeberg: API tags."""
    repo_match = re.search(r'codeberg\.org/([^/]+)/([^/]+)/', url)
    if not repo_match:
        return ""
    owner, repo = repo_match.group(1), repo_match.group(2)

    # API tags
    api_url = f"https://codeberg.org/api/v1/repos/{owner}/{repo}/tags"
    data = curl_get(api_url, timeout=10)
    if data:
        try:
            tags = json.loads(data)
            if tags:
                return tags[0]["name"].lstrip("v")
        except json.JSONDecodeError:
            pass

    # Fallback: HTML releases
    html = curl_get(f"https://codeberg.org/{owner}/{repo}/releases/latest", timeout=10)
    if html:
        match = re.search(r'/releases/tag/([^/"\?]+)', html)
        if match:
            return match.group(1).lstrip("v")

    return ""


def extract_latest_gitlab(url: str) -> str:
    """GitLab: HTML releases → HTML tags."""
    repo_match = re.search(r'gitlab\.com/([^/]+)/([^/]+)', url)
    if not repo_match:
        return ""
    owner, repo = repo_match.group(1), repo_match.group(2)

    # HTML releases
    html = curl_get(f"https://gitlab.com/{owner}/{repo}/-/releases", timeout=10)
    if html:
        match = re.search(r'"tag_name":"([^"]+)"', html)
        if match:
            return match.group(1).lstrip("v")
        match = re.search(r'/-/releases/([^/"\?]+)', html)
        if match:
            return match.group(1).lstrip("v")

    # Fallback: HTML tags
    html = curl_get(f"https://gitlab.com/{owner}/{repo}/-/tags", timeout=10)
    if html:
        match = re.search(r'/tags/([^/"\?]+)', html)
        if match:
            return match.group(1).lstrip("v")

    return ""


def extract_latest_pypi(url: str) -> str:
    """PyPI: JSON API."""
    try:
        name = url.rstrip("/").split("/")[-1]
        data = curl_get(f"https://pypi.org/pypi/{name}/json", timeout=10)
        if data:
            return json.loads(data)["info"]["version"]
    except (json.JSONDecodeError, KeyError):
        pass
    return ""


def extract_latest_sourceforge(url: str) -> str:
    """SourceForge: JSON API."""
    try:
        data = curl_get(url, timeout=10)
        if data:
            release = json.loads(data).get("release", {})
            version = release.get("version", "")
            if version:
                return version
            filename = release.get("filename", "")
            if filename:
                match = re.search(r'[\d][\d.a-zA-Z_-]*', filename)
                if match:
                    return match.group(0)
    except (json.JSONDecodeError, KeyError):
        pass
    return ""


def extract_latest_ftp(url: str) -> str:
    """GNU FTP / Savannah: HTML directory listing."""
    html = curl_get(url, timeout=10)
    if html:
        matches = re.findall(r'href="([^/]*?\.tar\.(?:gz|bz2|xz|lz))"', html)
        if matches:
            versions = []
            for fname in matches:
                match = re.search(r'-(.+)\.tar\.(?:gz|bz2|xz|lz)$', fname)
                if match:
                    versions.append(match.group(1))
            if versions:
                return max(versions, key=parse_version)
    return ""


def extract_latest_version(url: str) -> str:
    """Определяет тип URL и вызывает нужный парсер."""
    if not url:
        return ""

    if "github.com" in url:
        return extract_latest_github(url)
    if "codeberg.org" in url:
        return extract_latest_codeberg(url)
    if "gitlab.com" in url:
        return extract_latest_gitlab(url)
    if "pypi.org" in url:
        return extract_latest_pypi(url)
    if "sourceforge.net" in url:
        return extract_latest_sourceforge(url)
    if "ftp.gnu.org" in url or "download.savannah.gnu.org" in url:
        return extract_latest_ftp(url)

    return ""


def main():
    # Читаем packages.json
    with open(PACKAGES_JSON, encoding="utf-8") as f:
        packages = json.load(f)

    print(c(f"Пакетов: {len(packages)}", C_CYAN))
    print()

    # Группируем пакеты по URL
    url_groups: dict[str, list[tuple[str, dict]]] = {}
    for name, info in sorted(packages.items()):
        url = info["url"]
        if url not in url_groups:
            url_groups[url] = []
        url_groups[url].append((name, info))

    # Проверяем все URL параллельно
    results: dict[str, str] = {}

    def check_url(url: str) -> tuple[str, str]:
        return (url, extract_latest_version(url))

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {executor.submit(check_url, url): url for url in url_groups}
        for future in as_completed(futures):
            url, latest = future.result()
            results[url] = latest

    # Выводим результаты
    updated = 0
    current = 0
    errors = 0

    for url, group in sorted(url_groups.items()):
        latest = results.get(url, "")

        if not latest:
            for name, info in group:
                print(f"{c('⚠', C_RED)}  {c(name, C_BOLD)}: {info['version']} — N/A")
            errors += len(group)
        else:
            for name, info in group:
                is_latest = (name == max(group, key=lambda x: parse_version(x[1]["version"]))[0])
                if parse_version(info["version"]) < parse_version(latest):
                    if is_latest:
                        updated += 1
                    marker = c("⬆", C_YELLOW) if is_latest else " "
                    ver_installed = c(info["version"], C_YELLOW)
                    ver_latest = c(latest, C_YELLOW)
                    print(f"{marker}  {c(name, C_BOLD)}: {ver_installed} — {ver_latest}")
                else:
                    if is_latest:
                        current += 1
                    marker = c("✓", C_GREEN) if is_latest else " "
                    print(f"{marker}  {c(name, C_BOLD)}: {info['version']}")

    bar = c("═" * 60, C_CYAN)
    print()
    print(bar)
    print(f"  {c('Есть обновления:', C_YELLOW)} {c(updated, C_BOLD)}")
    print(f"  {c('Актуально:', C_GREEN)}     {c(current, C_BOLD)}")
    print(f"  {c('Ошибки:', C_RED)}        {c(errors, C_BOLD)}")
    print(bar)


if __name__ == "__main__":
    main()
