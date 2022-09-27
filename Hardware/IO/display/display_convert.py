import random

filepath = './display_text.txt'
with open(filepath) as fp:
   line = fp.readline()
   cnt = 1
   while line:
      bytes = bytearray(str.encode(line.replace("\n","").replace("\r","")))
      while len(bytes) != 80:
         bytes.extend(str.encode(" "))
      finstr = ""
      for i in bytes:
         color = ((random.randint(0,3)<<4)|(random.randint(0,3)<<2)|(random.randint(0,3)));
         if i == 10:
            i = 0;
         if i in str.encode("`V\\|/_-,'()"):
            color = 0x35;
         finstr = finstr + '{:02X}{:02X} '.format(color,i)
      print(finstr)
      line = fp.readline()
      cnt += 1
   while (cnt <= 60):
      print(''.join('1F{:02X} '.format(0) for i in range(1,81)))
      cnt += 1
