Pandémix
========

A distributed web radio project currently at a design stage.

## Development

### Fedora 28

```
sudo dnf copr enable superboum/chez-scheme 
sudo dnf install gstreamer1 gtk3 chez-scheme git
git clone https://github.com/superboum/pandemix.git
scheme -q app.scm
```

You can edit the interface with glade:

```
sudo dnf install glade3
glade interface.glade
```

Check you have at least Glade 3.22.1 otherwise you will no be able to edit your application.

### Other

Currently, this project is only tested on Fedora 28
