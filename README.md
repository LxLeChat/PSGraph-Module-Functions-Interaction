# PS-Module-Functions-Dependency
Snippet to help find functions interaction within a PS Module

# How it works
First i exclude all "standard" cmdlets. (variable b)
then i use ast to create an array containing all the cmdlets i find in every file available under the specific path.
This better works in a well organized module. (One file, one function..., i'm currently in the process of doing something more awesome!)
at the end of the first loop you have ArrayOfFunctions, that contains all functions, and what functions are called inside their code.

You can stop their if you want, or you can pass ArrayOfFunctions to PSGraph

# Why i did it
I've tasked to study a huuuuuuge module, with no comment, no documentation etc...

# Example
Done on @lazyadmin ADSIPS Module
![alt text](https://github.com/LxLeChat/PS-Graph-Module-Functions-Interaction/ADSIPS.png "ADSIPS")
