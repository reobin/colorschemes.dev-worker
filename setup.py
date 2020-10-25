from setuptools import setup, find_packages

setup(
    name = "vimcolorschemes/worker",
    version = "1.0.0",
    description = "I fetch vim color scheme repositories and store them. That's about it.",
    url = "https://github.com/vimcolorschemes/worker",
    author = "Robin Gagnon",
    author_email = "me@reobin.dev",
    python_requires = ">=3.5",
    # packages = find_packages(),
    install_requires = [
        "requests", # HTTP requests
        "pymongo", # MongoDB client
        "pytz", # timezones
    ],
    extras_require = {
        "dev": [
            "pip-tools",
            "black",
        ],
    },
    project_urls = {
        "Source": "https://github.com/vimcolorschemes/worker",
        "Bug Reports": "https://github.com/vimcolorschemes/worker/issues",
        "Website": "https://vimcolorschemes.com",
        "Organization": "https://github.com/vimcolorschemes",
    },
)
