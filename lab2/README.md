<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"
</p>
<p align="right"><b>Студентка</b>: <i>Павленко Людмила Петрівна група КВ-12</i><p>
<p align="right"><b>Рік</b>: <i>2024</i><p>

  ## Загальне завдання 
  Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за
можливості/необхідності використовуючи різні види рекурсії. Функції, які необхідно
реалізувати, задаються варіантом. Вимоги до функцій:
#### Пункт 1
Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового
списку, а не зміни наявного (вхідного).
#### Пункт 2
  Не допускається використання функцій вищого порядку чи стандартних функцій
для роботи зі списками, що не наведені в четвертому розділі навчального
посібника.
#### Пункт 3
  Реалізована функція не має бути функцією вищого порядку, тобто приймати функції
в якості аргументів
#### Пункт 4
  Не допускається використання псевдофункцій (деструктивного підходу)
#### Пункт 5
  Не допускається використання циклів.
<p> Кожна реалізована функція має бути протестована для різних тестових наборів. Тести
мають бути оформленні у вигляді модульних тестів. </p>
  
## Варіант 15

#### Пункт 1
Написати функцію spread-values , яка заміняє nil в списку на попередній не nil елемент:

```lisp

CL-USER> (spread-values ‘(nil 1 2 nil 3 nil nil 4 5))
(NIL 1 2 2 3 3 3 4 5)

```
#### Пункт 2
Написати функцію delete-duplicates , яка видаляє всі послідовні дублікати тих
елементів з вхідного списку атомів, послідовних дублікатів яких більше за задане
число:

```lisp

CL-USER> (delete-duplicates '(1 1 2 3 3 3 2 2 a a a b) 3)
(1 1 2 3 2 2 A B)

```

## Лістинг функції spread-values1
```lisp

CL-USER> (defun spread-values1 (lst &optional (num1 nil))
  (if (null lst)
      nil
      (if (null (car lst))
          (cons num1 (spread-values1 (cdr lst) num1))  
          (cons (car lst) (spread-values1 (cdr lst) (car lst))))))
SPREAD-VALUES1
CL-USER> (spread-values1 '(nil 1 2 nil 3 nil nil 4 5))
(NIL 1 2 2 3 3 3 4 5)

```

### Тестові набори
```lisp

(defun check-spread-values1 (name input expected)
  "Execute `spread-values1' on `input', compare result with `expected' and print comparison status."
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (spread-values1 input) expected)
          name))

```

### Тестування
```lisp
CL-USER> (defun test-spread-values1 ()
  (check-spread-values1 "test 1" '(nil 1 2 nil 3 nil nil 4 5) '(nil 1 2 2 3 3 3 4 5))
  (check-spread-values1 "test 2" '(1 2 3 nil nil nil) '(1 2 3 3 3 3))
  (check-spread-values1 "test 3" '(nil nil 1 nil 2 3 nil) '(nil nil 1 1 2 3 3))
  (check-spread-values1 "test 4" '(1 nil nil 2 nil nil) '(1 1 1 2 2 2))
  (check-spread-values1 "test 5" '() '()))
TEST-SPREAD-VALUES1
CL-USER> (test-spread-values1)
passed... test 1
passed... test 2
passed... test 3
passed... test 4
passed... test 5
NIL
```
## Лістинг функції new-delete-duplicates
```lisp

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

```
### Тестові набори
```lisp

CL-USER> (defun check-new-delete-duplicates (name input num-max expected)
  "Execute `new-delete-duplicates' on `input', compare result with `expected' and print comparison status."
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (new-delete-duplicates input num-max) expected)
          name))

```
### Тестування
```lisp
CL-USER> (defun test-new-delete-duplicates ()
  (check-new-delete-duplicates "test 1" '(1 1 2 3 3 3 2 2 a a a b) 3 '(1 1 2 3 2 2 A B))
  (check-new-delete-duplicates "test 2" '(1 1 1 2 2 2 3 3) 2 '(1 1 2 2 3))
  (check-new-delete-duplicates "test 3" '(a a a b b b c) 2 '(A B C))
  (check-new-delete-duplicates "test 4" '(1 nil nil 2 nil 3) 1 '(1 NIL 2 NIL 3))
  (check-new-delete-duplicates "test 5" '() 3 '()))
TEST-NEW-DELETE-DUPLICATES
CL-USER> (test-new-delete-duplicates)
passed... test 1
FAILED... test 2
passed... test 3
FAILED... test 4
passed... test 5
NIL

```
