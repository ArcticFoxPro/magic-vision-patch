"""
Magic Vision Patch
Copyright (C) 2026 ArcticFoxPro

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

import shutil
from pathlib import Path
import pefile
from dataclasses import dataclass


@dataclass(frozen=True)
class Patch:
    name: str
    rva: int
    expected: bytes
    replacement: bytes


PATCHES = {
    "Util.dll": [
        Patch(
            "IsHonorDevice -> always true",
            0x119190,
            b"\x48\x89\x5C\x24\x08\x57",
            b"\xB8\x01\x00\x00\x00\xC3",
        ),
        Patch(
            "GetProductName early fail -> return 1",
            0x14A5C3,
            b"\x33\xC0",
            b"\xB8\x01\x00\x00\x00",
        ),
        Patch(
            "GetProductName init fail branch -> always continue",
            0x14A5C1,
            b"\x75\x07",
            b"\xEB\x07",
        ),
        Patch(
            "GetProductName lookup fail branch -> always continue",
            0x14A5EA,
            b"\x74\x32",
            b"\x90\x90",
        ),
    ],
    "Launcher.exe": [
        Patch(
            "isSupportInstall result -> force success (path A)",
            0x20507,
            b"\x0F\xB6\xD8",
            b"\xB3\x01\x90",
        ),
        Patch(
            "isSupportInstall result -> force success (path B)",
            0x20976,
            b"\x0F\xB6\xD8",
            b"\xB3\x01\x90",
        ),
        Patch(
            "IsSupportInstall core fail return -> true",
            0x6C18,
            b"\x32\xC0",
            b"\xB0\x01",
        ),
    ],
}


def apply_patches_single_file(
    original_path: Path,
    patches: list[Patch],
    output_path: Path | None = None,
    backup: bool = True,
) -> None:
    if not original_path.exists():
        print(f"Warning: {original_path} not found!")
        return

    if output_path is None:
        output_path = original_path
    elif backup:
        backup_path = original_path.with_suffix(original_path.suffix + ".bak")
        if not backup_path.exists():
            shutil.copy2(original_path, backup_path)
            print(f"Backup created: {backup_path}")

    data = bytearray(original_path.read_bytes())
    pe = pefile.PE(str(original_path), fast_load=True)
    
    for patch in patches:
        try:
            offset = pe.get_offset_from_rva(patch.rva)
            current = bytes(data[offset : offset + len(patch.expected)])
            
            if current == patch.expected:
                data[offset : offset + len(patch.replacement)] = patch.replacement
                print(f"  Patched: {patch.name}")
            elif bytes(data[offset : offset + len(patch.replacement)]) == patch.replacement:
                print(f"  Skip (already patched): {patch.name}")
            else:
                print(
                    f"  Warning: Unexpected bytes at RVA 0x{patch.rva:X} - expected {patch.expected.hex()}, got {current.hex()}"
                )
                
        except Exception as e:
            print(f"  Error applying {patch.name}: {e}")

    output_path.write_bytes(data)
    print(f"  Saved: {output_path}")


def main() -> int:
    print("=" * 50)
    print("MagicAnimation Patch Tool")
    print("=" * 50)
    
    root_dir = Path(__file__).resolve().parent
    
    for filename, patches in PATCHES.items():
        print(f"\nProcessing {filename}...")
        path = root_dir / filename
        output_path = root_dir / f"{filename}.patched"
        
        if path.exists():
            apply_patches_single_file(path, patches, output_path=output_path, backup=True)
        else:
            print(f"  Warning: {filename} not found!")
    
    print("\nDone!")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
