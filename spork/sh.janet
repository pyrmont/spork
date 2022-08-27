###
### Shell utilties for Janet.
### sh.janet
###

(import ./path)

(defn exec-slurp
   "Read stdout of subprocess and return it trimmed in a string."
   [& args]
   (def proc (os/spawn args :px {:out :pipe}))
   (def out (get proc :out))
   (def buf @"")
   (ev/gather
     (:read out :all buf)
     (:wait proc))
   (string/trimr buf))

(defn rm
  "Remove a directory and all sub directories recursively."
  [path]
  (case (os/lstat path :mode)
    :directory (do
      (each subpath (os/dir path)
        (rm (path/join path subpath)))
      (os/rmdir path))
    nil nil # do nothing if file does not exist
    # Default, try to remove
    (os/rm path)))