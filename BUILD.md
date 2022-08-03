# How to Setup for Build

## Ruby

In true `ruby` fashion we run on latest stable.  As of this writing that is `3.1` (but the official is
in `.ruby-version`)

You must either have that version installed from <https://ruby-lang.org> from source, or have `rbenv` setup with a
modern `ruby-build` to install it/

### Simple on macOS

```shell
brew install hunspell rbenv libxml2
rbenv install 3.1.0
```

#### BONUS: Making Tower Work with Overcommit / Yubikeys

Get your `PATH` from the console:

```shell
$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Set `PATH` for Tower: <https://www.git-tower.com/help/guides/integration/environment/mac>

### Possible on Linux

#### Modern Ruby for Debian / Ubuntu

The versions of `ruby` and `ruby-build` included with Debian / Ubuntu is woefully out of date... Setup `rbenv` and
modern `ruby-build` to install modern ruby

```shell
sudo apt install git rbenv build-essential libxml2-dev
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv init
rbenv install 3.1.0
```

## Enter the Checkout Directory and Bring in Prerequisites

```shell
git clone https://github.com/hack-different/apple-knowledge.git
cd apple-knowledge
gem install bundler
bundle install
overcommit --install
```

## Running the Jekyll Build

```shell
bundle exec jekyll serve
```

## Setting up Overcommit

```shell
bundle exec overcommit --install
```