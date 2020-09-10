import re

import request
import printer
import utils

VIM_NAMES_COLLECTION_THRESHOLD = 15
VIM_FILES_COLLECTION_THRESHOLD = 50
POTENTIAL_VIM_COLOR_SCHEME_PATH_REGEX = r"^.*\.(vim|erb)$"

def vim_color_scheme_reducer():
    return []

def get_vim_files_content(owner_name, name, files):
    vim_files = list(
        filter(
            lambda file: re.match(POTENTIAL_VIM_COLOR_SCHEME_PATH_REGEX, file["path"]),
            files,
        )
    )

    if len(vim_files) > VIM_FILES_COLLECTION_THRESHOLD:
        return []

    return list(
        map(
            lambda file: request.get(
                utils.build_raw_blog_github_url(owner_name, name, file["path"]),
                is_json=False,
            ).text,
            vim_files,
        ),
    )


def get_vim_color_scheme_backgrounds(vim_file_content):
    return False, True


def get_repository_vim_color_scheme_names(vim_files_content):
    vim_color_scheme_names = []
    for vim_file_content in vim_files_content:
        vim_color_scheme_name = get_vim_color_scheme_name(vim_file_content)
        if (
            vim_color_scheme_name is not None
            and vim_color_scheme_name != ""
            and vim_color_scheme_name not in vim_color_scheme_names
        ):
            vim_color_scheme_names.append(vim_color_scheme_name)
            if len(vim_color_scheme_names) > VIM_NAMES_COLLECTION_THRESHOLD:
                break

    if len(vim_color_scheme_names) <= VIM_NAMES_COLLECTION_THRESHOLD:
        return vim_color_scheme_names

    printer.info(
        "Repository contains too many vim color schemes; probably a collection"
    )
    return []


def get_vim_color_scheme_name(file_content):
    match = re.search(
        r"let (g:)?colors?_name ?= ?('|\")([a-zA-Z-_0-9]+)('|\")", file_content
    )
    if match is not None:
        name = match.group(3)
        printer.info(f"vim color scheme name is {name}")
        return name

    return None
