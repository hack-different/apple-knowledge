# -*- coding: utf-8 -*-
from setuptools import setup

packages = \
['apple_data']

package_data = \
{'': ['*']}

setup_kwargs = {
    'name': 'apple-data',
    'version': '1.0.0',
    'description': 'Static data from https://docs.hackdiffe.rent',
    'long_description': '# Apple Data resource package\n\nThis package contains static assets from <https://docs.hackdiffe.rent>\n\nThe contents of the `_data` folder are included in `share/`',
    'author': 'Rick Mark',
    'author_email': 'rickmark@outlook.com',
    'maintainer': None,
    'maintainer_email': None,
    'url': None,
    'packages': packages,
    'package_data': package_data,
}
from build import *
build(setup_kwargs)

setup(**setup_kwargs)
