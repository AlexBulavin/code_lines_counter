#!/bin/bash

# Скрипт вычисляет количество строк кода в локальном репозитории за указанный пользователем период и со времени создания репозитория
# Создаёт в папке репозитория вложенную папку statistics, а в ней два файла с данными repo_periodic_statistics.txt и repo_total_statistics.txt
# Которые и хранят данные за период и за всё время.
# Также выводит в консоль эти же данные.
# Можно использовать в качестве непрямого инструмента измерения эффективности работы программистов
# или для грубой оценки стоимости написанного кода. Например, используемый в проде код написан командой в течение 10 лет и состоит из 1М строк.
# При этом сейчас команда пишет в среднем (данные можно взять за любой период) 100 строк продуктового кода в день на человека.
# Значит оценка стоимости репозитория в человекоднях составляет 1М/100 = 10 000 человеко-дней.
# Средний уровень команды соответствует Middle / Middle +
# Предположим, что в месяце 21 рабочий день (на самом деле это совсем не так, нужно брать производственный календарь, количество рабочих дней в году за последние три-четыре года,
# выводить средний показатель, уменьшать его на время отпуска и болезней), а фактический, предположим, 16 рабочих дней.
# То есть отношение календарных дней к фактическим рабочим составляет 30/16 = 1,875 раз.
# Таким образом, Фактически потребуется 1,875 * 10 000 = 18 750 рабочих человеко-часов.
# Предположим, что человеко-час специалиста указанного уровня составляет $18.
# Значит стоимость разработки составит 18 750 * $18 = $338 040 плюс налоги, отчисления, сборы и прочие обязательные платежи.
# Также к цене разработки добавятся аренда, оборудование, работа смежных специалистов - проджекта, продакта, дизайнера, тестировщиков, контент-иенеджеров, маркетологов, аналитиков, бухгалтрии,
# юристов, патентоведов и так далее.
# Из практики коэффициент составляет от 1,6 до 2,8 в зависимости от специфики проекта.
# Значит фактическая стоимость может составить от $540 864 до $946 512

# Чтобы сделать этот файл исполняемым запускаем в консоли команду:
# chmod +x git_stat_v2.sh
# Далее запускаем скрипт:
# ./git_stat_v2.sh

#Автор      Количество коммитов  Добавлено строк  Удалено строк  Изменено строк
#Автор1     123                  235              896            45

#В случае ошибки:
#warning: inexact rename detection was skipped due to too many files.
#warning: you may want to set your diff.renameLimit variable to at least 988 and retry the command.
#warning: inexact rename detection was skipped due to too many files.
#warning: you may want to set your diff.renameLimit variable to at least 988 and retry the command.
#Eё можно/нужно решить так (нужно зайти в папку репозитроия по которому собираем статистику) и выполнить команду, увеличивающую лимит:
#git config --global diff.renamelimit 9999 https://lists.altlinux.org/pipermail/devel/2011-July/191568.html

# Установка абсолютного пути к репозиторию по умолчанию
default_repo_path="/Путь к вашему репозиторию" #Пример default_repo_path="/Users/alex/FolderName/SubfolderName/RepoName"

# Переменная для хранения общей статистики
repo_periodic_statistics="" # Хранит статистику за период
repo_total_statistics="" # Хранит статистику за всё время с начала создания репозитория

# Переменные для хранения статистики по ветке за период и за всё время
branch_periodic_statistics="" # Хранит статистику ветки за период
branch_total_statistics="" # Хранит статистику ветки за всё время с начала создания репозитория

# Флаг режима отладки
DEBUG=true

# Цветовые коды для оформления вывода
COLOR_BRANCH='\033[1;34m'
COLOR_AUTHOR='\033[1;32m'
COLOR_RESET='\033[0m'

# Функция для сбора статистики по каждой ветке репозитория
collect_branch_statistics() {
    local period_description="$1" # Строковая переменная, равная "период" или "за всё время репозитория" в зависимости от задачи вызывающей функции
    local start_date="$2"
    local end_date="$3"
    local branch="$4"
    local repo_name="$5"

    echo -e "${COLOR_BRANCH}Ветка: $branch${COLOR_RESET}"
    echo "period_description = $period_description"

    # Проверяем переданные даты, если они пустые, то устанавливаем даты с начала коммитов
    if [ -z "$start_date" ]; then
        start_date=$(git log --reverse --pretty=format:"%ad" --date=short | head -n 1)
    fi

    if [ -z "$end_date" ]; then
        end_date=$(date +'%Y-%m-%d')
    fi

    echo "Период: с $start_date по $end_date"

    # Собираем статистику по строкам кода
    if [ "$period_description" == "период" ]; then
        branch_periodic_statistics=$(git log --pretty=tformat: --numstat --since="$start_date" --until="$end_date" \
            | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "Добавлено: %s, Удалено: %s, Изменено: %s\n", add, subs, loc }')
        echo -e "${COLOR_BRANCH}$branch: $branch_periodic_statistics${COLOR_RESET}"
    else
        branch_total_statistics=$(git log --pretty=tformat: --numstat \
            | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "Добавлено: %s, Удалено: %s, Изменено: %s\n", add, subs, loc }')
        echo -e "${COLOR_BRANCH}$branch: $branch_total_statistics${COLOR_RESET}"
    fi


# Функция для проверки наличия незакоммиченных изменений
    # Собираем статистику по каждому автору
    echo -e "${COLOR_AUTHOR}Статистика по авторам:${COLOR_RESET}"
    printf "%-25s %-20s %-35s %-30s %s\n" "Автор" "Количество коммитов" "Добавлено строк" "Удалено строк" "Изменено строк"
    git log --pretty=format:"%an" --since="$start_date" --until="$end_date" \
        | sort | uniq -c | while read -r count author; do
            added=$(git log --author="$author" --pretty=tformat: --numstat --since="$start_date" --until="$end_date" \
                | awk '{ add += $1 } END { print add }')
            removed=$(git log --author="$author" --pretty=tformat: --numstat --since="$start_date" --until="$end_date" \
                | awk '{ subs += $2 } END { print subs }')

            # Проверка значений и установка их в 0, если они пусты
            added=${added:-0}
            removed=${removed:-0}

            changed=$(($added - $removed))
            printf "%s\033[30G%-15s %-20s %-20s %s\n" "$author" "$count" "$added" "$removed" "$changed"
        done

    #Здесь \033[25G - escape последовательность, которая помещает курсор в позицию перед буквой G
    #в данном случае в 25 символ с начала этой же строки

    if [ "$DEBUG" = true ]; then
        echo "DEBUG: Завершён сбор статистики для ветки $branch"
    fi

    # Добавляем пустую строку между выводами для веток
    echo ""
}

