# Tiny (TEA) encodeion and decodeion program 

## Program Description: using base64 to encode and decode string


### **Installation**
1. run ```nasm -f elf base64.asm``` to create o file
2. run ```ld -m elf_i386 base64.o -o base64``` to link the o file and create executable file
3. you can now use the program using ```./base64 -e -t "Hello World"```

### **Arguments**

| Arg | Description                                                          |
| --- | -------------------------------------------------------------------- |
| -e  | to encode text                                                      |
| -d  | to decode text                                                      |
| -t  | to pass the text from the standard input                             |
| -f  | to pass the file path from which the text is be used                 |
| -o  | (optional) to pass a file path to which the processed text is stored |
|     |                                                                      |

### **Usage**
``` ./base64 -e -t "hello" ```
- to encode text from stdin and print the result in the stdout

``` ./base64 -e -t "hello" -o "./hello.bin"  ```
- to encode text from stdin and store the result in 'hello.bin' file

``` ./base64 -d -f ./hello.bin ```
- to decode text from 'hello.bin' and print the result in the stdout
