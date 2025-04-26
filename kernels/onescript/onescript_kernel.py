import subprocess
import tempfile
from ipykernel.kernelbase import Kernel
import logging

class OneScriptKernel(Kernel):
    implementation = 'OneScript'
    implementation_version = '1.0'
    language = 'onescript'
    language_version = '1.0'
    language_info = {
        'name': 'OneScript',
        'mimetype': 'text/plain',
        'file_extension': '.os',
    }
    banner = "OneScript kernel for Jupyter Notebook"

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.log = logging.getLogger(__name__)
        self.log.setLevel(logging.INFO)
        handler = logging.StreamHandler()
        handler.setLevel(logging.INFO)
        self.log.addHandler(handler)

    def do_execute(self, code, silent, store_history=True, user_expressions=None, allow_stdin=False):
        # Создаем временный файл для хранения кода
        if code[0:4]=="opm ":
            runb=code.split(" ")
        else:
            # Создаем временный файл для хранения кода
            with tempfile.NamedTemporaryFile(suffix='.os', mode='w', delete=False) as temp_file:
                temp_file.write(code)
                temp_file_path = temp_file.name

            comand='oscript'
            params=temp_file_path
            runb=[comand, params]
        
        try:
            # Выполняем файл через OneScript
            result = subprocess.run(
                runb,
                capture_output=True,
                text=True
            )

            # Читаем вывод и ошибки
            output = result.stdout.strip()
            error = result.stderr.strip()

            if error:
                stream_content = {'name': 'stderr', 'text': error}
                self.send_response(self.iopub_socket, 'stream', stream_content)
            else:
                stream_content = {'name': 'stdout', 'text': output}
                self.send_response(self.iopub_socket, 'stream', stream_content)

        finally:
            # Удаляем временный файл после выполнения
            import os
            try:
                os.unlink(temp_file_path)
            except Exception as e:
                self.log.info(f"Failed to delete temporary file: {e}")

        return {
            'status': 'ok',
            'execution_count': self.execution_count,
            'payload': [],
            'user_expressions': {},
        }

    def do_shutdown(self, restart):
        pass  # Нет процессов, которые нужно завершать

if __name__ == '__main__':
    from ipykernel.kernelapp import IPKernelApp
    IPKernelApp.launch_instance(kernel_class=OneScriptKernel)
