import pathlib
import os
import json

DATA_PATH = pathlib.Path(os.path.dirname(__file__)).joinpath('../share/')


def load_file(name: str):
    if not name.endswith('.json'):
        name = f"{name}.json"

    data_path = DATA_PATH.joinpath(name)
    return json.loads(data_path.read_text())
