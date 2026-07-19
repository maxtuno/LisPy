(defvar *greeting* "Hello")
(defvar *planet* "World")
(defvar *year* 2026)

msg = f"Greeting: {builtins.lispy_callback_c('*greeting*')}, Planet: {builtins.lispy_callback_c('*planet*')}"

(print @msg)

greeting = builtins.lispy_callback_c("*greeting*")
planet = builtins.lispy_callback_c("*planet*")

print("Direct Python print:")
print(f"  {greeting}")
print(f"  {planet}")

counter = 0
for i in range(3):
    counter = builtins.lispy_callback_c("*year*") + counter

(print @counter)
