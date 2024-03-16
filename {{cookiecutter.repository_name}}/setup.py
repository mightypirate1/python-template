from setuptools import find_packages, setup


setup(
    name="{{ cookiecutter.repository_name }}",
    install_requires=[],
    packages=find_packages(),
    extras_require={
        "dev": [
            "black",
            "build",
            "cookiecutter-project-upgrader",
            "coverage",
            "ipykernel",
            "ipython",
            "isort",
            "mypy",
            "pytest",
            "ruff",
        ]
    },
)
