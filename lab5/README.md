<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 5</b><br/>
"Робота з базою даних"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент(-ка)</b>: Павленко Людмила Петрівна  група КВ-12</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
В роботі необхідно реалізувати утиліти для роботи з базою даних, заданою за варіантом
(п. 5.1.1). База даних складається з кількох таблиць. Таблиці представлені у вигляді CSV
файлів. При зчитуванні записів з таблиць, кожен запис має бути представлений певним
типом в залежності від варіанту: структурою, асоціативним списком або геш-таблицею.  

1. Визначити структури або утиліти для створення записів з таблиць (в залежності від
типу записів, заданого варіантом).
2. Розробити утиліту(-и) для зчитування таблиць з файлів.
3. Розробити функцію select , яка отримує на вхід шлях до файлу з таблицею, а
також якийсь об'єкт, який дасть змогу зчитати записи конкретного типу або
структури. Це може бути ключ, список з якоюсь допоміжною інформацією, функція і
т. і. За потреби параметрів може бути кілька. select повертає лямбда-вираз,
який, в разі виклику, виконує "вибірку" записів з таблиці, шлях до якої було
передано у select . При цьому лямбда-вираз в якості ключових параметрів може
отримати на вхід значення полів записів таблиці, для того щоб обмежити вибірку
лише заданими значеннями (виконати фільтрування). Вибірка повертається у
вигляді списку записів.
4. Написати утиліту(-и) для запису вибірки (списку записів) у файл.
5. Написати функції для конвертування записів у інший тип (в залежності від
варіанту):
структури у геш-таблиці
геш-таблиці у асоціативні списки
асоціативні списки у геш-таблиці
6. Написати функцію(-ї) для "красивого" виводу записів таблиці.
## Варіант 3
База даних: Виробництво дронів; Тип записів: Асоціативний список
## Лістинг реалізації завдання
```lisp
(defun delimited-string (string delimiter)
  (loop for i = 0 then (1+ j)
        as j = (position delimiter string :start i)
        collect (subseq string i (or j (length string)))
        until (null j)))

(defun read-csv (filepath)
  (with-open-file (stream filepath :if-does-not-exist nil)
    (when stream
      (let ((header (mapcar (lambda (x) 
                              (intern (string-trim '(#\Space #\,) x) 'keyword))
                            (delimited-string (read-line stream) #\,)))) ; Process headers
        (loop for line = (read-line stream nil)
              while line
              collect
              (let ((values (mapcar (lambda (x) (string-trim '(#\Space #\,) x))
                                    (delimited-string line #\,)))) ; Trim each value
                (let ((record (loop for key in header
                                    for val in values
                                    collect (cons key val))))
                  record)))))))

(defun select (filepath)
  (let ((table (read-csv filepath)))
    (when table
      (lambda (&rest conditions)
        (loop for record in table
              when (every (lambda (cond)
                            (let ((key (car cond))
                                  (value (cdr cond)))
                              (and (assoc key record)
                                   (equal (string-trim '(#\Space) (cdr (assoc key record)))
                                          (string-trim '(#\Space) value)))))
                          conditions)
              collect record)))))

(defun write-csv (filepath data)
  (let ((header (mapcar #'car (car data)))) 
    (with-open-file (stream filepath :direction :output :if-exists :append :if-does-not-exist :create)
      (unless (file-length stream)
        (format stream "~{~a~^,~}~%" (mapcar #'symbol-name header)))
      (dolist (record data)
        (format stream "~{~a~^,~}~%"
                (mapcar (lambda (key) (cdr (assoc key record))) header))))))
(defun print-table (table)
  (when table
    (let* ((headers (mapcar #'car (car table)))
           (max-lengths (make-hash-table)))
      (dolist (header headers)
        (setf (gethash header max-lengths)
              (length (string-upcase (symbol-name header)))))
      (dolist (record table)
        (dolist (key-value record)
          (let ((key (car key-value))
                (value (princ-to-string (cdr key-value))))
            (setf (gethash key max-lengths)
                  (max (gethash key max-lengths) (length value))))))

      (format t "|")
      (dolist (header headers)
        (format t " ~vA |" (gethash header max-lengths) (string-upcase (symbol-name header))))
      (terpri)

      (format t "|")
      (dolist (header headers)
        (format t " ~A |" (make-string (gethash header max-lengths) :initial-element #\-)))
      (terpri)

      (dolist (record table)
        (format t "|")
        (dolist (header headers)
          (format t " ~vA |"
                  (gethash header max-lengths)
                  (or (cdr (assoc header record)) "")))
        (terpri)))))

 (defun convert-to-hashtable (record)
  (let ((hash (make-hash-table :test 'equal)))
    (dolist (pair record)
      (setf (gethash (car pair) hash) (cdr pair)))
    hash))
```
### Тестові набори та утиліти
```lisp
(defun test-read-and-print-table ()
  (let ((data (read-csv "C:/Users/Lyudmila/portacle/lab5/drone.csv")))
    (when data
      (format t "~%Test: read-csv and print-table~%")
      (print-table data))))

(defun test-select-and-print-table ()
  (let ((selector-manufacturers (select "C:/Users/Lyudmila/portacle/lab5/drone_manufacturers.csv"))
        (selector-drone (select "C:/Users/Lyudmila/portacle/lab5/drone.csv")))
    (when selector-manufacturers
      (let ((selected-data-manufacturers (funcall selector-manufacturers '(:NAME . "DJI"))))
        (if selected-data-manufacturers
            (progn
              (format t "~%Test select for drone_manufacturers.csv~%")
              (format t "~A~%" selected-data-manufacturers))
            (format t "~%No data found in drone_manufacturers.csv~%"))))

    (when selector-drone
      (let ((selected-data-drone (funcall selector-drone '(:TYPE . "Professional"))))
        (if selected-data-drone
            (progn
              (format t "~%Test select for drone.csv~%")
              (format t "~A~%" selected-data-drone))
            (format t "~%No data found in drone.csv~%"))))))

(defun test-convert-to-hashtable ()
  (flet ((convert-to-hashtable (data)
           (let ((hashtable (make-hash-table :test 'equal)))
             (dolist (pair data)
               (setf (gethash (car pair) hashtable) (cdr pair)))
             hashtable)))
    (let ((data '((:ID . "1") (:NAME . "Mavic") (:TYPE . "Professional"))))
      (format t "~%Test convert-to-hashtable~%")
      (let ((hashtable (convert-to-hashtable data)))
        (maphash (lambda (key value) (format t "~A: ~A~%" key value)) hashtable)))))


(defun test-write-csv ()
  (let ((initial-drone-manufacturers (read-csv "C:/Users/Lyudmila/portacle/lab5/drone_manufacturers.csv"))
        (initial-drone-data (read-csv "C:/Users/Lyudmila/portacle/lab5/drone.csv"))
        (new-drone-manufacturers '(((:ID . "3") (:NAME . "Parrot") (:COUNTRY . "France"))
                                    ((:ID . "4") (:NAME . "Autel Robotics") (:COUNTRY . "USA"))
                                    ((:ID . "5") (:NAME . "Skydio") (:COUNTRY . "USA"))))
        (new-drone-data '(((:ID . "3") (:NAME . "Phantom") (:TYPE . "Consumer") (:PRICE . "150000"))
                           ((:ID . "4") (:NAME . "EVO II") (:TYPE . "Professional") (:PRICE . "120000"))
                           ((:ID . "5") (:NAME . "Parrot Anafi") (:TYPE . "Consumer") (:PRICE . "90000")))))
    (format t "~%Initial Drone Manufacturers Table:~%")
    (print-table initial-drone-manufacturers)
    (format t "~%Initial Drone Data Table:~%")
    (print-table initial-drone-data)

    (write-csv "C:/Users/Lyudmila/portacle/lab5/drone_manufacturers.csv" new-drone-manufacturers)
    (write-csv "C:/Users/Lyudmila/portacle/lab5/drone.csv" new-drone-data)

    (let ((updated-drone-manufacturers (read-csv "C:/Users/Lyudmila/portacle/lab5/drone_manufacturers.csv"))
          (updated-drone-data (read-csv "C:/Users/Lyudmila/portacle/lab5/drone.csv")))
      (format t "~%Updated Drone Manufacturers Table:~%")
      (print-table updated-drone-manufacturers)
      (format t "~%Updated Drone Data Table:~%")
      (print-table updated-drone-data))))

(defun check-all-tests ()
  (test-read-and-print-table)
  (test-select-and-print-table)
  (test-convert-to-hashtable)
  (test-write-csv))
```
### Тестування
```lisp
CL-USER> (check-all-tests)

Test: read-csv and print-table
| ID | NAME        | TYPE         | PRICE   |
| -- | ----------- | ------------ | ------- |
| 1  | Mavic       | Professional | 179500  |
| 2  | Switchblade | Professional | 100000  |

Test select for drone_manufacturers.csv
(((ID . 1) (NAME . DJI) (COUNTRY
 . China
)))

Test select for drone.csv
(((ID . 1) (NAME . Mavic) (TYPE . Professional) (PRICE
 . 179500
))
 ((ID . 2) (NAME . Switchblade) (TYPE . Professional) (PRICE
 . 100000
)))

Test convert-to-hashtable
ID: 1
NAME: Mavic
TYPE: Professional

Initial Drone Manufacturers Table:
| ID | NAME          | COUNTRY  |
| -- | ------------- | -------- |
| 1  | DJI           | China    |
| 2  | AeroVironment | USA      |

Initial Drone Data Table:
| ID | NAME        | TYPE         | PRICE   |
| -- | ----------- | ------------ | ------- |
| 1  | Mavic       | Professional | 179500  |
| 2  | Switchblade | Professional | 100000  |

Updated Drone Manufacturers Table:
| ID | NAME           | COUNTRY  |
| -- | -------------- | -------- |
| 1  | DJI            | China    |
| 2  | AeroVironment  | USA      |
| 3  | Parrot         | France   |
| 4  | Autel Robotics | USA      |
| 5  | Skydio         | USA      |

Updated Drone Data Table:
| ID | NAME         | TYPE         | PRICE   |
| -- | ------------ | ------------ | ------- |
| 1  | Mavic        | Professional | 179500  |
| 2  | Switchblade  | Professional | 100000  |
| 3  | Phantom      | Consumer     | 150000  |
| 4  | EVO II       | Professional | 120000  |
| 5  | Parrot Anafi | Consumer     | 90000   |
NIL
```
