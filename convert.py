import cv2

# Read image
img = cv2.imread("image.jpg")
# Convert to 1920x1080 （縦横比を維持したまま、このサイズにリサイズする）
height, width, channels = img.shape
new_height = 1080
new_width = int(width * new_height / height)
resized_img = cv2.resize(img, (new_width, new_height))

# rgbを取得する　1920x1080
# textファイルを作成する
f = open('./vpg_source/rgb.v', 'w')
g = open('template.txt', 'r')
# gの8行目までをfに書き込む
for i in range(8):
    f.write(g.readline())


for y in range(1080):
    for x in range(1920):
        # RGBを取得
        try:
            rgb = resized_img[y, x]
        except:
            rgb = [0, 0, 0]
        # RGBをテキストファイルに書き込む
        if x==0 and y==0:
            f.write("if (v_count == " + str(y) + " && h_count == " + str(x) + ") begin\n")
            f.write("    read_r = 8'b" + format(rgb[0], '08b') + ";\n")
            f.write("    read_g = 8'b" + format(rgb[1], '08b') + ";\n")
            f.write("    read_b = 8'b" + format(rgb[2], '08b') + ";\n")
            f.write("end\n")
        else:
            f.write("else if (v_count == " + str(y) + " && h_count == " + str(x) + ") begin\n")
            f.write("    read_r = 8'b" + format(rgb[0], '08b') + ";\n")
            f.write("    read_g = 8'b" + format(rgb[1], '08b') + ";\n")
            f.write("    read_b = 8'b" + format(rgb[2], '08b') + ";\n")
            f.write("end\n")

f.write("end\n")
f.write("endmodule")
f.close()
g.close()