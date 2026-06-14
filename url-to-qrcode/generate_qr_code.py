#!/usr/bin/env python3
import qrcode
import os
import sys
import tempfile

def generate_qr_code(url):
    # 创建二维码对象
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    # 生成二维码图像
    img = qr.make_image(fill_color='black', back_color='white')

    # 保存到临时文件
    temp_dir = tempfile.gettempdir()
    temp_file = os.path.join(temp_dir, 'qr_code.png')
    img.save(temp_file)

    return temp_file

def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_qr_code.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    qr_file = generate_qr_code(url)

    # 输出Alfred JSON格式
    print(f'''{{
        "items": [
            {{
                "title": "QR Code Generated",
                "subtitle": "Click to open the QR code image",
                "arg": "{qr_file}",
                "icon": {{
                    "path": "{qr_file}"
                }}
            }}
        ]
    }}''')

if __name__ == "__main__":
    main()
