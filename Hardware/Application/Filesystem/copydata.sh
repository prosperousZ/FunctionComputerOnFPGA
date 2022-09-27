#write
dd if=/dev/urandom of=/dev/sdb bs=1024 count=1 skip=0
dd if=testfile of=/dev/sdb bs=1024 count=1 skip=1
#read sd card first 65 kilobytes
dd if=/dev/sdb bs=2048 count=1 skip=0 | hexdump -C
#Adding More comments
