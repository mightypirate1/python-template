## How to create a new repository with the template

First install [cookiecutter](https://github.com/cookiecutter/cookiecutter)
```sh
$ make install
$ source .venv/bin/activate
```

To create a new project `my-test` and push it to github based on this template,
run the following from the directory where the project should reside:
```
$ make create-repo
repository_name [repository-name]: my-test
module_name [my_test]:
$ cd my-test
$ git init --initial-branch=main
$ git add .
$ git commit -m "Add files generated from template"
$ git remote add origin git@github.com:mightypirate1/my-test.git
$ git branch cookiecutter-template
$ git push -u origin main cookiecutter-template
```

It is recommended, although probably not necessary, that you now exit your current virtual environment by running
```sh
$ deactivate
```
Go into the source of your new repository and run
```sh
$ make develop
```
This creates a virtual environment in your repository and installs your repository as a module, solving dependency issues automatically.

## Guidance while coding

Ensure that you always have the virtual environment activated (even in your editor if it has such functionality) by running
```sh
$ source .venv/bin/activate
```
while standing in the source of your repository. Otherwise, you will have problems with importing from the repository and running `make` commands.

When you are done editing, do the following in this order:
1. Run `make reformat` until the command does not suggest any improvements (If you have syntax errors, they must be fixed first).
2. Run `make lint` and fix all errors it is complaining about. A small subset of all errors can be fixed automatically using `make lint-fix` (see `Tooling/Usage` for details).
3. If you have tests, run `make test` and fix failing tests if there are any.


## Tooling

The template provides numerous tools to simplify the development process:

- `venv` for handling the environment
- `setuptools` for installation and dependency handling
- `black` for formatting
- `ruff` for linting
- `mypy` for typechecking
- `pytest` for testing
- `coverage` for analyzing test coverage
- `cookiecutter` for bringing in changes to the template

While you can use these tools manually, the intended way of running them is via `make` commands.

### Usage
#### `venv` and `setuptools`

There are a two main ways of using these:

For development:
```sh
$ make develop  # runs `make venv` then installs the code as a package (editable mode) inside of it
$ source .venv/bin/activate  # activates the virtual environment
```

For installation:
```sh
$ make venv  # creates an empty virtual environment
$ source .venv/bin/activate  # activates the virtual environment
$ make install  # installs the code as a package in the virtual environment
```

#### Linting, typechecking and formatting

Reformatting (may take a couple of runs):
```sh
$ make reformat  # applies standard formatting using ruff (I, W) and black
```

Linting and typechecking:
```sh
$ make lint  # runs ruff and, if that is successful, mypy
```
Some errors that runs finds can be fixed by the linter:
```sh
$ make lint-fix  # runs ruff with `--fix-only`
```
 A (possibly) non-exhaustive list of all errors that can be fixed via `make lint-fix` is:
* Unused imports
* Incorrect order of importing
* Upgrading of old typing syntax

#### Testing and coverage
```sh
$ make test  # runs pytest on the tests/ folder
```

```sh
$ make coverage  # analyzes the test coverage on a file-by-file level
```

#### Template updates
If the template was updated, you may want to bring those changes into your repository:
```sh
$ make template-update  # fetches changes from the template, and attempts to merge to your current branch
```
If there are conflicts, you need to resolve them.

If there are untracked files, the merge will not be attempted, so you need to solve that, and then merge the `cookiecutter-template` branch into your current branch.

> **NOTE:** If there are changes to the template such that the inputs are changed (such as the added `python_version`), you may need to update your `cookiecutter_input.json` before you can update the template. The easiest way of doing this is to create a new repository using the current `python-setuptools-template` and inspecting it's `cookiecutter_input.json`. Compare this file to the corresponding file in the repository you wish to update, and add any missing entries.

### Configuration
Most tools are configured in `pyproject.toml`.

The exception is the cookiecutter input, used to bring in changes to the template.
These are found in `cookiecutter_input.json`.

Dependencies of the repo / module is handled in `setup.py`. There are two sections in this file: one for dev requirements (used by `make develop`), and one for module requirements (used by `make install`).

Module configuration is done in `setup.cfg`, but you will not usually have to make changes here.
