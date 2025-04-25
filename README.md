# onescript-kernel-jutyter
Ядро onescript для jupyter notebook

Для создания ядра Jupyter Notebook, которое будет использовать язык программирования OneScript, необходимо выполнить несколько шагов. OneScript — это скриптовый язык, совместимый с 1С:Предприятие, и для его интеграции в Jupyter потребуется создать пользовательское ядро.

Ниже приведен пошаговый план и пример кода для реализации такого ядра.

---

### Шаг 1: Установка необходимых инструментов
1. **Установите Jupyter Notebook**:
   Если у вас еще не установлен Jupyter, выполните:
   ```bash
   pip install notebook
   ```

2. **Установите OneScript**:
   Скачайте и установите OneScript с официального сайта: [https://oscript.io/](https://oscript.io/).

3. **Установите `jupyter_kernel`**:
   Для создания пользовательского ядра используется пакет `jupyter_kernel`. Установите его:
   ```bash
   pip install jupyter_kernel
   ```

---

### Шаг 2: Создание ядра OneScript
Ядро Jupyter Notebook — это программа, которая взаимодействует с Jupyter через протокол ZeroMQ. Мы будем использовать Python для создания интерфейса между Jupyter и OneScript.

#### 1. Скопируйте каталог с ядром из репозитория в каталог ~/.local/share/jupyter/
Эти файлы содержат логику ядра для OneScript.
Должно получиться:
~/.local/share/jupyter/kernels/onescript/kernel.json
~/.local/share/jupyter/kernels/onescript/onescript_kernel.py

### Шаг 3: Запуск Jupyter Notebook
1. Запустите Jupyter Notebook:
   ```bash
   jupyter notebook
   ```

2. При создании новой записной книжки выберите ядро "OneScript" из списка доступных ядер.

---

### Пример использования
Теперь вы можете писать код на OneScript прямо в Jupyter Notebook. Например:
```onescript
// Простой пример
Перем a;
a = 5 + 3;
Сообщить(a);
```

Результат выполнения будет отображаться в ячейке вывода.
