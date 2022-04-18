import subprocess
import pathlib
import os
import shutil


def get_repo_height() -> int:
    git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'HEAD'], stdout=subprocess.PIPE)

    return int(git_branch_height.stdout.decode('utf-8').strip())


def build(kwargs):
    kwargs['version'] = f"1.0.{get_repo_height()}"
    print(kwargs)

    output_data = pathlib.Path(os.path.dirname(__file__)).joinpath('./share')
    input_data = pathlib.Path(os.path.dirname(__file__)).joinpath('../../_site/.data')
    for file in input_data.rglob('*.json'):
        shutil.copy(file, output_data)