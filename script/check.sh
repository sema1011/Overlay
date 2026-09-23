#!/usr/bin/env bash
# Обновление списка пакетов и проверка обновлений

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "═══ ver_to_json ═══"
python3 "$SCRIPT_DIR/ver_to_json.py"

echo
echo "═══ check_updates ═══"
OUTPUT=$(python3 "$SCRIPT_DIR/check_updates.py" 2>&1)
echo "$OUTPUT"

# Убираем ANSI-коды для парсинга
CLEAN=$(echo "$OUTPUT" | sed 's/\x1b\[[0-9;]*m//g')

# Извлекаем количество обновлений
UPDATES=$(echo "$CLEAN" | grep -oP 'Есть обновления:\s*\K\d+' 2>/dev/null || echo "0")

if [[ "$UPDATES" -gt 0 ]]; then
    # Формируем список пакетов с обновлениями
    PKGS=$(echo "$CLEAN" | grep '⬆' | sed 's/.*⬆[[:space:]]*//' | sed 's/:.*//' | tr '\n' ', ' | sed 's/,$//')
    notify-send -u critical "Есть обновления: $UPDATES" "$PKGS" -h string:x-canonical-private-synchronous:worldupdates
else
    notify-send -u normal "Все пакеты актуальны" "Обновлений нет" -h string:x-canonical-private-synchronous:worldupdates
fi
