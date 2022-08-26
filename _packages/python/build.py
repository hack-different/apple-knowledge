import subprocess
import pathlib
import os
import shutil
import yaml
import json


def binary_constructor(loader: yaml.SafeLoader, node: yaml.nodes.MappingNode) -> str:
    """Construct an employee."""
    return str(node.value)


def get_loader():
    """Add constructors to PyYAML loader."""
    loader = yaml.SafeLoader
    loader.add_constructor("!binary", binary_constructor)
    return loader


def get_repo_height() -> int:
    git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'HEAD'], stdout=subprocess.PIPE)

    return int(git_branch_height.stdout.decode('utf-8').strip())


def build(kwargs):
    input_data = pathlib.Path(os.path.dirname(__file__)).joinpath('../../_data/').resolve()
    if input_data.exists():
        output_data = pathlib.Path(os.path.dirname(__file__)).joinpath('./share')
        if not pathlib.Path(output_data).exists():
            os.mkdir(output_data)

        for file in input_data.rglob('**/*.yaml'):
            try:
                input_file = pathlib.Path(file).relative_to(input_data)
                output_file = output_data.joinpath(input_file.with_suffix('.json'))

                print(f"Copying {input_file} to {output_file}")
                # Read YAML file
                with open(file, 'r') as stream:
                    data_loaded = yaml.load(stream, Loader=get_loader())

                    output_file.parent.mkdir(parents=True, exist_ok=True)

                    with open(output_file, 'w') as outfile:
                        json.dump(data_loaded, outfile, indent=4)
            except Exception as e:
                print(f"Error handling {file}:\n\n{e}")
                raise e
