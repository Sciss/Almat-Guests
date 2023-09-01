(require 'comint)

(defvar wreck-comint-program-command  "~/Work/algosthatmatter/almat_luc/ocawreck/_build/default/toplevel.exe"
  "Path to the program used by `run-wreck'")

(defvar wreck-cli-arguments '()
  "Commandline arguments to pass to `wreck-cli'")

(defvar wreck-repl-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    ;; example definition
    (define-key map "\t" 'completion-at-point)
    (define-key map (kbd "C-c C-e") 'wreck-send-region-and-go)
    (define-key map (kbd "C-c C-s") 'wreck-stop-playback)
    map)
  "Basic mode map for `run-wreck'")


(defun run-wreck ()
  "Run an inferior instance of `wreck-cli' inside Emacs."
  (interactive)
  (let* ((wreck-program wreck-comint-program-command)
         (buffer (comint-check-proc "Wreck")))
    ;; pop to the "*Wreck*" buffer if the process is dead, the
    ;; buffer is missing or it's got the wrong mode.
    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'wreck-repl-mode))
             (comint-check-proc (current-buffer)))
         (get-buffer-create (or buffer "*Wreck*"))
       (current-buffer)))
    ;; create the comint process if there is no buffer.
    (unless buffer
      (apply 'make-comint-in-buffer "Wreck" buffer
             wreck-program wreck-cli-arguments)
      (setq wreck-comint-buffer "*Wreck*")
      (wreck-repl-mode)
      (switch-to-wreck wreck-comint-buffer))))


(defun wreck--initialize ()
  "Helper function to initialize Wreck"
  (setq comint-process-echoes t)
					;  (setq comint-use-prompt-regexp t)
  )

(define-derived-mode wreck-repl-mode comint-mode "Wreck"
  "Major mode for `run-wreck'.

\\<wreck-mode-map>"
  nil "Wreck"
  ;; this sets up the prompt so it matches things like: [foo@bar]
;  (setq comint-prompt-regexp wreck-prompt-regexp)
  ;; this makes it read only; a contentious subject as some prefer the
  ;; buffer to be overwritable.
  (setq comint-prompt-read-only t)
  ;; this makes it so commands like M-{ and M-} work.
  (set (make-local-variable 'paragraph-separate) "\\'")
  (set (make-local-variable 'font-lock-defaults) '(wreck-font-lock-keywords t))
  ;(set (make-local-variable 'paragraph-start) wreck-prompt-regexp)
  )


(set (make-local-variable 'font-lock-defaults) '(wreck-font-lock-keywords t))


(defconst wreck-keywords
  '("fn" "proc" "play" "if" "then"
    "else" "let" "in"))

(defvar wreck-font-lock-keywords
  (list
   ;; highlight all the reserved commands.
   `(,(concat "\\_<" (regexp-opt wreck-keywords) "\\_>") . font-lock-keyword-face))
  "Additional expressions to highlight in `wreck-mode'.")

;; this has to be done in a hook. grumble grumble.
(add-hook 'wreck-repl-mode-hook 'wreck--initialize)


(defun wreck-send-string (text)
  "Send `TEXT' to the inferior Wreck process."
  (interactive "r")
;  (run-wreck wreck-comint-program-command t)
  (comint-send-string (get-buffer-process wreck-comint-buffer)
		      (concat text "\n")))

(defun wreck-send-region (start end)
  "Send the current region to the inferior Wreck process."
  (interactive "r")
  (let ((text (buffer-substring-no-properties start end)))
    (wreck-send-string text)))

;;;###autoload
(defun wreck-send-region-and-go (start end)
  "Send the current region to the inferior Wreck process."
  (interactive "r")
  (wreck-send-region start end)
  (switch-to-wreck wreck-comint-buffer))


(defun switch-to-wreck (eob-p)
  "Switch to the Wreck process buffer.
With argument `EOB-P', position cursor at end of buffer."
  (interactive "P")
  (if (and wreck-comint-buffer (get-buffer wreck-comint-buffer))
      (pop-to-buffer wreck-comint-buffer)
    (error "No current process buffer.  See variable `wreck-comint-buffer'")))



(setq wreck-font-lock-keywords
      (let* (
            ;; define several category of keywords
            (x-keywords '("if" "else" "then" "in" "let"))
            (x-builtins '("proc" "fn" "play"))

	    ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words))
            (x-builtins-regexp (regexp-opt x-builtins 'words)))

        `(
          (,x-keywords-regexp . font-lock-keyword-face)
          (,x-builtins-regexp . font-lock-builtin-face)

          )))
	
(defvar wreck-mode-hook nil)

(defun wreck-stop-playback ()
  "Stop wreck playback."
  (interactive)
  (wreck-send-string (string ?\e)))
  ;; (signal-process (process-id (get-process "Wreck")) 16))

(defvar wreck-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "C-c C-e") 'wreck-send-region-and-go)
    (define-key map (kbd "C-c C-s") 'wreck-stop-playback)
    map)
  "Keymap for wreck major mode")


(defvar wreck-mode-syntax-table nil "Syntax table for `wreck-mode'.")

(setq wreck-mode-syntax-table
      (let ( (synTable (make-syntax-table)))
        ;; comment “// ...”
        (modify-syntax-entry ?\/ ". 12b" synTable)
        (modify-syntax-entry ?\n "> b" synTable)
        synTable))

;; (setq wreck-mode-syntax-table
;;       (let ((synTable (make-syntax-table)))
;;         ;; Wolfram Language style comment “(* … *)”
;;         (modify-syntax-entry ?\( ". 1" synTable)
;;         (modify-syntax-entry ?\) ". 4" synTable)
;;         (modify-syntax-entry ?* ". 23" synTable)
;;         synTable))

(define-derived-mode wreck-mode nil "wreck"
  "major mode for editing wreck language code."
  (setq font-lock-defaults '(wreck-font-lock-keywords))
  (setq-local comment-start "//")
  (setq-local comment-end "")
  (use-local-map wreck-mode-map))

(show-paren-mode 1)

(add-to-list 'auto-mode-alist '("\\.wr\\'" . wreck-mode))



