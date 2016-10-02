# penvwrapper — an anaemic virtualenvwrapper for Perl

`penvwrapper.sh` provides some utility functions for working
with [`penv.pl`](https://github.com/jtopjian/penv), a simple,
[`local::lib`](https://github.com/Perl-Toolchain-Gang/local-lib)-based
version of [`virtualenv`](https://virtualenv.pypa.io/)
for [Perl](https://www.perl.org). It is similar to — but less
professional than —
[`virtualenvwrapper.sh`](https://virtualenvwrapper.readthedocs.io/).

## Usage

```bash
git clone https://github.com/sambrightman/penvwrapper.git
source penvwrapper/penvwrapper.sh
```

You should either have `penv.pl` in your path, or else `export
PENVWRAPPER_PENV="/path/to/penv.pl"`. `PWORKON_HOME` replaces
`WORKON_HOME` as the directory to keep virtual environments in; export
it before sourcing `penvwrapper.sh` if you don't like the default
(`~/.pvirtualenvs`).
