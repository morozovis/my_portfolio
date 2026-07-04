#!/bin/bash
LOGFILE="$1"
if [[ -z $1 ]]; then # проверка но нулевой ввод
 echo "need to be log file"
 exit 1
fi
if [[ ! -f $1 ]]; then # проверка на существование файла
 echo "not found log file"
 exit 2
fi
error_count=$(grep -c "ERROR" "$LOGFILE") # чисо строк с ошибками
warning_count=$(grep -c "WARNING" "$LOGFILE") # число строк с предупреждениями
info_count=$(grep -c "INFO" "$LOGFILE") # число строк с информацией
context_errwar=$(grep -A 3 -B 3 -E "ERROR|WARNING" "$LOGFILE") # сбор конкеста около ошибок и предупреждений
tmpfile=$(mktemp) # создание временного файла
freq=$(grep -E "ERROR|WARNING" $LOGFILE > "$tmpfile" && sort "$tmpfile" | uniq -c | sort -nr ) # сортировка в частые ошибки и предупреждения через временный файл
rm "$tmpfile" # удаление временного файла
string_count=$(wc -l < "$LOGFILE") # счетчик строк всего
echo "=====ANALISATOR LOG=====" # все выводы
    if ((error_count > 5)); then # предупреждении о превышении ошибок
    echo "ERROR: ALARM! $error_count"
    else
    echo "ERROR: $error_count"
    fi
    if ((warning_count > 5)); then # предупреждение о превышении warning
    echo "WARNING: ALARM! $warning_count"
    else
    echo "WARNING: $warning_count"
    fi
echo "INFO: $info_count"
echo "SUM OF STRINGS: $string_count"
echo "Frequent mistakes:"
echo "$freq"
echo "log around of errwar: "
echo "$context_errwar"
