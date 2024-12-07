<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 3</b><br/>
"Конструктивний і деструктивний підходи до роботи зі списками"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент(-ка)</b>: Павленко Людмила Петрівна КВ-12</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання

Реалізуйте алгоритм сортування чисел у списку двома способами: функціонально і
імперативно.
1. Функціональний варіант реалізації має базуватись на використанні рекурсії і
конструюванні нових списків щоразу, коли необхідно виконати зміну вхідного
списку. Не допускається використання: деструктивних операцій, циклів, функцій
вищого порядку або функцій для роботи зі списками/послідовностями, що
використовуються як функції вищого порядку. Також реалізована функція не має
бути функціоналом (тобто приймати на вхід функції в якості аргументів).

2. Імперативний варіант реалізації має базуватись на використанні циклів і
деструктивних функцій (псевдофункцій). Не допускається використання функцій
вищого порядку або функцій для роботи зі списками/послідовностями, що
використовуються як функції вищого порядку. Тим не менш, оригінальний список
цей варіант реалізації також не має змінювати, тому перед виконанням
деструктивних змін варто застосувати функцію copy-list (в разі необхідності).
Також реалізована функція не має бути функціоналом (тобто приймати на вхід
функції в якості аргументів).

## Варіант 15 (7)
Алгоритм сортування Шелла за незменшенням.

## Лістинг функції з використанням конструктивного підходу
```lisp

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

```

### Тестові набори
```lisp

 (defun check-functional-shell-alg (name input1 input2 expected)
 (format t "~:[FAILED~;passed~]... ~a~%"
 (equal (functional-shell-alg input1 input2) expected)
 name))
CHECK-FUNCTIONAL-SHELL-ALG

CL-USER> (defun test-functional-shell-alg ()
           (check-functional-shell-alg "test1" '(8 7 5 4 2 9) '(4 2 1) '(2 4 5 7 8 9))
           (check-functional-shell-alg "test2" '(8 7 6 5 4 3 2 1) '(4 2 1) '(1 2 3 4 5 6 7 8))
           (check-functional-shell-alg "test3" '(1 2 3 4 5 6 7 8) '(4 2 1) '(1 2 3 4 5 6 7 8))
           (check-functional-shell-alg "test4" '(2 2 9 9 2 2 3 3 6 6) '(4 2 1) '(2 2 2 2 3 3 6 6 9 9))
           (check-functional-shell-alg "test5" '(9 1 1 9 5 9) '(4 2 1) '(1 1 5 9 9 9)))
TEST-FUNCTIONAL-SHELL-ALG

```
### Тестування
```lisp

CL-USER> (test-functional-shell-alg)
passed... test1
passed... test2
passed... test3
passed... test4
passed... test5
NIL
CL-USER>

```

## Лістинг функції з використанням деструктивного підходу
```lisp
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

```
### Тестові набори
```lisp
CL-USER> (defun check-imper-shell-sort (name input1 input2 expected)
 (format t "~:[FAILED~;passed~]... ~a~%"
 (equal (imper-shell-sort input1 input2) expected)
 name))
CHECK-IMPER-SHELL-SORT
CL-USER> (defun test-imper-shell-sort()
           (check-imper-shell-sort "test1" '(8 2 1 4 2 1) '(4 2 1) '(1 1 2 2 4 8))
           (check-imper-shell-sort "test2" '(7 6 5 4 3 2 1) '(4 2 1) '(1 2 3 4 5 6 7))
           (check-imper-shell-sort "test3" '(1 2 3 4 5 6 7) '(4 2 1) '(1 2 3 4 5 6 7))
           (check-imper-shell-sort "test4" '(2 2 9 9 2 2 3 3 6 6) '(4 2 1) '(2 2 2 2 3 3 6 6 9 9))
           (check-imper-shell-sort "test5" '(9 1 1 9 5 9) '(4 2 1) '(1 1 5 9 9 9)))
TEST-IMPER-SHELL-SORT
```
### Тестування
```lisp
CL-USER> (test-imper-shell-sort)
passed... test1
passed... test2
passed... test3
passed... test4
passed... test5
NIL
CL-USER> 
```
