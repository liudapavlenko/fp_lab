; SLIME 2.24
CL-USER> (defun imper-shell-sort (lst k)
  (let ((list-one (copy-list lst)))
    (dolist (kt k)
      (loop for i from kt below (length list-one) do
            (let ((num (elt list-one i))
                  (j i))
              (loop while (and (>= j kt)
                               (< num (elt list-one (- j kt)))) do
                    (setf (elt list-one j) (elt list-one (- j kt)))
                    (setf j (- j kt)))
              (setf (elt list-one j) num))))
    list-one))
IMPER-SHELL-SORT
CL-USER> (imper-shell-sort '(9 8 3 7 5 6 4 2 1) '(4 2 1))
(1 2 3 4 5 6 7 8 9)
CL-USER> 
