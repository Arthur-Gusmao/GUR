(define-module (GUR packages ai ollama)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages elf))

(define ollama-version "0.23.2")
(define ollama-sha256
  (base32 "075nj4ldlr70lymrkqys6wx9v709b1nxykfsvdrdaisgkfsk78qi"))

(define-public ollama
  (package
    (name "ollama")
    (version ollama-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/ollama/ollama/releases/download/v"
             version "/ollama-linux-amd64.tar.zst"))
       (sha256 ollama-sha256)))
    (build-system binary-build-system)
    (arguments
     `(#:validate-runpath? #f
       #:strip-binaries? #f
       #:install-plan '(("bin/ollama" "bin/ollama"))
       #:phases
       (modify-phases %standard-phases
         (replace 'unpack
           (lambda* (#:key source inputs #:allow-other-keys)
             (invoke "tar"
                     "--use-compress-program"
                     (string-append (assoc-ref inputs "zstd") "/bin/zstd")
                     "-xf" source)
             #t))
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (chmod (string-append (assoc-ref outputs "out") "/bin/ollama") #o755)
             #t))
         (add-after 'make-executable 'patch-elf
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out     (assoc-ref outputs "out"))
                    (bin     (string-append out "/bin/ollama"))
                    (glibc   (assoc-ref inputs "glibc"))
                    (gcc-lib (assoc-ref inputs "gcc:lib"))
                    (ld      (string-append glibc "/lib/ld-linux-x86-64.so.2"))
                    (rpath   (string-append glibc "/lib:" gcc-lib "/lib")))
               (invoke "patchelf" "--set-interpreter" ld bin)
               (invoke "patchelf" "--set-rpath" rpath bin)
               #t))))))
    (native-inputs
     `(("zstd" ,zstd)
       ("patchelf" ,patchelf)))
    (inputs
     `(("glibc" ,glibc)
       ("gcc:lib" ,gcc "lib")))
    (supported-systems '("x86_64-linux"))
    (synopsis "Run llm models localy")
    (description "Ollama permite rodar LLMs open source localmente via CLI e API REST.")
    (home-page "https://ollama.com")
    (license license:expat)))
