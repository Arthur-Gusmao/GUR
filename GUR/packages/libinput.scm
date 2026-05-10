(define-module (GUR packages libinput)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils))

(define-public libinput
  (package
    (inherit libinput)

    (arguments
     (substitute-keyword-arguments (package-arguments libinput)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install 'add-quirks
              (lambda* (#:key outputs #:allow-other-keys)

                (let* ((out (assoc-ref outputs "out"))
                       (dir (string-append out "/etc/libinput"))
                       (file (string-append
                              dir
                              "/local-overrides.quirks")))

                  (mkdir-p dir)

                  (call-with-output-file file
                    (lambda (port)
                      (display
"[debounce]
MatchName=*
ModelBouncingKeys=1
"
                               port)))

                  #t)))))))))
