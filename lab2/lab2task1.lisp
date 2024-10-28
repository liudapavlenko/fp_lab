; SLIME 2.24
CL-USER> (defun spread-values1 (lst &optional (num1 nil))
  (if (null lst)
      nil
      (if (null (car lst))
          (cons num1 (spread-values1 (cdr lst) num1))  
          (cons (car lst) (spread-values1 (cdr lst) (car lst))))))
SPREAD-VALUES1
CL-USER> (spread-values1 '(nil 1 2 nil 3 nil nil 4 5))
(NIL 1 2 2 3 3 3 4 5)
CL-USER> 
