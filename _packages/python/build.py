import subprocess
import pathlib
import os
import shutil


def get_repo_height() -> int:
    git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'HEAD'], stdout=subprocess.PIPE)

    return int(git_branch_height.stdout.decode('utf-8').strip())


def build(kwargs):
    input_data = pathlib.Path(os.path.dirname(__file__)).joinpath('../../_site/.data')
    if input_data.exists():
        output_data = pathlib.Path(os.path.dirname(__file__)).joinpath('./share')
        if not pathlib.Path(output_data).exists():
            os.mkdir(output_data)

        for file in input_data.rglob('*.json'):
            shutil.copy(file, output_data)