#!/usr/bin/env python

import subprocess

git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'main'], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
if git_branch_height.returncode == 0:
    height = git_branch_height.stdout.decode('utf-8').strip()
else:
    height = "0"

with open('pyproject.toml', 'r') as input_file:
    project_content = input_file.read()

project_content = project_content.replace('version = "1.0.0"', f"version = \"1.0.{height}\"")

with open('pyproject.toml', 'w') as output_file:
    output_file.write(project_content)