# Базовый образ jupyter/base-notebook
FROM jupyter/base-notebook:latest

# Установка зависимостей
USER root

# Обновление системы и установка необходимых утилит
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        sudo \
        && \
    rm -rf /var/lib/apt/lists/*

# Копирование и установка OneScript
COPY ./install/onescript-engine_1.9.2_all.deb /tmp/onescript.deb

RUN dpkg -i /tmp/onescript.deb || \
    (apt-get update && apt-get install -f -y && rm -rf /var/lib/apt/lists/*) && \
    rm /tmp/onescript.deb

# Настройка прав на директорию OneScript
# Вместо chmod 777 — даём доступ пользователю jovyan
RUN chown -R $NB_UID:$NB_GID /usr/share/oscript

# Копирование ядра Jupyter
COPY ./kernels/. /usr/local/share/jupyter/kernels/

# Возвращаемся к пользователю по умолчанию
USER $NB_UID

# Рабочая директория
WORKDIR $HOME

# Запуск Jupyter Notebook
CMD ["start-notebook.sh"]