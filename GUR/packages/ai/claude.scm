(define-module (GUR packages ai claude)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages elf))

(define claude-version "2.1.138")
(define claude-sha256
  (base32 "1hzqym4r1m1q1j6p3qd96l62bvb1cgzck1rnqd06xw9cq7xnzif3"))

(define-public claude-code
  (package
    (name "claude-code")
    (version claude-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://downloads.claude.ai/claude-code-releases/"
             version "/linux-x64/claude"))
       (sha256 claude-sha256)))
    (build-system binary-build-system)
    (arguments
     `(#:validate-runpath? #f
       #:strip-binaries? #f
       #:install-plan '(("claude" "bin/claude"))
       #:phases
       (modify-phases %standard-phases
         (replace 'unpack
           (lambda* (#:key source #:allow-other-keys)
             (copy-file source "claude")
             #t))
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (chmod (string-append (assoc-ref outputs "out") "/bin/claude") #o755)
             #t))
         (add-after 'make-executable 'patch-elf
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out   (assoc-ref outputs "out"))
                    (bin   (string-append out "/bin/claude"))
                    (glibc (assoc-ref inputs "glibc"))
                    (ld    (string-append glibc "/lib/ld-linux-x86-64.so.2"))
                    (rpath (string-append glibc "/lib")))
               (invoke "patchelf" "--set-interpreter" ld bin)
               (invoke "patchelf" "--set-rpath" rpath bin)
               #t)))
         (add-after 'patch-elf 'wrap
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out  (assoc-ref outputs "out"))
                    (bin  (string-append out "/bin/claude"))
                    (real (string-append out "/libexec/claude")))
               (mkdir-p (string-append out "/libexec"))
               (rename-file bin real)
               (call-with-output-file bin
                 (lambda (port)
                   (display
                    (string-append "#!/bin/sh\n"
                                   "export DISABLE_AUTOUPDATER=1\n"
                                   "export DISABLE_UPDATES=1\n"
                                   "exec " real " \"$@\"\n")
                    port)))
               (chmod bin #o755)
               #t))))))
    (native-inputs
     `(("patchelf" ,patchelf)))
    (inputs
     `(("glibc" ,glibc)
       ("gcc:lib" ,gcc "lib")))
    (supported-systems '("x86_64-linux"))
    (synopsis "Claude Code — assistente de IA para terminal (Anthropic)")
    (description "Binário nativo do Claude Code. Software proprietário — uso sujeito aos termos da Anthropic.")
    (home-page "https://claude.ai/code")
    (license (license:non-copyleft "https://www.anthropic.com/legal/aup"))))
