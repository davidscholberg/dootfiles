# Dootfiles 🎺

This project holds all of my non-sensitive dotfiles as well a simple script for installing them into my home directory. You probably wouldn't want to use this project as is (unless you are me), but you could use it as a starting point for making your own dotfiles repo.

All dotfiles managed by this repo are copied to their intended locations with file permissions set to `444` (read-only). I think that this is better than symlinking for the following reasons:

* Copying the files allows you to make local changes inside this repo without having them go "live" right away.
* Setting the copied files to read-only is a barrier for other programs attempting to make changes to a managed dotfile.

One drawback to this approach is that any file deleted from this repository that has already been deployed will need to be deleted manually from the deployment destination.

### Usage

To install the dotfiles here to your home directory, just clone this repo and give a lil doot:

```bash
git clone git@github.com:davidscholberg/dootfiles.git && \
cd dootfiles && \
./doot
```

If you need different configs for specific hosts, you can prepend the filename with the host's hostname followed by an underscore when you create the file. Then when you add the dotfile to the doot script, you just replace the host's hostname with `${HOSTNAME}`. See the doot script for an example.
