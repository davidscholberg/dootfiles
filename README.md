# Dootfiles 🎺

This project is meant to manage and track all of my non-sensitive dotfiles and small utility scripts. You probably wouldn't want to use this project as is (unless you are me), but you could use it as a starting point for making your own dotfiles repo.

All dotfiles managed by this repo are copied to their intended locations with file permissions set to `444` (read-only). I think that this is better than symlinking for the following reasons:

* Copying the files allows you to make local changes inside this repo without having them go "live" right away.
* Setting the copied files to read-only is a barrier for other programs attempting to make changes to a managed dotfile.

### Usage

To install the dotfiles here to your home directory, just clone this repo and give a lil doot:

```bash
git clone git@github.com:davidscholberg/dootfiles.git && \
cd dootfiles && \
./doot
```
