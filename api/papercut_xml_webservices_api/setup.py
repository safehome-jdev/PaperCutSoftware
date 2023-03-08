#!/usr/bin/env python

"""The setup script."""

from setuptools import find_packages, setup

with open("./README.md") as readme_file:
    readme = readme_file.read()

with open("./HISTORY.md") as history_file:
    history = history_file.read()

# requirements = []

# test_requirements = []

setup(
    author="Jordan Reyes",
    author_email="jreyes@safehomedev.com",
    python_requires=">=3.8",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Natural Language :: English",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.10",
    ],
    description="PaperCut NG/MF server's API uses XML-RPC. This library utilizes Python's [stable XMLRPC library",
    # install_requires=requirements,
    license="MIT license",
    long_description=readme + "\n\n" + history,
    include_package_data=True,
    keywords="papercut_xml_webservices_api",
    name="papercut_xml_webservices_api",
    packages=find_packages(
        include=["papercut_xml_webservices_api", "papercut_xml_webservices_api.*"]
    ),
    # test_suite="tests",
    # tests_require=test_requirements,
    url="https://github.com/safehome_jdev/PaperCutSoftware/API/papercut_xml_webservices_api",
    version="0.1.0",
    zip_safe=False,
)
