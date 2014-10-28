# Mapedit

Mapedit includes 3 tools for editing and viewing map data:  
 - checker - searches for a node and prints coordinates of found nodes  
 - list - lists all nodes in database  
 - save - copies map region into another map  

## Dependencies
make, gcc, zlib  

## Compiling and using
Compiling: 
```
make 
```  
Using:  
```
./bin/checker [/path/to/map] [node]  
./bin/list [/path/to/map]  
./bin/save [/path/to/input] [/path/to/output] [X Y Z] [X Y Z] 
```   
Example:  
```
./bin/checker ~/minetest/worlds/example_map default:stone   
./bin/list ~/minetest/worlds/example_map  
./bin/save ~/minetest/worlds/oldworld ~/minetest/worlds/newworld -300 -256 -400 500 70 355 
```
