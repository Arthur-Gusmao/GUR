# Guix User Repository

Personal [GNU Guix](https://guix.gnu.org) channel with custom packages not yet available in the official Guix repository.

## Usage

Add this channel to `~/.config/guix/channels.scm`:

```scheme
(append
  (list
    (channel
      (name 'guix-user-repository)
      (url "https://github.com/Arthur-Gusmao/GUR")
      (branch "main")))
  %default-channels)
```

Then run:

```bash
guix pull
```

## Packages

| Package | Version | Description |
|---|---|---|
| `gruvbox-gtk-theme` | 0.0.0 | GTK 3/4 theme based on the Gruvbox Material colour palette |
| `gruvbox-icons` | 0.0.0 | Icon theme companion for Gruvbox GTK Theme |

## License

GPL-3.0
