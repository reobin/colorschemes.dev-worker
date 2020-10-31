import os

from runner import Runner
from utils import printer

VIM_UTILS_PATH = "/usr/src/app/vim_utils"


class GenerateRunner(Runner):
    def run(self):
        set_up_color_syntax()

        repositories = self.database.get_repositories()

        for repository in repositories:
            print(repository)

        return {"previews_generated": 0}


def set_up_color_syntax():
    os.system("mkdir -p ~/.vim/pack/vim-polyglot/start/vim-polyglot/")

    os.system(
        "git clone https://github.com/sheerun/vim-polyglot ~/.vim/pack/vim-polyglot/start/vim-polyglot"
    )

    os.system(f"cat {VIM_UTILS_PATH}/set_termguicolors.vim >> ~/.vimrc")

    # TODO Maybe publish a vim plugin that we can install here instead of having it in the code
    os.system(f"cat {VIM_UTILS_PATH}/vcspg.vim >> ~/.vimrc")


def install_color_scheme(owner_name, name, color_scheme_name=None):
    if color_scheme_name is None:
        color_scheme_name = name

    os.system(f"mkdir -p ~/.vim/pack/{name}/start/{name}")

    os.system(
        f"git clone --depth 1 \
          https://github.com/{owner_name}/{name}.git \
          ~/.vim/pack/{name}/start/{name}"
    )


def get_colors(owner_name, name):
    file_name = f"{owner_name}_{name}.json"
    os.system(
        f'vim -c f":call WriteColorValues("{file_name}")" code_sample.vim -c ":q"'
    )
    os.system(f"cat {file_name}")
