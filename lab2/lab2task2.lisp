; SLIME 2.24
CL-USER> (defun repeat-list (elem count num-max) 
  (cond 
    ((null elem) nil) 
    ((>= count num-max) (list elem)) 
    ((<= count 0) nil) 
    (t (cons elem (repeat-list elem (1- count) num-max)))))
REPEAT-LIST
CL-USER> (defun new-delete-duplicates (lst num-max &optional (num nil) (count 1))
  (cond 
    ((null lst) (repeat-list num count num-max))  
    ((eq num (car lst))  
     (new-delete-duplicates (cdr lst) num-max num (1+ count)))  
    (t (append (repeat-list num count num-max) 
               (new-delete-duplicates (cdr lst) num-max (car lst) 1)))))
NEW-DELETE-DUPLICATES
CL-USER> (new-delete-duplicates '(1 1 2 3 3 3 2 2 a a a b) 3)
(1 1 2 3 2 2 A B)
CL-USER> 
