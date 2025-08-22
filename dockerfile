# Базовый образ jupyter/base-notebook
FROM jupyter/base-notebook:latest

# Установка зависимостей
USER root

# Обновление системы и установка необходимых утилит
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        sudo mono-complete curl\
        && apt-get install openjdk-17-jre -y \
        && \
    rm -rf /var/lib/apt/lists/*

# Копирование и установка OneScript
COPY ./install/onescript-engine_1.9.2_all.deb /tmp/onescript.deb

RUN dpkg -i /tmp/onescript.deb || \
    (apt-get update && apt-get install -f -y && rm -rf /var/lib/apt/lists/*) && \
    rm /tmp/onescript.deb

# Устанавливаю пакеты OneScript
RUN opm update opm

# Устанавливаю
RUN pip install ipywidgets

# Подсветка, контроль синтаксиса

# Основной плагин поддержки языковых серверов
RUN pip install jupyterlab-lsp python-lsp-server

# Установка bsl-language-server для синтаксис-контроля
## Основной движок bsl-language-server
# Скачиваем bsl-language-server
ENV BSL_LS_VERSION=0.24.2
RUN curl -L -o /opt/bsl-language-server.jar \
    https://github.com/1c-syntax/bsl-language-server/releases/download/v${BSL_LS_VERSION}/bsl-language-server-${BSL_LS_VERSION}-exec.jar


## Подключение движка bsl-language-server к jupyterlab-lsp
COPY ./bsl-lsp-server/bsl-server-implementation.json /opt/conda/etc/jupyter/jupyter_server_config.d/bsl-server-implementation.json
COPY ./bsl-lsp-server/plugin.jupyterlab-settings /home/jovyan/.jupyter/lab/user-settings/@jupyter-lsp/jupyterlab-lsp/plugin.jupyterlab-settings


# Копирование файла с примерами
COPY ./Example1C.ipynb /home/jovyan/Example1C.ipynb

# Настройка прав на директорию OneScript
# Вместо chmod 777 — даём доступ пользователю jovyan
RUN chown -R $NB_UID:$NB_GID /usr/share/oscript

# Копирование ядра OneScript
COPY ./kernels/. /usr/local/share/jupyter/kernels/

# Возвращаемся к пользователю по умолчанию
USER $NB_UID

# Рабочая директория
WORKDIR $HOME

# Запуск Jupyter Notebook
CMD ["start-notebook.sh"]