"""Генерация иконок Android для всех плотностей экрана."""
import os
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Установите Pillow: pip install Pillow")
    exit(1)

# Размеры для каждой плотности (Android launcher icons)
SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

PROJECT_ROOT = Path(__file__).resolve().parent.parent
SOURCE_ICON = PROJECT_ROOT / "assets" / "icon" / "app_icon.png"
RES_DIR = PROJECT_ROOT / "android" / "app" / "src" / "main" / "res"


def main():
    if not SOURCE_ICON.exists():
        print(f"Исходная иконка не найдена: {SOURCE_ICON}")
        exit(1)

    img = Image.open(SOURCE_ICON).convert("RGBA")

    for folder, size in SIZES.items():
        out_dir = RES_DIR / folder
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "ic_launcher.png"

        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(out_path, "PNG")
        print(f"Создано: {out_path} ({size}x{size})")

    print("Готово!")


if __name__ == "__main__":
    main()
