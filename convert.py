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
# gの7行目までをfに書き込む
for i in range(7):
    f.write(g.readline())


for y in range(1080):
    for x in range(1920):
        # RGBを取得
        try:
            rgb = resized_img[y, x]
        except:
            rgb = [0, 0, 0]
        # RGBをテキストファイルに書き込む
        #case ({v_count, h_count})
        #24'h000000: begin rgb_color = 24'b000000000000000000000000; end
        # rc means rgb_color
        f.write(f"24'h{y:03x}{x:03x}: begin rc = 24'h{rgb[2]:02x}{rgb[1]:02x}{rgb[0]:02x}; end\n")

f.write("endcase\n")
f.write("end\n")
f.write("endmodule")
f.close()
g.close()