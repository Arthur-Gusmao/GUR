(define-module (GUR packages themes)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib))

(define-public gruvbox-gtk-theme
  (let ((commit "578cd220b5ff6e86b078a6111d26bb20ec8c733f")
        (revision "0"))
    (package
      (name "gruvbox-gtk-theme")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme")
              (commit commit)))
        (sha256
         (base32
          "1fmpma44hp9a7b2nklvm900l62ni8smmjc9g4a9y1x53ys7hyyj5"))
        (file-name (git-file-name name version))))
      (build-system gnu-build-system)
      (native-inputs (list sassc))
      (arguments
       (list
        #:tests? #f
        #:phases
        #~(modify-phases %standard-phases
            (delete 'configure)
            (replace 'build
              (lambda _
                (chdir "themes")
                (invoke "bash" "install.sh"
                        "-d" (string-append #$output "/share/themes")
                        "-c" "dark")))
            (delete 'install))))
      (home-page "https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme")
      (synopsis "GTK theme based on the Gruvbox Material colour palette")
      (description
       "Gruvbox GTK Theme is a GTK 3/4 theme inspired by the Gruvbox Material
colour scheme for Neovim.  It supports GNOME, Cinnamon, XFCE, Mate and tiling
window managers.")
      (license license:gpl3))))
