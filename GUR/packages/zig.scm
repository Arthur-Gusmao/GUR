(define-module (GUR packages zig)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (gnu packages compression))

(define-public zig-0.15
  (package
    (name "zig")
    (version "0.15.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://ziglang.org/download/" version
             "/zig-x86_64-linux-" version ".tar.xz"))
       (sha256
        (base32
         "01gyz8xjjj0qs0rxp0q34psrw67lqqh4apnd3sjlr8gfxnk5s766"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (bin (string-append out "/bin"))
                     (lib (string-append out "/lib")))
                (mkdir-p bin)
                (mkdir-p lib)
                (copy-file "zig" (string-append bin "/zig"))
                (chmod (string-append bin "/zig") #o755)
                (copy-recursively "lib" lib)
                (copy-recursively "doc" (string-append out "/share/doc/zig"))))))))
    (native-inputs (list xz))
    (synopsis "The zig programming language in the most recent version.")
    (description
     "Zig is a general-purpose programming language and toolset for maintaining robust, optimal, and reusable software.")
    (home-page "https://ziglang.org")
    (license license:expat)))
zig-0.15
