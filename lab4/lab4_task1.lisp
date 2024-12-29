; SLIME 2.24
CL-USER> (defun shell-alg-loop3 (lst keys k j &key (test #'<))
  (if (and (>= j k)
           (funcall test (nth j keys) (nth (- j k) keys)))
      (progn
        (rotatef (nth j lst) (nth (- j k) lst))
        (rotatef (nth j keys) (nth (- j k) keys))
        (shell-alg-loop3 lst keys k (- j k) :test test))
      lst))
SHELL-ALG-LOOP3
CL-USER>  (defun shell-alg-loop2 (lst keys k i len &key (test #'<))
  (if (< i len)
      (progn
        (shell-alg-loop3 lst keys k i :test test)
        (shell-alg-loop2 lst keys k (1+ i) len :test test))
      lst))
SHELL-ALG-LOOP2
CL-USER> (defun functional-shell-alg-with-modf (lst &key (k '(4 2 1)) (key #'identity) (test #'<))
  (let ((lst-copy (copy-list lst))
        (keys (mapcar key lst))) 
    (if (and k (listp k))
        (progn
          (let ((len (length lst-copy)))
            (shell-alg-loop2 lst-copy keys (car k) (car k) len :test test))
          (functional-shell-alg-with-modf lst-copy :k (cdr k) :key key :test test))
        lst-copy)))
FUNCTIONAL-SHELL-ALG-WITH-MODF
CL-USER> (defun check-functional-shell-alg-with-modf (name lst expected &key (k '(4 2 1)) (key #'identity) (test #'<))
 (format t "~:[FAILED~;passed~]... ~a~%"
 (equal (functional-shell-alg-with-modf lst :k k :key key :test test) expected)
 name))
CHECK-FUNCTIONAL-SHELL-ALG-WITH-MODF
CL-USER> (defun test-functional-shell-alg-with-modf ()
  (check-functional-shell-alg-with-modf "test1" '(8 7 5 4 2 9) '(2 4 5 7 8 9))
  (check-functional-shell-alg-with-modf "test2" '(8 7 6 5 4 3 2 1) '(1 2 3 4 5 6 7 8))
  (check-functional-shell-alg-with-modf "test3" '(1 2 3 4 5 6 7 8) '(1 2 3 4 5 6 7 8))
  (check-functional-shell-alg-with-modf "test4" '(2 2 9 9 2 2 3 3 6 6) '(2 2 2 2 3 3 6 6 9 9))
  (check-functional-shell-alg-with-modf "test5" '(9 1 1 9 5 9) '(1 1 5 9 9 9))
  (check-functional-shell-alg-with-modf "test6" '(8 -9 2 7 -1 4 -2 1 -6) '(-1 1 2 -2 4 -6 7 8 -9) :key #'abs :test #'<)
  (check-functional-shell-alg-with-modf "test7" '(8 7 -7 6 -6 5 -5 4 -4 3 -3 2 1) '(1 2 -3 3 -4 4 -5 5 -6 6 -7 7 8) :key #'abs)
  (check-functional-shell-alg-with-modf "test8" '(1 -1 2 -2 3 4 5 6 -6 7 8) '(-6 -2 -1 1 2 3 4 5 6 7 8) :test #'<=)
  (check-functional-shell-alg-with-modf "test9" '(2 -2 9 -9 2 2 3 -3 6 -6) '(9 -9 6 -6 3 -3 2 -2 2 2) :key #'abs :test #'>)
  (check-functional-shell-alg-with-modf "test10" '(9 1 1 -9 5 9) '(9 -9 9 5 1 1) :key #'abs :test #'>=))
TEST-FUNCTIONAL-SHELL-ALG-WITH-MODF
CL-USER> (test-functional-shell-alg-with-modf)
passed... test1
passed... test2
passed... test3
passed... test4
passed... test5
passed... test6
passed... test7
passed... test8
passed... test9
passed... test10
NIL
CL-USER> 