# Функция для сбора статистики по всем веткам репозитория
collect_statistics() {
    local start_date="$1"
    local end_date="$2"
    local statistics_dir="$3"
    local repo_path="$4"

    cd "$repo_path" || exit

    branches=$(git branch -r | grep -v '\->' | sed 's/origin\///')

    for branch in $branches; do
        git checkout "$branch" && git pull

        collect_branch_statistics "период" "$start_date" "$end_date" "$branch" "$repo_name"
        repo_periodic_statistics+="$branch: $branch_periodic_statistics\n"

        collect_branch_statistics "за всё время репозитория" "" "" "$branch" "$repo_name"
        repo_total_statistics+="$branch: $branch_total_statistics\n"
    done

    git checkout main

    if [ "$DEBUG" = true ]; then
        echo "DEBUG: Завершён сбор статистики для всех веток"
    fi
}

# Функция для сохранения статистики в файл
save_statistics() {
    local statistics="$1"
    local file_path="$2"

    # Проверка на существование директории и создание при необходимости
    mkdir -p "$(dirname "$file_path")"

    # Создание файла и запись статистики
    echo -e "$statistics" > "$file_path"
}
check_uncommitted_changes() {
    if ! git diff-index --quiet HEAD --; then
        echo -e "${COLOR_BRANCH}В репозитории есть незакоммиченные изменения. Пожалуйста, закоммитьте или отложите их перед выполнением скрипта.${COLOR_RESET}"
        exit 1
    fi
}

# Функция для получения даты создания репозитория
get_repo_creation_date() {
    git log --reverse --pretty=format:"%ad" --date=short | head -n 1
}

# Запрос пути к репозиторию у пользователя
read -p "Введите путь к репозиторию (по умолчанию $default_repo_path): " repo_path
repo_path=${repo_path:-$default_repo_path}

echo "Путь к репозиторию: $repo_path"

statistics_dir="$repo_path/statistics"
mkdir -p "$statistics_dir"

# Вычисляем дату 3 месяца назад от текущей даты
start_date=$(date -v -3m +'%Y-%m-%d')

# Запрашиваем у пользователя начальную дату, используя предустановленную дату, если ввод не корректен или пользователь нажимает ENTER
read -p "Введите начальную дату (по умолчанию $start_date): " input_start_date
start_date=${input_start_date:-$start_date}
echo "Начальная дата: $start_date"

# Запрашиваем у пользователя конечную дату, используя сегодняшнюю дату, если ввод не корректен или пользователь нажимает ENTER
read -p "Введите конечную дату (по умолчанию $(date +'%Y-%m-%d')): " input_end_date
if [ -z "$input_end_date" ];then
    end_date=$(date +'%Y-%m-%d')
else
    end_date=$input_end_date
fi
echo "Конечная дата: $end_date"

if [ "$DEBUG" = true ]; then
    echo "Запускаем сбор статистики по всем репозиториям и веткам с $start_date по $end_date"
fi

# Переходим в репозиторий и проверяем наличие незакоммиченных изменений
cd "$repo_path" || exit
check_uncommitted_changes

# Получаем дату создания репозитория
repo_creation_date=$(get_repo_creation_date)
echo "Дата создания репозитория: $repo_creation_date"

# Выводим список всех веток репозитория
branches=$(git branch -r | grep -v '\->' | sed 's/origin\///')
echo -e "${COLOR_BRANCH}Список всех веток репозитория:${COLOR_RESET}\n$branches"

# Запускаем сбор статистики по всем репозиториям и веткам
collect_statistics "$start_date" "$end_date" "$statistics_dir" "$repo_path"

# Выводим суммарную статистику на печать
echo -e "Суммарная статистика за период по всем веткам:\n$repo_periodic_statistics"
echo -e "Суммарная статистика за всё время по всем веткам:\n$repo_total_statistics"

# Сохраняем суммарную статистику в файлы
save_statistics "Дата создания репозитория: $repo_creation_date\n\n$repo_periodic_statistics" "$statistics_dir/repo_periodic_statistics.txt"
save_statistics "Дата создания репозитория: $repo_creation_date\n\n$repo_total_statistics" "$statistics_dir/repo_total_statistics.txt"
