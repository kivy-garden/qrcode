from kivy_garden.qrcode import QRCodeWidget


class TestQRCodeWidget:

    def test_init(self):
        """
        Simply initialises the widget and checks a property.
        """
        qrcode_widget = QRCodeWidget()
        assert qrcode_widget.loading_image == 'data/images/image-loading.gif'
