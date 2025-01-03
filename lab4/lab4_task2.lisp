; SLIME 2.24
CL-USER> (defun add-next-fn (&key (transform #'identity))
  (let ((previous nil))
    (lambda (current)
      (let ((transformed-current (funcall transform current)))
        (prog1
            (if previous
                (cons previous transformed-current) 
                nil)
          (setf previous transformed-current)))))) 

ADD-NEXT-FN
CL-USER>  (mapcar (add-next-fn) '(1 2 3))
(NIL (1 . 2) (2 . 3))
CL-USER> (mapcar (add-next-fn :transform #'1+) '(1 2 3))
(NIL (2 . 3) (3 . 4))
CL-USER> (mapcar (add-next-fn :transform #'1-) '(9 1 1 9 5 9))
(NIL (8 . 0) (0 . 0) (0 . 8) (8 . 4) (4 . 8))
CL-USER>  (defun check-add-next-fn (name lst expected &key (transform #'identity))
  (let ((res (mapcar (add-next-fn :transform transform) lst)))
    (format t "~:[FAILED~;PASSED~]... ~a~%" 
            (equal res expected)  
            name)))
CHECK-ADD-NEXT-FN
CL-USER> (defun test-add-next-fn ()
  (check-add-next-fn "test1" '(1 2 3) '(NIL (1 . 2) (2 . 3)))
  (check-add-next-fn "test2" '(1 2 3 4 5) '(NIL (1 . 2) (2 . 3) (3 . 4) (4 . 5)))
  (check-add-next-fn "test3" '(9 8 7 4 5 6 1 2 3) '(NIL (9 . 8) (8 . 7) (7 . 4) (4 . 5) (5 . 6) (6 . 1) (1 . 2) (2 . 3)))
  (check-add-next-fn "test4" '(1 2 3) '(NIL (2 . 3) (3 . 4)) :transform #'1+)
  (check-add-next-fn "test5" '(9 1 1 9 5 9) '(NIL (8 . 0) (0 . 0) (0 . 8) (8 . 4) (4 . 8)) :transform #'1-))
TEST-ADD-NEXT-FN
CL-USER> (test-add-next-fn)
PASSED... test1
PASSED... test2
PASSED... test3
PASSED... test4
PASSED... test5
NIL
CL-USER> 
