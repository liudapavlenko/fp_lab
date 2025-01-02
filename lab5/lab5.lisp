; SLIME 2.24
CL-USER> (defun delimited-string (string delimiter)
  (loop for i = 0 then (1+ j)
        as j = (position delimiter string :start i)
        collect (subseq string i (or j (length string)))
        until (null j)))
DELIMITED-STRING
CL-USER> (defun read-csv (filepath)
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
READ-CSV
CL-USER>  (defun select (filepath)
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
SELECT
CL-USER> (defun write-csv (filepath data)
  (let ((header (mapcar #'car (car data)))) 
    (with-open-file (stream filepath :direction :output :if-exists :append :if-does-not-exist :create)
      (unless (file-length stream)
        (format stream "~{~a~^,~}~%" (mapcar #'symbol-name header)))
      (dolist (record data)
        (format stream "~{~a~^,~}~%"
                (mapcar (lambda (key) (cdr (assoc key record))) header))))))
WRITE-CSV
CL-USER> (defun print-table (table)
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
PRINT-TABLE
CL-USER> (defun convert-to-hashtable (record)
  (let ((hash (make-hash-table :test 'equal)))
    (dolist (pair record)
      (setf (gethash (car pair) hash) (cdr pair)))
    hash))
CONVERT-TO-HASHTABLE
CL-USER>  (defun test-read-and-print-table ()
  (let ((data (read-csv "C:/Users/Lyudmila/portacle/lab5/drone.csv")))
    (when data
      (format t "~%Test: read-csv and print-table~%")
      (print-table data))))
TEST-READ-AND-PRINT-TABLE
CL-USER> (defun test-select-and-print-table ()
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
TEST-SELECT-AND-PRINT-TABLE
CL-USER>  (defun test-convert-to-hashtable ()
  (flet ((convert-to-hashtable (data)
           (let ((hashtable (make-hash-table :test 'equal)))
             (dolist (pair data)
               (setf (gethash (car pair) hashtable) (cdr pair)))
             hashtable)))
    (let ((data '((:ID . "1") (:NAME . "Mavic") (:TYPE . "Professional"))))
      (format t "~%Test convert-to-hashtable~%")
      (let ((hashtable (convert-to-hashtable data)))
        (maphash (lambda (key value) (format t "~A: ~A~%" key value)) hashtable)))))
TEST-CONVERT-TO-HASHTABLE
CL-USER> (defun test-write-csv ()
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
TEST-WRITE-CSV
CL-USER> (defun check-all-tests ()
  (test-read-and-print-table)
  (test-select-and-print-table)
  (test-convert-to-hashtable)
  (test-write-csv))
CHECK-ALL-TESTS
CL-USER> 
