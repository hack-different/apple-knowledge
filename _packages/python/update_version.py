#!/usr/bin/env python

import subprocess

height = '0'

try:
    git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'main'], stdout=subprocess.PIPE)
    height = git_branch_height.stdout.decode('utf-8').strip()
except subprocess.CalledProcessError:
    height = '0'

if height is None:
    height = '0'

project_content = None

with open('pyproject.toml', 'r') as input_file:
    project_content = input_file.read()

project_content = project_content.replace('version = "1.0.0"', f"version = \"1.0.{height}\"")

with open('pyproject.toml', 'w') as output_file:
    output_file.write(project_content)