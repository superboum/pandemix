Pandémix
========

A distributed web radio project currently at a design stage.
Should have features similar to [noidd](https://noidd.com/#/home) or [plugdj](https://plug.dj/) but without any central server.

[![Pandémix interface](https://cloud.deuxfleurs.fr/f/fc9b5cd5a660472286b0/?dl=1)](https://cloud.deuxfleurs.fr/f/fc9b5cd5a660472286b0/?dl=1)

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
