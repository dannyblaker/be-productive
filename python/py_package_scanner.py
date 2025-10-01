# This script scans all Python files in the current directory and its subdirectories,
# identifies any imported packages that are not currently installed in the environment.
# It then installs any missing packages using pip. Additionally, it ensures that pip
# itself is upgraded to the latest version before installing any packages.

import os
import subprocess
import pkg_resources
import importlib.util


def install_missing_packages(module):
    spec = importlib.util.find_spec(module)
    if spec is None:
        subprocess.check_call(["pip", "install", module])


def install_packages_in_files(path="."):
    # Upgrade pip to the latest version
    subprocess.check_call(["pip", "install", "--upgrade", "pip"])

    # Scan all files in the directory and its subdirectories
    for root, dirs, files in os.walk(path):
        for file in files:
            # Check if the file is a Python file
            if file.endswith(".py"):
                filename = os.path.join(root, file)

                # Get a list of all imported packages in the file
                imported_packages = set()
                with open(filename, "r") as f:
                    for line in f:
                        if line.startswith("import ") or line.startswith("from "):
                            package = line.split()[1]
                            if "." in package:
                                package = package.split(".")[0]
                            imported_packages.add(package)

                # Check if any required packages are missing
                installed_packages = {
                    pkg.key for pkg in pkg_resources.working_set}
                missing_packages = imported_packages - installed_packages
                if missing_packages:
                    print(
                        f"Installing missing packages in {filename}: {', '.join(missing_packages)}")
                    for package in missing_packages:
                        install_missing_packages(package)

    # Check again if any required packages are missing
    installed_packages = {pkg.key for pkg in pkg_resources.working_set}
    missing_packages = {"simpleaudio"} - installed_packages
    if missing_packages:
        print(
            f"Installing missing packages after upgrading pip: {', '.join(missing_packages)}")
        for package in missing_packages:
            install_missing_packages(package)


if __name__ == "__main__":
    install_packages_in_files()