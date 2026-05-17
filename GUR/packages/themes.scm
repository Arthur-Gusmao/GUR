(define-module (GUR packages themes)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages web))

;; Para testar individualmente (rode a partir do diretório raiz do canal):
;;
;;   guix build -L . gruvbox-gtk-theme
;;   guix build -L . gruvbox-plus-icon-pack
;;   guix build -L . kanagawa-gtk-theme
;;   guix build -L . kanagawa-icon-theme
;;
;; Ou para buildar todos de uma vez:
;;
;;   guix build -L . gruvbox-gtk-theme gruvbox-plus-icon-pack kanagawa-gtk-theme kanagawa-icon-theme

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

(define-public gruvbox-plus-icon-pack
  (let ((commit "7026451029f28fd7ee314ba2e3a42fd32cea00be")
        (revision "0"))
    (package
     (name "gruvbox-plus-icon-pack")
     (version (git-version "6.4.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/SylEleuth/gruvbox-plus-icon-pack")
             (commit commit)))
       (sha256
        (base32
         "0fma1gm4548m4hsyn8215m6bk4w5scmbpbdrr78wpiid78c89fia"))
       (file-name (git-file-name name version))))
     (build-system copy-build-system)
     (arguments
      '(#:install-plan
        '(("Gruvbox-Plus-Dark" "share/icons/Gruvbox-Plus-Dark")
          ("Gruvbox-Plus-Light" "share/icons/Gruvbox-Plus-Light"))))
     (home-page "https://github.com/SylEleuth/gruvbox-plus-icon-pack")
     (synopsis "Gruvbox Plus icon pack for Linux desktops")
     (description
      "Gruvbox Plus is an icon pack for Linux based on the Gruvbox color
scheme, inspired by Suru++, Papirus and other icon themes.  It includes
dark and light variants.")
     (license license:gpl3))))

(define-public kanagawa-gtk-theme
  (let ((commit "9fad7fd81cd56daf318fee925ada6b7e549fb647")
        (revision "0"))
    (package
     (name "kanagawa-gtk-theme")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme")
             (commit commit)))
       (sha256
        (base32
         "1hal6hv7a3dypa5gr01xh60s2h4kb19bqhqmh4w21rk4skrmkgan")) ; substitua: guix hash -rx .
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
                                           "--tweaks" "dragon"
                                           "-c" "dark")))
                        (delete 'install))))
     (home-page "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme")
     (synopsis "GTK theme based on the Kanagawa colour palette")
     (description
      "Kanagawa GTK Theme is a GTK 3/4 theme inspired by the Kanagawa colour
scheme for Neovim, originally created by Rebelot.  It supports GNOME,
Cinnamon, XFCE, Mate and tiling window managers such as XmonadWM,
AwesomeWM and BSPWM.")
     (license license:gpl3))))

(define-public kanagawa-icon-theme
  (let ((commit "9fad7fd81cd56daf318fee925ada6b7e549fb647")
        (revision "0"))
    (package
     (name "kanagawa-icon-theme")
     (version (git-version "0.0.0" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme")
             (commit commit)))
       (sha256
        (base32
         "1hal6hv7a3dypa5gr01xh60s2h4kb19bqhqmh4w21rk4skrmkgan")) ; mesmo hash do kanagawa-gtk-theme
       (file-name (git-file-name name version))))
     (build-system copy-build-system)
     (arguments
      '(#:install-plan
        '(("icons/Kanagawa" "share/icons/Kanagawa"))))
     (home-page "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme")
     (synopsis "Icon theme based on the Kanagawa colour palette")
     (description
      "Kanagawa Icon Theme is an icon pack inspired by the Kanagawa colour
scheme for Neovim.  It is designed to complement the Kanagawa GTK theme
and is based on the Suru Plus icon theme by Gusbemacbe.")
     (license license:gpl3))))
