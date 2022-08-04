import pathlib
import os
import json
from typing import Dict, Any

DATA_PATH = pathlib.Path(os.path.dirname(__file__)).joinpath('../share/')


def load_file(name: str) -> Dict[str, Any]:
    if name.endswith('.yaml'):
        name = name[:-5]

    if name.endswith('.yml'):
        name = name[:-4]

    if not name.endswith('.json'):
        name = f"{name}.json"

    data_path = DATA_PATH.joinpath(name)
    return json.loads(data_path.read_text())


def get_data(name: str) -> Dict[str, Any]:
    return load_file(name)