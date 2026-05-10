(define-module (GUR packages libinput)
  #:use-module ((gnu packages freedesktop)
                #:select (libinput)
                #:prefix upstream:)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils))

(define-public libinput-custom
  (package
    (inherit upstream:libinput)
    (name "libinput-custom")
    (arguments
     (substitute-keyword-arguments
         (package-arguments upstream:libinput)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install 'add-quirks
              (lambda* (#:key outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (dir (string-append out "/etc/libinput"))
                       (file (string-append dir "/libinput-overrides.quirks")))
                  (mkdir-p dir)
                  (call-with-output-file file
                    (lambda (port)
                      (display "[debounce]\nMatchName=*\nModelBouncingKeys=1\n"
                               port)))
                  #t)))))))))
