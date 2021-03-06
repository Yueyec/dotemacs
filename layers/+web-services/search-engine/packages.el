;;; packages.el --- search-engine Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq search-engine-packages
  '(
    engine-mode
    ))

(defun search-engine/init-engine-mode ()
  (use-package engine-mode
    :commands (defengine spacemacs/search-engine-select)
    :defines search-engine-alist
    :init
    (spacemacs/set-leader-keys
      "a/" 'spacemacs/search-engine-select)
    (setq search-engine-alist
          '((amazon
             :name "Amazon"
             :url "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%%3Daps&field-keywords=%s")
            (bing
             :name "Bing"
             :url "http://www.bing.com/search?q=%s")
            (duck-duck-go
             :name "Duck Duck Go"
             :url "https://duckduckgo.com/?q=%s")
            (google
             :name "Google"
             :url "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s")
            (google-images
             :name "Google Images"
             :url "http://www.google.com/images?hl=en&source=hp&biw=1440&bih=795&gbv=2&aq=f&aqi=&aql=&oq=&q=%s")
            (github
             :name "Github"
             :url "https://github.com/search?ref=simplesearch&q=%s")
            (google-maps
             :name "Google Maps"
             :url "http://maps.google.com/maps?q=%s")
            (twitter
             :name "Twitter"
             :url "https://twitter.com/search?q=%s")
            (project-gutenberg
             :name "Project Gutenberg"
             :url "http://www.gutenberg.org/ebooks/search.html/?format=html&default_prefix=all&sort_order=&query=%s")
            (youtube
             :name "YouTube"
             :url "http://www.youtube.com/results?aq=f&oq=&search_query=%s")
            (stack-overflow
             :name "Stack Overflow"
             :url "https://stackoverflow.com/search?q=%s"
             )
            (spacemacs-issues
             :name "Spacemacs Issues"
             :url "https://github.com/syl20bnr/spacemacs/issues?utf8=%%E2%%9C%%93&q=is%%3Aissue+is%%3Aopen+%s")
            (spacemacs-pullrequests
             :name "Spacemacs Pull Requests"
             :url "https://github.com/syl20bnr/spacemacs/pulls?utf8=%%E2%%9C%%93&q=is%%3Aissue+is%%3Aopen+%s")
            (wikipedia
             :name "Wikipedia"
             :url "http://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s")
            (wolfram-alpha
             :name "Wolfram Alpha"
             :url "http://www.wolframalpha.com/input/?i=%s")))
    :config
    (engine-mode t)
    (mapcar (lambda (engine)
              (let* ((cur-engine (car engine))
                     (engine-url (plist-get (cdr engine) :url)))
                (eval `(defengine ,cur-engine ,engine-url))))
            search-engine-alist)
    (defun spacemacs//search-engine-source (engines)
      "return a source for helm selection"
      `((name . "Search Engines")
        (candidates . ,(mapcar (lambda (engine)
                                 (cons (plist-get (cdr engine) :name)
                                       (intern (format "engine/search-%S"
                                                       (car engine)))))
                               engines))
        (action . (lambda (candidate) (call-interactively candidate)))))

    (defun spacemacs/helm-search-engine-select ()
      "Set search engine to use with helm."
      (interactive)
      (helm :sources (list (spacemacs//search-engine-source
                            search-engine-alist))))

    (defun spacemacs/ivy-search-engine-select ()
      "Set search engine to use with ivy."
      "return a source for ivy selection"
      (interactive)
      (ivy-read "Search Engines: "
                (mapcar (lambda (engine)
                          (cons (plist-get (cdr engine) :name)
                                (intern (format "engine/search-%S"
                                                (car engine)))))
                        search-engine-alist)
                :action (lambda (candidate) (call-interactively (cdr candidate)))))

    (defun spacemacs/search-engine-select ()
      "Set search engine to use."
      (interactive)
      (if (configuration-layer/layer-usedp 'ivy)
          (call-interactively 'spacemacs/ivy-search-engine-select)
        (call-interactively 'spacemacs/helm-search-engine-select))))
  )
