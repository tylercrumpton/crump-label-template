# Crump Label Template
HTML/CSS/JS-based thermal printer label template for organizing my electronic components. Designed to be converted into an image using Selenium and a FF/Chrome/etc webdriver, or something similar.


## Features
- Responsive design for multiple label sizes
- Preview modes to show what the final cut label may look like
- 1D Barcode and QR code generation
- Data configuration via URL parameters

<img width="745" alt="image" src="https://user-images.githubusercontent.com/1317406/199188413-ea5569d8-b555-4c44-aec0-ee46c542966a.png">

## In-browser example

Using URL parameters, you can generate labels with specific pieces of data! For example, we can generate the above sample label by navigating to this url:

https://tylercrumpton.github.io/crump-label-template/crump-label-template.html?mpn=TCC0603X7R104K500CT&description=Multilayer%20Ceramic%20Capacitor%2C%201%20F%2C%2010%25%2C%20X7R%2C%2016%20V%2C%200805%20%5B2012%20Metric%5D&url=https%3A%2F%2Fpartsbox.com%2Ftylercrumpton%2Fparts%2F6y930qrd2ch2ga6gzzh947e5jz&box=01&bag=001&preview

If you want the ready-to-print label that can be used to generate an image using Selenium (or similar), just drop the `&preview` at the end.

## URL Parameter Options
- `mpn=` Manufacturer Product Number that is displayed at the top of the label and encoded in the 1D barcode
- `description=` Part description text displayed in the main part of the label
- `url=` URL that is encoded in the QR code
- `box=` Box number
- `bag=` Bag number
- `preview` If set, generate an example preview of the label instead of the ready-to-print layout
