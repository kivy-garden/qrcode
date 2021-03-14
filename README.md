# Module QRCode

[![Build Status](https://travis-ci.com/kivy-garden/qrcode.svg?branch=develop)](https://travis-ci.com/kivy-garden/qrcode)
[![Github Actions Tests](https://github.com/kivy-garden/qrcode/workflows/Tests/badge.svg)](https://github.com/kivy-garden/qrcode/actions?query=workflow%3ATests)
[![Coverage Status](https://coveralls.io/repos/github/kivy-garden/qrcode/badge.svg?branch=develop)](https://coveralls.io/github/kivy-garden/qrcode?branch=develop)
[![PyPI version](https://badge.fury.io/py/kivy-garden.qrcode.svg)](https://badge.fury.io/py/kivy-garden.qrcode)

<img src="https://raw.githubusercontent.com/kivy-garden/qrcode/develop/screenshot.png?raw=True" align="right" width="256" />

A QRCode Widget.

## Install
```sh
pip install kivy-garden.qrcode
```

## Usage

Python:
```python
from kivy_garden.qrcode import QRCodeWidget
parent.add_widget(QRCodeWidget(data="Kivy Rocks"))
```

kv:
```yaml
#:import QRCodeWidget kivy_garden.qrcode

BoxLayout:
    orientation: 'vertical'
    Button:
        text: 'press to change qrcode'
        on_release: qr.data = "Kivy Rocks!"
    QRCodeWidget:
        id: qr
        data: 'Hello World'
```

## Contribute
Pull requests are welcome, simply make sure tests are passing via:
```sh
make test
```
