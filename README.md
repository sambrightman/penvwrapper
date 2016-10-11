# penvwrapper — an anaemic virtualenvwrapper for Perl

[![License](https://img.shields.io/badge/license-MPL%202.0-blue.svg)](LICENSE)
[![Travis Build Status](https://travis-ci.org/sambrightman/penvwrapper.svg?branch=master)](https://travis-ci.org/sambrightman/penvwrapper)

`penvwrapper.sh` provides some utility functions for working with [`penv.pl`](https://github.com/jtopjian/penv), a simple,
[`local::lib`](https://github.com/Perl-Toolchain-Gang/local-lib)-based version of [`virtualenv`](https://virtualenv.pypa.io/)
for [Perl](https://www.perl.org). It is similar to — but less professional than — [`virtualenvwrapper.sh`](https://virtualenvwrapper.readthedocs.io/).

## Installation

* You should have `local::lib` installed.

* You should either have [`penv.pl`](https://github.com/jtopjian/penv)
  in your path or `export PENVWRAPPER_PENV="/path/to/penv.pl"`.

```bash
git clone https://github.com/sambrightman/penvwrapper.git
source penvwrapper/penvwrapper.sh
```

## Notes

* `PWORKON_HOME` replaces `WORKON_HOME` as the directory to keep
  virtual environments in; export it before sourcing `penvwrapper.sh` if
  you don't like the default (`~/.pvirtualenvs`).

* `penv.pl` uses `$VIRTUAL_ENV` and `deactivate`, the same as
  `virtualenv`. Combining Perl and Python virtual environments may
  lead to strange behaviour.

## Commands

These should mostly work the same as their `virtualenvwrapper.sh` equivalents.

* `pmkvirtualenv`: make and work on a new virtual environment.
* `pworkon`: work on an existing virtual environment.
* `plsvirtualenv`: list existing virtual environments.
* `pcdvirtualenv`: change to the directory container the current or named virtual environment.
* `prmvirtualenv`: remove an existing virtual environment.
* `pcdperllib`: change to the directory of the libraries/a named library.
* `plsperllib`: list the directory libraries.

## Hooks and Extensions

Hooks and extensions are [not supported](https://en.wikipedia.org/wiki/Anemia).
