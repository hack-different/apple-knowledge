from cleo.io.io import IO
from poetry.poetry import Poetry
from poetry.plugins import Plugin
import subprocess


class ProcessPlugin(Plugin):
    @staticmethod
    def get_repo_height():
        git_branch_height = subprocess.run(['git', 'rev-list', '--count', 'build'], stdout=subprocess.PIPE)

        return git_branch_height.stdout.decode('utf-8').strip()

    def activate(self, poetry: Poetry, io: IO):
        poetry.package.version.replace(patch=self.get_repo_height())
        io.write_line(f"Set package version to <b>{poetry.package.version}</b>")
