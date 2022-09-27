from PIL import Image
#open charset and convert to greyscale
charset = Image.open("charset.png").convert("L")
outstr = ""
for y in range(0,charset.height,8) :
    for x in range(0,charset.width,8) :
        for iny in range(0,8):
            for inx in range(0,8):
                pixel = charset.getpixel((x+inx,y+iny))
                outstr += "0" if (pixel < 128) else "1"
        outstr += "\n"
print(outstr)
