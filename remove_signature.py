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

import os
import pefile

def remove_pe_signature(input_path, output_path=None):
    """
    剥离 PE 文件的数字签名
    
    :param input_path: 输入 PE 文件路径
    :param output_path: 输出文件路径，默认为原文件加 .unsigned 后缀
    """
    if not os.path.exists(input_path):
        print(f"错误：文件不存在 - {input_path}")
        return False
    
    if output_path is None:
        output_path = input_path + ".unsigned"
    
    try:
        # 加载PE文件
        pe = pefile.PE(input_path)
        
        # 检查是否有安全目录（数字签名存储位置）
        security_dir_idx = pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_SECURITY']
        security_dir = pe.OPTIONAL_HEADER.DATA_DIRECTORY[security_dir_idx]
        
        if security_dir.VirtualAddress == 0 and security_dir.Size == 0:
            print(f"提示：{input_path} 没有数字签名或签名已被剥离")
            return False
        
        # 清除安全目录引用
        pe.OPTIONAL_HEADER.DATA_DIRECTORY[security_dir_idx].VirtualAddress = 0
        pe.OPTIONAL_HEADER.DATA_DIRECTORY[security_dir_idx].Size = 0
        
        # 写入修改后的文件
        pe.write(output_path)
        pe.close()
        
        print(f"成功剥离数字签名：")
        print(f"  输入: {input_path}")
        print(f"  输出: {output_path}")
        return True
        
    except pefile.PEFormatError:
        print(f"错误：{input_path} 不是有效的 PE 文件")
        return False
    except Exception as e:
        print(f"处理 {input_path} 时发生错误: {str(e)}")
        return False

if __name__ == "__main__":
    # 要处理的文件列表
    target_files = ["Launcher.exe", "Util.dll"]
    
    for file_name in target_files:
        print(f"处理: {file_name}")
        remove_pe_signature(file_name)
        print("")
