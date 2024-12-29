<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент(-ка)</b>: Павленко Людмила Петрівна група КВ-12</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної
роботи 3 з такими змінами:
використати функції вищого порядку для роботи з послідовностями (де це
доречно);
додати до інтерфейсу функції (та використання в реалізації) два ключових
параметра: key та test , що працюють аналогічно до того, як працюють
параметри з такими назвами в функціях, що працюють з послідовностями.
При цьому key має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за
варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за
можливості, має бути мінімізоване.
## Варіант першої частини 7
Алгоритм сортування Шелла за незменшенням.
## Лістинг реалізації першої частини завдання
```lisp
(defun shell-alg-loop3 (lst keys k j &key (test #'<))
  (if (and (>= j k)
           (funcall test (nth j keys) (nth (- j k) keys)))
      (progn
        (rotatef (nth j lst) (nth (- j k) lst))
        (rotatef (nth j keys) (nth (- j k) keys))
        (shell-alg-loop3 lst keys k (- j k) :test test))
      lst))

(defun shell-alg-loop2 (lst keys k i len &key (test #'<))
  (if (< i len)
      (progn
        (shell-alg-loop3 lst keys k i :test test)
        (shell-alg-loop2 lst keys k (1+ i) len :test test))
      lst))

(defun functional-shell-alg-with-modf (lst &key (k '(4 2 1)) (key #'identity) (test #'<))
  (let ((lst-copy (copy-list lst))
        (keys (mapcar key lst))) 
    (if (and k (listp k))
        (progn
          (let ((len (length lst-copy)))
            (shell-alg-loop2 lst-copy keys (car k) (car k) len :test test))
          (functional-shell-alg-with-modf lst-copy :k (cdr k) :key key :test test))
        lst-copy)))
```
### Тестові набори та утиліти першої частини
```lisp
 (defun check-functional-shell-alg-with-modf (name lst expected &key (k '(4 2 1)) (key #'identity) (test #'<))
 (format t "~:[FAILED~;passed~]... ~a~%"
 (equal (functional-shell-alg-with-modf lst :k k :key key :test test) expected)
 name))

(defun test-functional-shell-alg-with-modf ()
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
```
### Тестування першої частини
```lisp
(test-functional-shell-alg-with-modf)
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
```
## Варіант другої частини 3
## Лістинг реалізації другої частини завдання
```lisp
;;; Лістинг реалізації
```
### Тестові набори та утиліти другої частини
```lisp
;;; Лістинг реалізації утилітних тестових функцій та тестових наборів
```
### Тестування другої частини
```lisp
;;; Виклик і результат виконання тестів
```
