f=open("Application/build/key_display.out", "r")
w=open("Processor/memory.txt", "w+")
lines = f.readlines()
count = 0
for l in lines:
    num = int(l,2)
    hex = '{:04x}'.format(num)
    w.write(hex+"\n");
    count = count + 1
for i in range(count,65536):
    w.write("0000\n")

f.close()
