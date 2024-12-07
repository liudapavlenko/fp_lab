; SLIME 2.24
CL-USER> (defun shell-alg-loop3 (lst k j)
  (when (and (>= j k)
             (< (nth j lst) (nth (- j k) lst)))
    (rotatef (nth j lst) (nth (- j k) lst))
    (shell-alg-loop3 lst k (- j k))))
SHELL-ALG-LOOP3
CL-USER> (defun shell-alg-loop2 (lst k i)
  (when (< i (length lst))
    (shell-alg-loop3 lst k i)
    (shell-alg-loop2 lst k (1+ i))))
SHELL-ALG-LOOP2
CL-USER> (defun functional-shell-alg (lst k)
  (if k
      (progn
        (shell-alg-loop2 lst (car k) (car k))
        (functional-shell-alg  lst (cdr k)))
      lst))
FUNCTIONAL-SHELL-ALG
CL-USER> (functional-shell-alg '(9 8 3 7 5 6 4 2 1) '(4 2 1))
(1 2 3 4 5 6 7 8 9)
CL-USER> 
