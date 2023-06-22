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
f = open('rgb.txt', 'w')

for y in range(1080):
    for x in range(1920):
        # RGBを取得
        try:
            rgb = resized_img[y, x]
        except:
            rgb = [0, 0, 0]
        # RGBをテキストファイルに書き込む
        if x == 1919:
            f.write(str(rgb[0]) + "," + str(rgb[1]) + "," + str(rgb[2]) + "\n")
        else:
            f.write(str(rgb[0]) + "," + str(rgb[1]) + "," + str(rgb[2]) + " ")