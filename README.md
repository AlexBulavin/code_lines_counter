# code_lines_counter
Bash script calculate count code lines wrote, deleted and changed in local repo.

Скрипт вычисляет количество строк кода в локальном репозитории за указанный пользователем период и со времени создания репозитория
Создаёт в папке репозитория вложенную папку statistics, а в ней два файла с данными repo_periodic_statistics.txt и repo_total_statistics.txt
Которые и хранят данные за период и за всё время.
Также выводит в консоль эти же данные.
Можно использовать в качестве непрямого инструмента измерения эффективности работы программистов
или для грубой оценки стоимости написанного кода. Например, используемый в проде код написан командой в течение 10 лет и состоит из 1М строк.
При этом сейчас команда пишет в среднем (данные можно взять за любой период) 100 строк продуктового кода в день на человека.
Значит оценка стоимости репозитория в человекоднях составляет 1М/100 = 10 000 человеко-дней.
Средний уровень команды соответствует Middle / Middle +
Предположим, что в месяце 21 рабочий день (на самом деле это совсем не так, нужно брать производственный календарь, количество рабочих дней в году за последние три-четыре года,
выводить средний показатель, уменьшать его на время отпуска и болезней), а фактический, предположим, 16 рабочих дней (реальный по 2021 году 15,58).
То есть отношение календарных дней к фактическим рабочим составляет 30/16 = 1,875 раз.
Таким образом, фактически потребуется 1,875 * 10 000 = 18 750 рабочих человеко-часов.
Предположим, что человеко-час специалиста указанного уровня составляет $18.
Значит стоимость разработки составит 18 750 * $18 = $338 040 плюс налоги, отчисления, сборы и прочие обязательные платежи.
Также к цене разработки добавятся аренда, оборудование, работа смежных специалистов - проджекта, продакта, дизайнера, тестировщиков, контент-иенеджеров, маркетологов, аналитиков, бухгалтрии,
юристов, патентоведов и так далее.
Из практики коэффициент составляет от 1,6 до 2,8 в зависимости от специфики проекта.
Значит фактическая стоимость может составить от $540 864 до $946 512

Чтобы сделать этот файл исполняемым запускаем в консоли команду:
chmod +x git_stat_v2.sh
Далее запускаем скрипт:
./git_stat_v2.sh

Результат будет выведен в консоль в виде:

Введите путь к репозиторию (по умолчанию /Users/alex/.../.../...): /Users/alex/Project1/RepoName1
Путь к репозиторию: /Users/alex/Project1/RepoName1
Введите начальную дату (по умолчанию 2024-02-26): 
Начальная дата: 2024-02-26
Введите конечную дату (по умолчанию 2024-05-26): 
Конечная дата: 2024-05-26
Запускаем сбор статистики по всем репозиториям и веткам с 2024-02-26 по 2024-05-26
Дата создания репозитория: 2020-07-01
Список всех веток репозитория:
  branch1
  dev
  feature_branch1
  feature_branch2
  feature_branch3
  feature_branch4
  ...
  master
  ....
Switched to branch 'branch1'
Your branch is up to date with 'origin/branch1'.
Already up to date.
Ветка: branch1
period_description = период
Период: с 2024-02-26 по 2024-05-26
branch1: Добавлено: , Удалено: , Изменено: 
Статистика по авторам:
Автор                Количество коммитов Добавлено строк       Удалено строк      Изменено строк
DEBUG: Завершён сбор статистики для ветки bad_not_tested_version

Ветка: branch1
period_description = за всё время репозитория
Период: с 2020-07-01 по 2024-05-26
branch1: Добавлено: 22730, Удалено: 13701, Изменено: 9029
Статистика по авторам:
Автор                Количество коммитов Добавлено строк       Удалено строк      Изменено строк
Автор1                       14              5500                 2349                 3151
Автор2                       59              8143                 5535                 2608
Автор3                       8               984                  947                  37
...
DEBUG: Завершён сбор статистики для ветки bad_not_tested_version

Switched to branch 'dev'
Your branch is up to date with 'origin/dev'.
Already up to date.
Ветка: dev
period_description = период
Период: с 2024-02-26 по 2024-05-26
dev: Добавлено: 30, Удалено: 10, Изменено: 20
Статистика по авторам:
Автор                Количество коммитов Добавлено строк       Удалено строк      Изменено строк
Автор1                       4               29                   7                    22
Автор2                       3               1                    2                    -1
Автор3                       1               0                    1                    -1
DEBUG: Завершён сбор статистики для ветки dev

Ветка: dev
period_description = за всё время репозитория
Период: с 2020-07-01 по 2024-05-26
dev: Добавлено: 21720, Удалено: 12874, Изменено: 8846
Статистика по авторам:
Автор                Количество коммитов Добавлено строк       Удалено строк      Изменено строк
Автор1                       14              5500                 2349                 3151
Автор2                       4               29                   7                    22
Автор3                       2               2                    37                   -35
...
DEBUG: Завершён сбор статистики для ветки dev

.... Аналогично по всем веткам ...

DEBUG: Завершён сбор статистики для всех веток
Суммарная статистика за период по всем веткам:
branch1: Добавлено: , Удалено: , Изменено: 
dev: Добавлено: 30, Удалено: 10, Изменено: 20
feature_branch1: Добавлено: , Удалено: , Изменено: 
feature_branch2: Добавлено: , Удалено: , Изменено: 
feature_3: Добавлено: , Удалено: , Изменено: 
...
master: Добавлено: , Удалено: , Изменено: 
...

Суммарная статистика за всё время по всем веткам:
branch1: Добавлено: 22730, Удалено: 13701, Изменено: 9029
dev: Добавлено: 21720, Удалено: 12874, Изменено: 8846
feature_branch1: Добавлено: 19325, Удалено: 8631, Изменено: 10694
feature_branch2: Добавлено: 20957, Удалено: 9826, Изменено: 11131
feature_branch3: Добавлено: 20821, Удалено: 9769, Изменено: 11052
...
master: Добавлено: 20799, Удалено: 9738, Изменено: 11061
...



