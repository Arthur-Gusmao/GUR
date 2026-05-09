(define-module (GUR packages discord)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages base)
  #:use-module (guix download)
  #:use-module ((nonguix licenses) #:prefix nonfree:)
  #:use-module (guix packages)
  #:use-module (guix gexp))

(define-public discord
  (package
   (name "discord")
   (version "1.0.137")
   (source
    (origin
     (method url-fetch)
     (uri
      (string-append
       "https://stable.dl2.discordapp.net/apps/linux/" version
       "/discord-" version ".tar.gz"))
     (sha256
      (base32 "0pjm1lg46car0alpkxah9xxrqsfna91bwn6qipfd5874392pnawv"))))
   (supported-systems '("x86_64-linux"))
   (build-system chromium-binary-build-system)
   (inputs (list patchelf glibc))
   (arguments
    (list #:validate-runpath? #f
          #:wrapper-plan
          #~'("share/discord/updater_bootstrap")
          #:phases
          #~(modify-phases %standard-phases
                           (delete 'binary-unpack)
                           (add-after 'unpack 'setup-cwd
                                      (lambda _
                                        (mkdir-p "share/discord")
                                        (for-each
                                         (lambda (f)
                                           (rename-file f (string-append "share/discord/" (basename f))))
                                         (find-files "." "." #:directories? #f #:fail-on-error? #t))
                                        (substitute* "share/discord/discord.desktop"
                                                     (("/usr/share/discord/Discord")
                                                      (string-append #$output "/bin/discord")))))
                           (add-after 'install 'wrap-discord
                                      (lambda* (#:key inputs #:allow-other-keys)
                                        (let ((bin-dir (string-append #$output "/bin"))
                                              (real-bin (string-append #$output "/share/discord/discord")))
                                          (mkdir-p bin-dir)
                                          (call-with-output-file (string-append bin-dir "/discord")
                                            (lambda (port)
                                              (format port "#!/bin/sh
APP_DIR=\"$HOME/.config/discord/app-~a\"
PATCHELF=\"~a/bin/patchelf\"
INTERP=\"~a/lib/ld-linux-x86-64.so.2\"

if [ -d \"$APP_DIR\" ]; then
  for bin in \"$APP_DIR/Discord\" \"$APP_DIR/chrome_crashpad_handler\" \"$APP_DIR/chrome_sandbox\"; do
    if [ -f \"$bin\" ] && [ -x \"$bin\" ]; then
      if ! \"$PATCHELF\" --print-interpreter \"$bin\" 2>/dev/null | grep -q gnu/store; then
        \"$PATCHELF\" --set-interpreter \"$INTERP\" \"$bin\" 2>/dev/null || true
      fi
    fi
  done
fi

exec ~a \"$@\"
"
                                                      #$version
                                                      (assoc-ref inputs "patchelf")
                                                      (assoc-ref inputs "glibc")
                                                      real-bin)))
                                          (chmod (string-append bin-dir "/discord") #o755)))))))
   (home-page "https://discord.com/")
   (synopsis "Voice and text chat for gamers")
   (description "Discord is an all-in-one voice and text chat application for
gamers that works on desktop and phone.  It features voice chat, text chat,
and rich media support for gaming communities.")
   (license (nonfree:nonfree "https://discord.com/terms"))))
