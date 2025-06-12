This repository contains two Windows batch scripts designed to help organize files in a directory:

📁 Archive_files.bat
What it does:
1) Scans the root directory for files of various extensions
2) Creates subfolders named after each file extension (e.g., "txt", "jpg")
3) Moves files into their corresponding extension folders
4) Processes files in batches of 100 per folder (to avoid having too many files in one directory)
5) Creates sequentially numbered subfolders when more than 100 files exist for an extension (e.g., "txt_1", "txt_2")

Typical use case:
When you have a cluttered folder with thousands of mixed file types and want them organized by extension in manageable groups.

How to use:
1) Place the batch file in your target directory
2) Double-click to execute
3) Files will be sorted into extension-named subfolders


📂 Extract_files.bat
What it does:
1) Scans all subdirectories within the root folder
2) Moves all files from subfolders back to the root directory
3) Preserves the original filenames
4) Deletes empty folders after file extraction
5) Handles potential filename conflicts (if files with same name exist)

Typical use case:
When you need to flatten a nested directory structure (e.g., after using Archive_files or receiving extracted archive files in multiple subfolders).

How to use:
1)Place the batch file in the parent directory you want to flatten
2) Double-click to execute
3) All files will be moved to the root directory, and empty folders will be removed


⚠️ Important Notes
1) Always back up your files before running these scripts
2) The scripts affect only the directory where they're placed and its subdirectories
3) Test with sample files first to verify the behavior meets your expectations
4) Not recommended for system directories or folders with complex permissions

🛠 Requirements
Windows operating system
Enough disk space for file operations
Appropriate file permissions in the target directory
