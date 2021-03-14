import os

from setuptools import find_namespace_packages, setup

from src.kivy_garden.qrcode.version import __version__


def read(fname):
    with open(os.path.join(os.path.dirname(__file__), fname)) as f:
        return f.read()


# exposing the params so it can be imported
setup_params = {
    'name': 'kivy_garden.qrcode',
    'version': __version__,
    'description': 'Qrcode generator',
    'long_description': read('README.md'),
    'long_description_content_type': 'text/markdown',
    'author': 'Kivy',
    'author_email': 'kivy@kivy.org',
    'url': 'https://github.com/kivy-garden/qrcode',
    'packages': find_namespace_packages(where='src'),
    'package_data': {
        'kivy_garden.qrcode': ['*.kv'],
    },
    'package_dir': {'': 'src'},
    'python_requires': '>=3',
    'install_requires': [
        'kivy',
        'qrcode',
    ],
}


def run_setup():
    setup(**setup_params)


# makes sure the setup doesn't run at import time
if __name__ == '__main__':
    run_setup()
