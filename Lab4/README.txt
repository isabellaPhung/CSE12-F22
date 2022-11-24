Isabella Phung 1702285
Spring 2022
Lab 4: CSV File Analysis
_____________
Description:
Program analyzes csv files in the user's Documents folder named "data.csv" in following format:
"Facebook,56\r\nApple,100\r\n"
lab4f22_testbench.asm must be run. Will output the numerical length of the file in bytes,
sum of all stock numbers, and will find the company with the highest stock.
_____________
Files:
lab4f22_testbench.asm - main program. Open and run in RARS. 
allocate_file_record_pointers.asm - required for csv analysis
income_from_record.asm - outputs numerical value of a stock
length_of_file.asm - calculates length of file
maxIncome.asm - finds stock with highest stock value
totalIncome.asm - sums total income from file
data.csv - example data input
Run code by assembling in RISCV Assembler RARS.
